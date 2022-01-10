import {
    PublicKey,
    Transaction,
    TransactionInstruction,
    SystemProgram,
    Connection,
    Keypair,
    Signer,
} from '@solana/web3.js';
import {Buffer} from 'buffer';
import { Token as SPLToken, TOKEN_PROGRAM_ID } from "@solana/spl-token";
import BN from 'bn.js';
import {
    CreateAndTransferToAccountInput,
    CreateAssociatedTokenInput,
    NativeTransferInput,
    GetTransactionSignatureByMemoInpt,
    CreateAssociatedTokenOutput,
    TransferOutput,
    SwapTxInput,
    InitializeSwapOutput,
} from './types';
import {
    transfer,
    memoInstruction,
    Token,
    TokenAccountLayout,
    WRAPPED_SOL_MINT,
    ASSOCIATED_TOKEN_PROGRAM_ID,
    createAssociatedTokenAccountIx,
    SOL_MINT,
    DEX_PID
} from './instructions'; //assertOwner,
import { Provider } from '@project-serum/anchor';
import { u64 } from "@solana/spl-token";
import { TokenListProvider } from '@solana/spl-token-registry';
import { Market, OpenOrders } from '@project-serum/serum';

export const FAILED_TO_FIND_ACCOUNT = 'Failed to find account';
export const INVALID_ACCOUNT_OWNER = 'Invalid account owner';
export const INVALID_AUTHORITY = 'Invalid authority';
export const INVALID_PAYER_ADDRESS = 'Invalid payer address';
export const ACCOUNT_ALREADY_CANCELED = 'Account already canceled';
export const ACCOUNT_ALREADY_SETTLED = 'Account already settled';
export const INVALID_SIGNATURE = 'Invalid signature';
export const AMOUNT_MISMATCH = 'Amount mismatch';
export const FEE_MISMATCH = 'Fee mismatch';
export const TRANSACTION_SEND_ERROR = 'Transaction send error';
export { Transaction, PublicKey } from '@solana/web3.js';

const MARKET_CACHE = new Map();
import { Swap } from '@project-serum/swap';

export class WalletServiceClient {
    private connection: Connection;

    constructor(rpcUrl: string) {
        this.connection = new Connection(rpcUrl);
    }

    createTransferBetweenSplTokenAccounts = (input: CreateAndTransferToAccountInput): TransferOutput => {
        const transaction = new Transaction();
        const walletAddress = new PublicKey(input.walletAddress);
        const sourcePublicKey = new PublicKey(input.sourcePublicKey);
        const destinationPublicKey = new PublicKey(input.destinationPublicKey);
        const transferBetweenAccountsTxn = createTransferBetweenSplTokenAccountsInstructionInternal(
            walletAddress, sourcePublicKey, destinationPublicKey, new u64(input.amount), input.memo,
        );
        transaction.add(transferBetweenAccountsTxn);
        transaction.recentBlockhash = input.recentBlockhash;
        transaction.feePayer = walletAddress;
        // transaction.partialSign(this.feePayer);
        const signatures = transaction.signatures.filter(signature => !!signature.signature)
            .map(signature => signature.signature!.toString('base64'));
        return {
            signatures,
            message: transaction.serializeMessage().toString('base64'),
        }
    }

    createAndTransferToAccount = async (input: CreateAndTransferToAccountInput): Promise<TransferOutput> => {
        const walletAddress = new PublicKey(input.walletAddress);
        const tokenMintAddress = new PublicKey(input.tokenMintAddress);
        const sourcePublicKey = new PublicKey(input.sourcePublicKey);
        const destinationPublicKey = new PublicKey(input.destinationPublicKey);
        const associatedTokenAddress = await findAssociatedTokenAddress(
            destinationPublicKey,
            tokenMintAddress,
        );
        const createAccountInstruction = createAssociatedTokenAccountIx(
            walletAddress,
            destinationPublicKey,
            tokenMintAddress,
            associatedTokenAddress
        );
        const transaction = new Transaction();
        transaction.add(createAccountInstruction);
        const transferBetweenAccountsTxn = createTransferBetweenSplTokenAccountsInstructionInternal(
            walletAddress, sourcePublicKey, associatedTokenAddress, new u64(input.amount), input.memo,
        );
        transaction.add(transferBetweenAccountsTxn);
        transaction.recentBlockhash = input.recentBlockhash;
        transaction.feePayer = walletAddress;
        // transaction.partialSign(this.feePayer,);
        const signatures = transaction.signatures.filter(signature => !!signature.signature)
            .map(signature => signature.signature!.toString('base64'));
        return {
            signatures,
            message: transaction.serializeMessage().toString('base64'),
        }
    }

    createAssociatedTokenAccount = async (input: CreateAssociatedTokenInput): Promise<CreateAssociatedTokenOutput> => {
        const walletAddress = new PublicKey(input.walletAddress);
        const tokenMintAddress = new PublicKey(input.tokenMintAddress);
        const associatedTokenAddress = await findAssociatedTokenAddress(
            walletAddress,
            tokenMintAddress,
        );
        const ix = createAssociatedTokenAccountIx(
            walletAddress,
            walletAddress,
            tokenMintAddress,
            associatedTokenAddress
        );
        const tx = new Transaction({ feePayer: walletAddress });
        tx.recentBlockhash = input.recentBlockhash;
        tx.add(ix);
        // tx.sign(this.feePayer);
        const signatures = tx.signatures.filter(signature => !!signature.signature)
            .map(signature => signature.signature!.toString('base64'));
        return {
            signatures,
            address: associatedTokenAddress.toBase58(),
            message: tx.serializeMessage().toString('base64'),
        }
    }


    findTransactionSignatureByMemo = async (input: GetTransactionSignatureByMemoInpt): Promise<string | null> => {
        const transactionStatuses = await this.connection.getConfirmedSignaturesForAddress2(new PublicKey(input.walletAddress), {
            until: input.until,
        })
        const transaction = transactionStatuses.find(status => status.memo === input.memo);
        if (!transaction) {
            return null;
        }
        return transaction.signature
    }

    getTokenAccountInfoOrNull = async (
        walletAddress: PublicKey,
    ): Promise<Token | null> => {
        try {
            return await this.getTokenAccountInfo(walletAddress);
        } catch (err: any) {
            // INVALID_ACCOUNT_OWNER can be possible if the associatedAddress has
            // already been received some lamports (= became system accounts).
            // Assuming program derived addressing is safe, this is the only case
            // for the INVALID_ACCOUNT_OWNER in this code-path
            if (
                err.message === FAILED_TO_FIND_ACCOUNT ||
                err.message === INVALID_ACCOUNT_OWNER
            ) {
                // Now this should always succeed
                return null;
            } else {
                throw err;
            }
        }
    }

    getTokenAccountInfo = async (walletAddress: PublicKey,): Promise<Token> => {
        const info = await this.connection.getAccountInfo(walletAddress);
        if (!info) {
            throw new Error(FAILED_TO_FIND_ACCOUNT);
        }
        if (!info.owner.equals(TOKEN_PROGRAM_ID)) {
            throw new Error(INVALID_ACCOUNT_OWNER);
        }
        if (info.data.length !== TokenAccountLayout.span) {
            throw new Error(`Invalid account size`);
        }

        const data = Buffer.from(info.data);
        const accountInfo = TokenAccountLayout.decode(data) as any;
        accountInfo.address = walletAddress;
        accountInfo.mint = new PublicKey(accountInfo.mint);
        accountInfo.owner = new PublicKey(accountInfo.owner);
        accountInfo.amount = new BN(accountInfo.amount, 10, "le")

        if (accountInfo.delegateOption === 0) {
            accountInfo.delegate = null;
            accountInfo.delegatedAmount = new BN(0);
        } else {
            accountInfo.delegate = new PublicKey(accountInfo.delegate);
            accountInfo.delegatedAmount = new BN(accountInfo.delegatedAmount, 10, "le");
        }

        accountInfo.isInitialized = accountInfo.state !== 0;
        accountInfo.isFrozen = accountInfo.state === 2;

        if (accountInfo.isNativeOption === 1) {
            accountInfo.rentExemptReserve = new BN(accountInfo.isNative, 10, "le")
            accountInfo.isNative = true;
        } else {
            accountInfo.rentExemptReserve = null;
            accountInfo.isNative = false;
        }

        if (accountInfo.closeAuthorityOption === 0) {
            accountInfo.closeAuthority = null;
        } else {
            accountInfo.closeAuthority = new PublicKey(accountInfo.closeAuthority);
        }
        return accountInfo as Token
    }

    initializeSwapTransaction = async (
        input: SwapTxInput): Promise<InitializeSwapOutput[]> => {
        const walletAddress = new PublicKey(input.walletAddress);
        let fromMintAddress = new PublicKey(input.fromMintAddress);
        let toMintAddress = new PublicKey(input.toMintAddress);
        const quoteMintAddress = new PublicKey(input.quoteMintAddress);
        const amount = new u64(input.amount);
        const minExpectedSwapAmount = new u64(input.minExpectedSwapAmount);
        const minExchangeRate = {
          ...input.minExchangeRate,
          rate: new u64(input.minExchangeRate.rate)
        }
        const isSol = fromMintAddress.equals(SOL_MINT) || toMintAddress.equals(SOL_MINT);
        const wrappedSolAccount = isSol ? Keypair.generate() : undefined;
      
        let fromWalletAddr: PublicKey | undefined = fromMintAddress.equals(SOL_MINT)
          ? wrappedSolAccount!.publicKey
          : input.fromWalletAddress ? new PublicKey(input.fromWalletAddress) : undefined;
      
        let toWalletAddr: PublicKey | undefined = toMintAddress.equals(SOL_MINT)
          ? wrappedSolAccount!.publicKey
          : input.toWalletAddress ? new PublicKey(input.toWalletAddress) : undefined;
        const anchorWallet = {
          publicKey: walletAddress,
          signTransaction: async (tx: Transaction) => {
            return tx;
          },
          signAllTransactions: async (txs: Transaction[]) => {
            return txs;
          }
        }
        const provider = new Provider(
          this.connection,
          anchorWallet,
          Provider.defaultOptions(),
        );
        const tokenList = await new TokenListProvider().resolve();
        const swap = new Swap(provider, tokenList);
        const fromMarket = await getMarket(new PublicKey(input.fromMarketAddress), this.connection);
        const transaction = new Transaction({ feePayer: walletAddress });
        const signers: Keypair[] = [];
        let fromOpenOrders = await OpenOrders.findForMarketAndOwner(
          this.connection,
          fromMarket.address,
          walletAddress,
          DEX_PID,
        )
      
        let fromOO = fromOpenOrders[0] ? fromOpenOrders[0].address : undefined
        let toOO;
        let toMarket;
        if (input.toMarketAddress) {
          toMarket = await getMarket(new PublicKey(input.toMarketAddress), this.connection);
        }
        if (toMarket) {
          let toOpenOrders = await OpenOrders.findForMarketAndOwner(
            this.connection,
            toMarket.address,
            walletAddress,
            DEX_PID,
          )
          toOO = toOpenOrders[0] ? toOpenOrders[0].address : undefined;
        }
      
        let createAtaFrom = !fromWalletAddr;
        let createAtaTo = !toWalletAddr;
      
        if (createAtaFrom) {
          fromWalletAddr = await findAssociatedTokenAddress(
            walletAddress,
            fromMintAddress,
          );
          const tokenInfo = await this.getTokenAccountInfoOrNull(
            fromWalletAddr,
          );
          createAtaFrom = !tokenInfo;
        }
      
        if (createAtaTo) {
          toWalletAddr = await findAssociatedTokenAddress(
            walletAddress,
            toMintAddress,
          );
          const tokenInfo = await this.getTokenAccountInfoOrNull(
            toWalletAddr,
          );
          createAtaTo = !tokenInfo;
        }
      
        const swapParams = {
          amount,
          minExpectedSwapAmount,
          minExchangeRate,
          fromMarket,
          toMarket,
          fromMint: fromMintAddress.equals(SOL_MINT) ? WRAPPED_SOL_MINT : fromMintAddress,
          toMint: toMintAddress.equals(SOL_MINT) ? WRAPPED_SOL_MINT : toMintAddress,
          quoteMint: quoteMintAddress,
          fromWallet: fromWalletAddr!,
          toWallet: toWalletAddr!,
          fromOpenOrders: fromOO,
          toOpenOrders: toOO,
        };
        const txs = await swap.swapTxs(swapParams);
        if (isSol) {
          const { tx: wrapIx, signers: wrapSigners } = await wrapSol(
            walletAddress,
            wrappedSolAccount as Keypair,
            fromMintAddress,
            amount,
            this.connection,
          );
          const { tx: unwrapIx, signers: unwrapSigners } = unwrapSol(
            walletAddress,
            wrappedSolAccount as Keypair,
          );
          transaction.add(...wrapIx);
          if (createAtaFrom) {
            transaction.add(createAssociatedTokenAccountIx(
              walletAddress,
              walletAddress,
              fromMintAddress,
              fromWalletAddr!
            ))
          }
          if (createAtaTo) {
            transaction.add(createAssociatedTokenAccountIx(
              walletAddress,
              walletAddress,
              toMintAddress,
              toWalletAddr!
            ))
          }
          transaction.add(txs[0].tx);
          transaction.add(unwrapIx);
          txs[0].tx = transaction;
          txs[0].signers.push(...signers);
          txs[0].signers.push(...wrapSigners);
          txs[0].signers.push(...unwrapSigners);
        } else {
          if (createAtaFrom) {
            transaction.add(createAssociatedTokenAccountIx(
              walletAddress,
              walletAddress,
              fromMintAddress,
              fromWalletAddr!
            ))
          }
          if (createAtaTo) {
            transaction.add(createAssociatedTokenAccountIx(
              walletAddress,
              walletAddress,
              toMintAddress,
              toWalletAddr!
            ))
          }
          transaction.add(txs[0].tx);
          txs[0].tx = transaction;
          txs[0].signers.push(...signers);
        }
        return txs.map(transaction => {
          transaction.tx.recentBlockhash = input.recentBlockhash;
          const allSigners = transaction.signers || [];
          if (allSigners.length) {
            transaction.tx.partialSign(...allSigners as Signer[]);
          }
          const signatures = transaction.tx.signatures.filter(signature => !!signature.signature)
          .map(signature => signature.signature!.toString('base64'));
          return {
            message: transaction.tx.serializeMessage().toString('base64'),
            signatures: signatures,
          }
        });
      }

    nativeTransferTx = (
        input: NativeTransferInput
    ): TransferOutput => {
        const walletAddress = new PublicKey(input.walletAddress);
        const transaction = new Transaction().add(
            SystemProgram.transfer({
                fromPubkey: new PublicKey(input.walletAddress),
                toPubkey: new PublicKey(input.destinationPublicKey),
                lamports: (new u64(input.amount)).toNumber(),
            }),
        );
        transaction.recentBlockhash = input.recentBlockhash;
        transaction.feePayer = walletAddress;
        const signatures = transaction.signatures.filter(signature => !!signature.signature)
            .map(signature => signature.signature!.toString('base64'));
        return {
            signatures,
            message: transaction.serializeMessage().toString('base64'),
        }
    }
}

const wrapSol = async (
    walletAddress: PublicKey,
    wrappedSolAccount: Keypair,
    fromMint: PublicKey,
    amount: BN,
    connection: Connection,
): Promise<{ tx: TransactionInstruction[]; signers: Array<Keypair> }> => {
    const tx: TransactionInstruction[] = [];
    const signers = [wrappedSolAccount];
    // Create new, rent exempt account.
    tx.push(
        SystemProgram.createAccount({
            fromPubkey: walletAddress,
            newAccountPubkey: wrappedSolAccount.publicKey,
            lamports: await SPLToken.getMinBalanceRentForExemptAccount(
                connection
            ),
            space: 165,
            programId: TOKEN_PROGRAM_ID,
        })
    );
    // Transfer lamports. These will be converted to an SPL balance by the
    // token program.
    if (fromMint.equals(SOL_MINT)) {
        tx.push(
            SystemProgram.transfer({
                fromPubkey: walletAddress,
                toPubkey: wrappedSolAccount.publicKey,
                lamports: amount.toNumber(),
            })
        );
    }
    // Initialize the account.
    tx.push(
        SPLToken.createInitAccountInstruction(
            TOKEN_PROGRAM_ID,
            WRAPPED_SOL_MINT,
            wrappedSolAccount.publicKey,
            walletAddress
        )
    );
    return { tx, signers };
}

function unwrapSol(
    walletAddress: PublicKey,
    wrappedSolAccount: Keypair,
): { tx: TransactionInstruction; signers: Array<Keypair> } {
    const tx = SPLToken.createCloseAccountInstruction(
        TOKEN_PROGRAM_ID,
        wrappedSolAccount.publicKey,
        walletAddress,
        walletAddress,
        []
    )
    return { tx, signers: [] };
}

export const findAssociatedTokenAddress = async (
    walletAddress: PublicKey,
    tokenMintAddress: PublicKey,
): Promise<PublicKey> => {
    return (
        await PublicKey.findProgramAddress(
            [
                walletAddress.toBuffer(),
                TOKEN_PROGRAM_ID.toBuffer(),
                tokenMintAddress.toBuffer(),
            ],
            ASSOCIATED_TOKEN_PROGRAM_ID,
        )
    )[0];
}


const createTransferBetweenSplTokenAccountsInstructionInternal = (
    ownerPublicKey: PublicKey,
    sourcePublicKey: PublicKey,
    destinationPublicKey: PublicKey,
    amount: u64,
    memo?: string,
): Transaction => {
    const transaction = new Transaction().add(
        transfer(sourcePublicKey, destinationPublicKey, amount, ownerPublicKey),
    );
    if (memo) {
        transaction.add(memoInstruction(memo));
    }
    return transaction;
}

export const getMarket = async (marketAddress: PublicKey, connection: Connection): Promise<Market> => {
    let market = MARKET_CACHE.get(marketAddress.toString());
    if (!market) {
        market = await Market.load(connection, marketAddress, {}, DEX_PID);
        MARKET_CACHE.set(marketAddress.toString(), market);
    }
    return market;
}

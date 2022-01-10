export interface CreateAssociatedTokenInput {
    walletAddress: string;
    tokenMintAddress: string;
    recentBlockhash: string;
}


export interface CreateAssociatedTokenOutput {
    address: string;
    message: string;
    signatures: string[];
}

export interface TransferOutput {
    message: string;
    signatures: string[];
}


export interface CreateAndTransferToAccountInput {
    walletAddress: string;
    tokenMintAddress: string;
    sourcePublicKey: string;
    destinationPublicKey: string;
    amount: string;
    recentBlockhash: string;
    memo?: string;
}

export interface NativeTransferInput {
    walletAddress: string;
    destinationPublicKey: string;
    recentBlockhash: string;
    amount: string;
}

export interface InitializePaymentInput {
    walletAddress: string;
    tokenAccountAddress: string;
    tokenMintAddress: string;
}

export interface InitializePaymentOutput {
    message: string;
    signatures: Sig[];
    escrowAddress: string;
}

export interface InitializeSwapOutput {
    message: string;
    signatures: String[];
}

export interface SendPaymentInput {
    message: string;
    signatures: Sig[];
    orderId: string;
}

export interface Sig {
    pubKey: string;
    signature?: string | null;
}

export interface InitializePaymentInput {
    walletAddress: string;
    tokenAccountAddress: string;
    tokenMintAddress: string;
    amount: string;
    memo?: string;
}

export interface SPLPaymentInput {
    tokenAccountAddress: string;
    tokenMintAddress: string;
    amount: string;
    memo?: string;
}

export interface SendPaymentInput {
    message: string;
    signatures: Sig[];
}

export interface SettlePaymentInput {
    walletAddress: string;
    amount: string;
    escrowAddress: string
    memo?: string;
    fee?: number;
}

export interface SettleAndTransferInput {
    walletAddress: string;
    transferTokenMintAddress: string;
    amountToSettle: string;
    amountToTransfer: string;
    escrowAddress: string
    memo?: string;
    fee?: string;
}

export interface CancelPaymentInput {
    escrowAddress: string;
    memo?: string;
}

export interface CancelPaymentOutput {
    signature: string,
}

export interface ClosePaymentInput {
    escrowAddress: string
    memo?: string;
}

export interface SettlePaymentOutput {
    signature: string,
    destinationWalletAddress: string
}

export interface GetTransactionSignatureByMemoInpt {
    walletAddress: string;
    until?: string;
    memo: string;
}

export interface SwapExchangeRate {
    rate: string;
    fromDecimals: number;
    quoteDecimals: number,
    strict: boolean,
};

export interface SwapTxInput {
    walletAddress: string;
    amount: string;
    fromWalletAddress?: string;
    toWalletAddress?: string;
    quoteWalletAddress: string;
    fromMintAddress: string;
    toMintAddress: string;
    quoteMintAddress: string;
    minExchangeRate: SwapExchangeRate;
    minExpectedSwapAmount: string;
    fromMarketAddress: string;
    toMarketAddress?: string;
    recentBlockhash?: string;
    memo?: string;
}
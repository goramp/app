// import 'dart:async';
// import 'dart:convert';
// import 'package:goramp/utils/index.dart';
// import 'package:solana/solana.dart';

// class TokenUtil {
//   static Future<String> findAssociatedTokenAddress(
//       String walletAddress, String tokenMintAddress) async {
//     final programAddress = await findProgramAddress([
//       decode(walletAddress),
//       decode(tokenProgramId),
//       decode(tokenMintAddress)
//     ], decode(associatedProgramId));
//     return programAddress.address;
//   }

//   static Future<Message> createAndTransferToAccountMessage(
//       SolanaClient client,
//       String fundingAddress,
//       String walletAddress,
//       String sourcePublicKey,
//       String destinationPublicKey,
//       int amount,
//       String mint,
//       {String? memo}) async {
//     final associatedTokenAddress =
//         await TokenUtil.findAssociatedTokenAddress(destinationPublicKey, mint);
//     final recentBlockhash = await client.getRecentBlockhash();
//     final createAccountInstruction = Instruction(
//       programIdIndex: 7,
//       accountIndices: CompactArray.fromList([0, 2, 3, 4, 5, 6, 9]),
//       data: CompactArray.fromList(
//         [],
//       ),
//     );
//     final asserOwnerInstruction = Instruction(
//       programIdIndex: 10,
//       accountIndices: CompactArray.fromList([3]),
//       data: CompactArray.fromList(
//         [
//           ...decode(solanaSystemProgramID),
//         ],
//       ),
//     );

//     final transferInstruction = Instruction(
//       programIdIndex: 6,
//       accountIndices: CompactArray.fromList([9, 2, 1]),
//       data: CompactArray.fromList(
//         [
//           ...3.toSolanaBytes(),
//           ...amount.toSolanaBytes(64),
//         ],
//       ),
//     );

//     return Message(
//       header: MessageHeader(2, 1, 5),
//       accounts: CompactArray.fromList([
//         Address.from(fundingAddress), //signed write
//         Address.from(walletAddress), //signed read
//         Address.from(associatedTokenAddress), //write
//         Address.from(destinationPublicKey), // read
//         Address.from(mint), // read
//         Address.from(solanaSystemProgramID), // read
//         Address.from(tokenProgramId), // read
//         Address.from(associatedProgramId), //strictly program
//         Address.from(sourcePublicKey), // write
//         Address.from(sysvarRentPubKey), // read
//         Address.from(OWNER_VALIDATION_PROGRAM_ID), //strictly program
//         if (memo != null) Address.from(memoProgramId),
//       ]),
//       recentBlockhash: recentBlockhash.blockhash,
//       instructions: CompactArray.fromList([
//         asserOwnerInstruction,
//         createAccountInstruction,
//         transferInstruction,
//         if (memo != null)
//           Instruction(
//             programIdIndex: 11,
//             accountIndices: CompactArray.fromList([]),
//             data: CompactArray.fromList(
//               [...utf8.encode(memo)],
//             ),
//           )
//       ]),
//     );
//   }
// }

// @JS()
// library sollet;

// import 'dart:async';
// import 'dart:html' as html;
// import 'dart:js' as js;
// import 'dart:typed_data';
// import 'package:goramp/bloc/wallet/solana/html.dart';
// import 'package:goramp/bloc/wallet/wallet_provider/index.dart';
// import 'package:goramp/bloc/wallet/wallet_provider/utils.dart';
// import 'package:goramp/utils/index.dart';
// import 'package:js/js.dart';
// import 'package:js/js_util.dart' as js_util;
// import 'package:solana/solana.dart' as solana;
// import 'interface.dart';
// // ignore: avoid_web_libraries_in_flutter

// typedef _Handler = void Function(dynamic event);

// @JS('window.sollet')
// class SolletWebWindow {
//   external SolletWebWindow();
//   external Future<void> postMessage(dynamic params);
// }

// @JS('Wallet')
// class Wallet {
//   external Wallet(dynamic provider, String network);
//   external Future<void> postMessage(dynamic params);
//   external PublicKey publicKey;
//   external bool connected;
//   external bool autoApprove;
//   external html.WindowBase? _popup;
//   external Future<void> connect();
//   external Future<void> disconnect();
//   external Future<SignatureResponse> sign(Uint8List data, String display);
//   external Future<Transaction> signTransaction(Transaction transaction);
//   external Future<List<Transaction>> signAllTransactions(
//       List<Transaction> transaction);
//   external void handleDisconnect();
//   external once(String eventName, _Handler handler);
//   external on(String eventName, _Handler handler);
//   external off(String eventName, _Handler handler);
// }

// @JS('Map')
// class JSMap {
//   external JSMap();
// }

// class SolletWalletProvider extends WalletProvider {
//   SolletWalletProvider({SolletWalletAdapterConfig? config}) {
//     _provider = config?.provider ?? getProvider();
//     _network = config?.network ?? 'mainnet';
//     _connecting = false;
//     _disconnectHandler = js.allowInterop(_handleDisconnect);
//     if (!ready)
//       pollUntilReady(
//           this, config?.pollInterval ?? 1000, config?.pollCount ?? 3);
//   }

//   dynamic _provider;
//   String? _network;
//   Wallet? _wallet;
//   bool _connecting = false;
//   String? _errorDescription;

//   bool get connecting => _connecting;
//   bool get connected => _wallet?.connected ?? false;
//   bool get autoApprove => _wallet?.autoApprove ?? false;
//   String? get errorDescription => _errorDescription;
//   String? get publicKey => _wallet?.publicKey.toString();
//   String get name =>
//       _provider is SolletWebWindow ? 'Sollet Extension' : 'Sollet';
//   String get iconUrl => WALLETS.sollet;
//   bool get ready => _provider is String || hasInstalledProvider();

//   late _Handler _disconnectHandler;

//   static bool hasInstalledProvider() {
//     return js_util.hasProperty(html.window, 'sollet') &&
//         !js_util.hasProperty(html.window, 'sollet.isPhantom');
//   }

//   static SolletWebWindow? getProvider() {
//     try {
//       return hasInstalledProvider() ? SolletWebWindow() : null;
//     } catch (error) {
//       return null;
//     }
//   }

//   void _handleDisconnect(event) async {
//     final wallet = _wallet;
//     if (wallet != null) {
//       wallet.off('disconnect', _disconnectHandler);

//       _wallet = null;
//       emit(
//           'error',
//           WalletProviderException(
//               WalletProviderExceptionCode.DisconnectedError));
//       emit('disconnect');
//     }
//   }

//   @override
//   Future<void> connect() async {
//     Timer? _connectTimer;
//     try {
//       if (connected || connecting) return;
//       _connecting = true;
//       if (_provider == null) {
//         throw WalletProviderException(
//             WalletProviderExceptionCode.NotFoundError);
//       }
//       emit('connecting');
//       Wallet wallet;
//       try {
//         wallet = Wallet(_provider, _network!);
//         final handleDisconnect =
//             js_util.getProperty(wallet, 'handleDisconnect');
//         try {
//           final connectCompleter = new Completer();
//           final onConnect = js.allowInterop((data) {
//             _connectTimer?.cancel();
//             if (connectCompleter.isCompleted) {
//               return;
//             }
//             connectCompleter.complete(data);
//             print('done completing with: $data ');
//           });
//           js_util.setProperty(
//             wallet,
//             'handleDisconnect',
//             js.allowInterop(
//               (_) {
//                 wallet.off('connect', onConnect);
//                 _connectTimer?.cancel();
//                 if (connectCompleter.isCompleted) {
//                   return;
//                 }
//                 connectCompleter.completeError(WalletProviderException(
//                     WalletProviderExceptionCode.WindowClosedError));
//                 js_util.callMethod(handleDisconnect, 'apply', [wallet]);
//               },
//             ),
//           );
//           wallet.on('connect', onConnect);
//           wallet.connect().catchError((error) {
//             wallet.off('connect', onConnect);
//             connectCompleter.completeError(error);
//           });
//           if (_provider is String) {
//             var count = 0;
//             _connectTimer =
//                 Timer.periodic(Duration(milliseconds: 100), (timer) {
//               if (wallet._popup != null) {
//                 if (wallet._popup!.closed!)
//                   connectCompleter.completeError(WalletProviderException(
//                       WalletProviderExceptionCode.WindowClosedError));
//               } else {
//                 if (count > 50)
//                   connectCompleter.completeError(WalletProviderException(
//                       WalletProviderExceptionCode.WindowBlockedError));
//               }
//               count++;
//             });
//           } else {
//             _connectTimer = Timer(
//               Duration(seconds: 10),
//               () {
//                 connectCompleter.completeError(WalletProviderException(
//                     WalletProviderExceptionCode.TimeoutError));
//               },
//             );
//           }
//           await connectCompleter.future;
//         } finally {
//           _connectTimer?.cancel();
//           js_util.setProperty(wallet, 'handleDisconnect', handleDisconnect);
//         }
//       } catch (error, stack) {
//         print('stack: $stack');
//         print('error: $error');
//         final connectionError = WalletProviderException(
//             WalletProviderExceptionCode.ConnectionError,
//             message: error.toString());
//         emit('error', connectionError);
//         throw connectionError;
//       }
//       this._wallet = wallet;
//       wallet.on('disconnect', _disconnectHandler);
//       emit('connect');
//     } catch (error, stack) {
//       print('stack: $stack');
//       print('error: $error');
//       emit('error', error);
//       throw error;
//     } finally {
//       _connecting = false;
//     }
//   }

//   @override
//   Future<void> disconnect() async {
//     if (_wallet == null) {
//       return;
//     }
//     final wallet = _wallet!;
//     final disconnectCompleter = Completer();

//     final disconnectTimer = Timer(Duration(milliseconds: 250), () {
//       if (disconnectCompleter.isCompleted)
//         return disconnectCompleter.complete();
//     });
//     _wallet!.off('disconnect', _disconnectHandler);
//     _wallet = null;
//     final handleDisconnect = js_util.getProperty(wallet, 'handleDisconnect');
//     try {
//       js_util.setProperty(
//         wallet,
//         'handleDisconnect',
//         js.allowInterop(
//           (_) {
//             disconnectTimer.cancel();
//             disconnectCompleter.complete();
//             js_util.setProperty(wallet, '_responsePromises', [JSMap()]);
//             js_util.callMethod(handleDisconnect, 'apply', [wallet]);
//           },
//         ),
//       );
//       wallet.disconnect().then((value) {
//         disconnectTimer.cancel();
//         disconnectCompleter.complete();
//       }).catchError((error) {
//         disconnectTimer.cancel();
//         if (error.toString() == 'Wallet disconnected') {
//           disconnectCompleter.complete();
//         } else {
//           disconnectCompleter.completeError(error);
//         }
//       });
//       await disconnectCompleter.future;
//     } catch (error) {
//       final disConnectionError = WalletProviderException(
//           WalletProviderExceptionCode.DisconnectedError,
//           message: error.toString());
//       throw disConnectionError;
//     } finally {
//       js_util.setProperty(wallet, 'handleDisconnect', handleDisconnect);
//       disconnectTimer.cancel();
//     }
//   }

//   @override
//   Future<solana.Signature> sign(Uint8List message) async {
//     try {
//       final wallet = _wallet;
//       if (wallet == null)
//         throw WalletProviderException(
//             WalletProviderExceptionCode.NotConnectedError);

//       try {
//         final signatureResponse = await wallet.sign(message, 'utf8');
//         return solana.Signature.fromBytes(
//             signatureResponse.signature.toJSON().data);
//       } catch (error) {
//         throw WalletProviderException(
//             WalletProviderExceptionCode.SignMessageError,
//             message: error.toString());
//       }
//     } catch (error) {
//       this.emit('error', error);
//       throw error;
//     }
//   }

//   @override
//   Future<solana.Signature> signTransaction(Uint8List message) async {
//     try {
//       final wallet = _wallet;
//       if (wallet == null)
//         throw WalletProviderException(
//             WalletProviderExceptionCode.NotConnectedError);
//       try {
//         var transaction = fromTransaction(message);
//         transaction = await wallet.signTransaction(transaction);
//         final signatureKeyPair = transaction.signatures
//             .firstWhere((sig) => sig.publicKey.equals(wallet.publicKey));
//         //signatureKeyPair.signature != null?
//         return solana.Signature.fromBytes(
//             signatureKeyPair.signature!.toJSON().data);
//       } catch (error) {
//         throw WalletProviderException(
//             WalletProviderExceptionCode.SignMessageError,
//             message: error.toString());
//       }
//     } catch (error) {
//       this.emit('error', error);
//       throw error;
//     }
//   }

//   @override
//   Future<List<solana.Signature>> signAllTransactions(
//       List<Uint8List> messages) async {
//     try {
//       final wallet = _wallet;
//       if (wallet == null)
//         throw WalletProviderException(
//             WalletProviderExceptionCode.NotConnectedError);
//       try {
//         var transactions = await Future.wait(
//           messages.map(
//             (message) async => await wallet.signTransaction(
//               fromTransaction(message),
//             ),
//           ),
//         );
//         return transactions
//             .map((transaction) =>
//                 solana.Signature.fromBytes(transaction.signatures
//                     .firstWhere(
//                       (sig) => sig.publicKey.equals(wallet.publicKey),
//                     )
//                     .signature!
//                     .toJSON()
//                     .data))
//             .toList();
//       } catch (error) {
//         throw WalletProviderException(
//             WalletProviderExceptionCode.SignMessageError,
//             message: error.toString());
//       }
//     } catch (error) {
//       this.emit('error', error);
//       throw error;
//     }
//   }
// }

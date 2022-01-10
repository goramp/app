// import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:goramp/bloc/index.dart';
// import 'package:universal_platform/universal_platform.dart';
// import 'package:vibration/vibration.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_incall_manager/incall.dart' as incall;
// import '../app_config.dart';
// import '../calls/call_screen.dart';
// import '../calls/clients/rtc_client.dart';
// import '../calls/index.dart';
// import '../calls/models/index.dart';
// import '../models/index.dart';
// import '../models/user.dart';
// import '../route_constants.dart';
// import '../services/index.dart';
// import '../services/navigation_service.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:flutter_call_kit/flutter_call_kit.dart';
// import '../utils/index.dart';

// const kCallKitDidReceiveStartCallAction = "didReceiveStartCallAction";
// const kCallKitPerformAnswerCallAction = "performAnswerCallAction";
// const kCallKitPerformEndCallAction = "performEndCallAction";
// const kCallKitDidActivateAudioSession = "didActivateAudioSession";
// const kCallKitDidDisplayIncomingCall = "didDisplayIncomingCall";
// const kCallKitDidPerformSetMutedCallAction = "didPerformSetMutedCallAction";
// const kCallKitDidPerformDTMFAction = "didPerformDTMFAction";
// const kCallKitDidToggleHoldAction = "didToggleHoldAction";
// const kIconMissedVideoCall = "ic_missed_video_call";
// const kIconMissedCall = "ic_call_missed";
// const kVideoCall = "ic_videocam";

// const _kCallingDuration = Duration(seconds: 60);

// class CallKitValue extends Equatable {
//   final String eventName;
//   final String uuid;
//   final String digit;
//   final String handle;
//   final bool mute;
//   final bool hold;
//   final String error;
//   final String localizedCallerName;
//   final bool fromPushKit;

//   CallKitValue({
//     this.eventName,
//     this.uuid,
//     this.digit,
//     this.hold = false,
//     this.mute = false,
//     this.error,
//     this.handle,
//     this.localizedCallerName,
//     this.fromPushKit,
//   }) : assert(eventName != null);

//   @override
//   List<Object> get props => [
//         eventName,
//         uuid,
//         digit,
//         handle,
//         mute,
//         hold,
//         error,
//         localizedCallerName,
//         fromPushKit
//       ];

//   @override
//   String toString() {
//     return '$runtimeType('
//         'eventName: $eventName, '
//         'uuid: $uuid, '
//         'digit: $digit, '
//         'handle: $handle, '
//         'hold: $hold, '
//         'error: $error, '
//         'localizedCallerName: $localizedCallerName, '
//         'fromPushKit: $fromPushKit, '
//         'mute: $mute, ';
//   }
// }

// class CallKitBloc with RTCCallEvents {
//   FlutterCallKit _callKit = FlutterCallKit();
//   incall.IncallManager _incall = incall.IncallManager();
//   final PublishSubject<CallKitValue> _eventSubject =
//       PublishSubject<CallKitValue>();
//   final RTCCallClient callClient;
//   final ErrorReporter reporter;
//   final NavigationService navigationService;
//   final AppConfig config;
//   final String callKitImage;
//   User _currentUser;
//   Call _call;
//   StreamSubscription<AuthenticationState> _authSubscription;
//   Completer<Call> _callCompleter;
//   Timer _callTimer;
//   RecordingService recordSercice;
//   NSFWBloc nsfwBloc;

//   CallKitBloc(this.config, this.callClient, this.navigationService,
//       this.recordSercice, Stream<AuthenticationState> auth,
//       {this.callKitImage, this.reporter, this.nsfwBloc}) {
//     _authSubscription = auth.listen(_onUser);
//     callClient.addListener(this);
//     onCall(callClient, callClient.call);
//     _initialize();
//   }

//   void _onUser(AuthenticationState state) {
//     if (state is AuthAuthenticated) {
//       _currentUser = state.user;
//     } else {
//       _currentUser = null;
//     }
//   }

//   void onCall(final RTCCallClient client, final Call call) {
//     if (call == null) {
//       return;
//     }
//     CallStatus oldStatus = _call?.status;
//     CallStatus currentStatus = call?.status;
//     _call = call;
//     if (oldStatus == currentStatus) {
//       return;
//     }
//     if (_currentUser == null) {
//       return;
//     }
//     if (_currentUser.id == call.initiator) {
//       _doInitiatorState(client);
//     } else {
//       _doResonderState(client);
//     }
//     if (currentStatus == CallStatus.ended) {
//       print("CALL ENDED: $currentStatus, REASON: ${call.reason}");
//       _endCall();
//     }
//   }

//   void _doInitiatorState(final RTCCallClient client) async {
//     CallStatus currentStatus = _call.status;
//     if (currentStatus == CallStatus.ringing) {
//       _incall.start(
//           media: _call.type == CallType.video
//               ? incall.MediaType.VIDEO
//               : incall.MediaType.AUDIO);
//     }
//     if (currentStatus == CallStatus.calling) {
//       bool isVideo = _call.type == CallType.video;
//       await _callKit.startCall(
//           _call.callId, _currentUser?.name ?? "", _call.recipient,
//           video: isVideo, handleType: HandleType.generic);
//       await _callKit.reportConnectingOutgoingCallWithUUID(_call.callId);
//       _configureCallTimer(
//         _kCallingDuration,
//         CallStatus.calling,
//         () {
//           client.end(reason: CallEndedReason.unanswered);
//         },
//       );
//     }
//     if (currentStatus == CallStatus.answered) {
//       _callKit.reportConnectedOutgoingCallWithUUID(_call.callId);
//       _incall.stopRingback();
//       Vibration.cancel();
//       _cancelCallTimer();
//       Vibration.cancel();
//     }
//   }

//   void _doResonderState(
//     final RTCCallClient client,
//   ) async {
//     CallStatus currentStatus = _call.status;
//     if (currentStatus == CallStatus.ringing) {
//       if (await Vibration.hasVibrator()) {
//         Vibration.vibrate(
//           duration: _kCallingDuration.inSeconds,
//           pattern: [0, 1000, 500, 1000, 500],
//           repeat: 1,
//         );
//       }
//       _incall.startRingtone("DEFAULT", "DEFAULT", _kCallingDuration.inSeconds);
//       _configureCallTimer(_kCallingDuration, CallStatus.ringing, () {
//         _incall.stopRingtone();
//         client.end(reason: CallEndedReason.unanswered);
//       });
//     }
//     if (currentStatus == CallStatus.answered) {
//       Vibration.cancel();
//       _incall.stopRingtone();
//       _incall.start(
//         media: _call.type == CallType.video
//             ? incall.MediaType.VIDEO
//             : incall.MediaType.AUDIO,
//       );
//       _cancelCallTimer();
//     }
//   }

//   void onCallConnectionState(
//       final RTCCallClient client, final RTCConnectionState connectionState) {
//     //callConnectionState.value = connectionState;
//   }

//   void _cancelCallTimer() {
//     if (_callTimer != null && _callTimer.isActive) {
//       _callTimer.cancel();
//     }
//   }

//   void _configureCallTimer(
//       Duration duration, CallStatus status, VoidCallback action) {
//     _cancelCallTimer();
//     _callTimer = Timer(duration, () {
//       if (_call != null && _call.status == status) {
//         action();
//       }
//       _cancelCallTimer();
//     });
//   }

//   Future<Null> _initialize() async {
//     if (UniversalPlatform.isIOS) {
//       _callKit.configure(
//         IOSOptions(config.appName,
//             imageName: "AppIcon",
//             supportsVideo: true,
//             maximumCallGroups: 1,
//             maximumCallsPerCallGroup: 1),
//         didReceiveStartCallAction: _didReceiveStartCallAction,
//         performAnswerCallAction: _answerIncomingCallIOS,
//         performEndCallAction: _performEndCallAction,
//         didActivateAudioSession: _didActivateAudioSession,
//         didDisplayIncomingCall: _didDisplayIncomingCall,
//         didPerformSetMutedCallAction: _didPerformSetMutedCallAction,
//         didPerformDTMFAction: _didPerformDTMFAction,
//         didToggleHoldAction: _didToggleHoldAction,
//       );
//     }
//   }

//   Future<void> _answerIncomingCallIOS(String uuid) async {
//     Call call = await _performAnswerCallAction(uuid);
//     if (call != null) {
//       final bool isOwner = call.recipient == call.roomhostId;
//       final parameters = RoomConnectionParameters(
//         call.roomId,
//         call.recipient,
//         call.initiator,
//         isOwner,
//         localParticipant: Participant(
//           id: _currentUser.id,
//           name: _currentUser.name,
//         ),
//       );
//       final schedule = await CallService.getCallFromId(call.roomId);
//       final autoRecord =
//           await RecordingService.fetchAutoRecordingPreference(defaultVal: true);
//       navigationService.navigateTo(
//         CallRoute,
//         arguments: CallScreenArguments(
//           parameters,
//           callClient,
//           appGroupId: config.iosAppGroupId,
//           callRecordService: recordSercice,
//           topic: schedule.eventTitle,
//           nswfParams: config.nswfParams.copyFrom(
//               modelPath: nsfwBloc.modelFilePath,
//               labelText: nsfwBloc.modelClassesFilePath),
//           autoRecordCall: autoRecord,
//         ),
//       );
//     }
//   }

//   Future<void> didDisplayIncomingCall(CallNotificationData incomingCall) async {
//     return _didDisplayIncomingCall(null, incomingCall.callId,
//         incomingCall.senderUsername, incomingCall.senderUsername, false);
//   }

//   Future<Call> didAnswerIncomingCall(CallNotificationData incomingCall) async {
//     _callCompleter = Completer();
//     try {
//       Call call = await callClient.connectIncomingCall(incomingCall.callId);
//       _call = call;
//       _callCompleter.complete(call);
//       callClient.removeListener(this);
//       callClient.addListener(this);
//       callClient.answer();
//       return _call;
//     } on CallError catch (e) {
//       if (!_callCompleter.isCompleted) {
//         _callCompleter.completeError(e);
//       }
//       callClient.removeListener(this);
//     } catch (error) {
//       print("ERROR: $error");
//     }
//     return null;
//   }

//   Future<void> didEndIncomingCall(CallNotificationData incomingCall,
//       {bool forceEnd = false}) async {
//     return _performEndCallAction(incomingCall.callId, forceEnd: forceEnd);
//   }

//   /// Call CallLink Listener Callbacks
//   Future<void> _didReceiveStartCallAction(String uuid, String handle) async {
//     // Get this event after the system decides you can start a call
//     // You can now start a call from within your app
//   }

//   Future<Call> _performAnswerCallAction(String uuid) async {
//     // Called when the user answers an incoming call
//     try {
//       if (_callCompleter != null) await _callCompleter.future;
//       await callClient.answer();
//       return _call;
//     } on CallError catch (error) {
//       _callKit.endCall(uuid);
//       return null;
//     }
//   }

//   Future<void> _performEndCallAction(String uuid,
//       {bool forceEnd = false}) async {
//     try {
//       if (forceEnd) {
//         await callClient.endWithCallId(uuid,
//             reason: CallEndedReason.remoteEnded);
//         return;
//       }
//       if (_callCompleter != null) await _callCompleter.future;
//       await callClient.end(reason: CallEndedReason.remoteEnded);
//     } on CallError catch (error) {
//       print("END ACTION ERROR: ${error.errorType}");
//     } finally {
//       _cleanUpResources();
//     }
//   }

//   Future<void> _didActivateAudioSession() async {
//     // you might want to do following things when receiving this event:
//     // - Start playing ringback if it is an outgoing call
//   }

//   Future<void> _didDisplayIncomingCall(String error, String uuid, String handle,
//       String localizedCallerName, bool fromPushKit) async {
//     _callCompleter = Completer();
//     try {
//       if (error != null) {
//         await callClient.endWithCallId(uuid, reason: CallEndedReason.failed);
//         return;
//       }
//       Call call = await callClient.connectIncomingCall(uuid);
//       print('call: $call');
//       _call = call;
//       _callCompleter.complete(call);
//       callClient.removeListener(this);
//       callClient.addListener(this);
//       await callClient.ringCall();
//     } on CallError catch (e, stack) {
//       print("ERROR: $e");
//       print(stack);
//       if (!_callCompleter.isCompleted) {
//         _callCompleter.completeError(e);
//       }
//       callClient.removeListener(this);
//       if (error == null) {
//         _callKit.endCall(uuid);
//       }
//     } catch (error) {
//       print("ERROR: $error");
//     }
//   }

//   Future<void> _didPerformSetMutedCallAction(bool mute, String uuid) async {}

//   Future<void> _didPerformDTMFAction(String digit, String uuid) async {}

//   Future<void> _didToggleHoldAction(bool hold, String uuid) async {}

//   FlutterCallKit get callKit => _callKit;

//   void clearNotification() {}

//   Stream<CallKitValue> get notificationStream => _eventSubject.stream;

//   void dispose() {
//     _eventSubject?.close();
//     _authSubscription?.cancel();
//     callClient.removeListener(this);
//     _cancelCallTimer();
//   }

//   _getEndReason(CallEndedReason endedReason) {
//     EndReason reason;
//     switch (endedReason) {
//       case CallEndedReason.failed:
//         reason = EndReason.failed;
//         break;
//       case CallEndedReason.remoteEnded:
//         reason = EndReason.remoteEnded;
//         break;
//       case CallEndedReason.unanswered:
//         reason = EndReason.unanswered;
//         break;
//       default:
//     }
//     return reason;
//   }

//   Future<void> _endCall() async {
//     if (_call == null) {
//       print("COULD NOT END CALL, NO CALL");
//       return;
//     }
//     EndReason reason = _getEndReason(_call.reason);
//     if (reason != null) {
//       await _callKit.reportEndCallWithUUID(_call.callId, reason);
//     } else {
//       await _callKit.endCall(_call.callId);
//     }
//     _cleanUpResources();
//     if (_currentUser != null &&
//         _currentUser.id != _call.initiator &&
//         _call.reason == CallEndedReason.unanswered) {
//       await _sendMissedCallNotification(_call);
//     }
//     _eventSubject.add(
//       CallKitValue(
//         eventName: kCallKitPerformEndCallAction,
//       ),
//     );
//     _call = null;
//   }

//   void _cleanUpResources() {
//     _cancelCallTimer();
//     _incall.stopRingback();
//     _incall.stopRingtone();
//     _incall.stop();
//     Vibration.cancel();
//   }

//   Future<void> _sendMissedCallNotification(Call call) async {
//     print("ABOUT TO SEND MISSED CALL NOTIF");
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         new FlutterLocalNotificationsPlugin();
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings(kIconMissedVideoCall);
//     var initializationSettings =
//         InitializationSettings(initializationSettingsAndroid, null);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String selection) {
//       return null;
//     });
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             Constants.MISSED_CALL_NOTIFICATION_CHANNEL,
//             ANDROID_NOTIFICATION_CHANNELS[
//                     Constants.MISSED_CALL_NOTIFICATION_CHANNEL]
//                 .channelName,
//             ANDROID_NOTIFICATION_CHANNELS[
//                     Constants.MISSED_CALL_NOTIFICATION_CHANNEL]
//                 .channelDescription,
//             importance: Importance.Max,
//             priority: Priority.High,
//             playSound: true,
//             icon: kIconMissedVideoCall);
//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(androidPlatformChannelSpecifics, null);
//     Schedule schedule = await CallService.getCallFromId(call.roomId);
//     String title = "";
//     if (schedule != null) {
//       title = schedule.eventTitle;
//     }
//     String message =
//         call.type == CallType.video ? "Missed Video Call" : "Missed Audio Call";
//     await flutterLocalNotificationsPlugin.show(
//         0, title, message, platformChannelSpecifics,
//         payload: 'schedules/${_call.roomId}');
//     print("DONE SENDING MISSED CALL NOTIF");
//   }
// }

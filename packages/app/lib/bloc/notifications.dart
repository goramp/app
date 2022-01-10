import 'dart:async';
import 'package:equatable/equatable.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter_voip_push_notification/flutter_voip_push_notification.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/main.dart';
//import 'package:incoming_call_notification/incoming_call_notification.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_platform/universal_platform.dart';
import '../services/index.dart';
import '../models/index.dart';
import '../utils/index.dart';

// Future<dynamic> backgroundMessageHandler(RemoteMessage message) async {
//   final dynamic data = message.data;
//   final notif = NotificationData.fromMap(asStringKeyedMap(data)!);

//   if (notif is CallNotificationData) {
//     // final _inCall = IncomingCallNotification();
//     // await _inCall.notifyIncomingCall(
//     //   IncomingCallNotificationData(
//     //       callId: notif.callId,
//     //       eventTitle: notif.title,
//     //       sessionId: notif.sessionId,
//     //       roomId: notif.roomId,
//     //       senderUsername: notif.senderUsername,
//     //       senderImageUrl: notif.senderImageUrl,
//     //       senderId: notif.senderId,
//     //       eventDuration: notif.eventDuration,
//     //       hostId: notif.hostId,
//     //       scheduledAt: notif.scheduledAt,
//     //       videoUrl: notif.videoUrl,
//     //       videoImageUrl: notif.videoImageUrl,
//     //       videoImageWidth: notif.videoImageWidth,
//     //       videoImageHeight: notif.videoImageHeight),
//     // );
//   }
//   return null;
// }

class NotificationValue extends Equatable {
  final bool isResumed;
  final NotificationData? data;
  final bool isLaunched;
  final bool isMessage;
  NotificationValue({
    this.isLaunched = false,
    this.data,
    this.isMessage = false,
    this.isResumed = false,
  });

  @override
  List<Object?> get props => [isResumed, data, isLaunched, isMessage];

  @override
  String toString() {
    return '$runtimeType('
        'isResumed: $isResumed, '
        'data: $data, '
        'isLaunched: $isLaunched, '
        'isMessage: $isMessage, ';
  }
}

class NotificationsBloc {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //final FlutterVoipPushNotification _voipPush = FlutterVoipPushNotification();
  StreamSubscription<NotificationValue?>? _notificationSub;
  StreamSubscription<String>? _voipTokenSub;
  User? _currentUser;
  StreamSubscription<AuthenticationState>? _authSubscription;
  NotificationValue? _currentNotificationValue;
  final BehaviorSubject<NotificationValue?> _notificationData =
      BehaviorSubject<NotificationValue?>();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotificationsBloc(
    AuthenticationBloc authBloc,
  ) {
    _authSubscription = authBloc.stream.listen(this._onUser);
    _onUser(authBloc.state);
    _notificationSub = _notificationData.listen(_handleNotifications);
    _initialize();
  }

  void _onUser(AuthenticationState authenticationState) {
    if (authenticationState is AuthAuthenticated) {
      if (_currentUser == authenticationState.user) return;
      _currentUser = authenticationState.user;
      _doHandleNotification();
      _registerTokens();
    } else {
      _currentUser = null;
    }
  }

  Future<Null> _initialize() async {
    //await _initializeVoipPush();
    try {
      // final settings = await _firebaseMessaging.requestPermission(
      //   alert: true,
      //   announcement: false,
      //   badge: true,
      //   carPlay: false,
      //   criticalAlert: false,
      //   provisional: false,
      //   sound: true,
      // );
      // if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      //   return;
      // }
      // await _registerTokens();
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   _handleNotifications(
      //     NotificationValue(
      //         data: NotificationData.fromMap(message.data), isMessage: true),
      //   );
      // });
      // FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    } catch (error) {
      // print('error')
    }
  }

  Future<Null> _initializeVoipPush() async {
    if (!UniversalPlatform.isIOS) {
      return;
    }
    // do configure voip push
    // _voipPush.configure(
    //   onMessage: (bool isLocal, Map<String, dynamic> payload) async {
    //     print(
    //         "received voip push onMessage: isLocal:$isLocal, payload: $payload");
    //     _handleNotifications(NotificationValue(
    //         data: NotificationData.fromMap(asStringKeyedMap(payload)),
    //         isMessage: true));
    //   },
    //   onResume: (bool isLocal, Map<String, dynamic> payload) async {
    //     print(
    //         "received voip push onResume: isLocal:$isLocal, payload: $payload");
    //     _notificationData.add(NotificationValue(
    //         data: NotificationData.fromMap(asStringKeyedMap(payload)),
    //         isResumed: true));
    //   },
    // );
  }

  Future<void> _registerTokens() async {
    if (_currentUser == null) return;
    // String? messagingToken =
    //     await _firebaseMessaging.getToken(vapidKey: config.vapidKey);
    // if (messagingToken != null) {
    //   UserService.registerMessagingToken(messagingToken);
    // }
    if (UniversalPlatform.isIOS) {
      // String voipToken = await _voipPush.getToken();
      // if (voipToken != null && voipToken.isNotEmpty) {
      //   await UserService.registerVOIPToken(voipToken);
      // }
    }
  }

  ValueStream<NotificationValue?> get notificationStream =>
      _notificationData.stream;

  void clearNotification() {
    _notificationData.add(null);
  }

  void dispose() {
    _voipTokenSub?.cancel();
    _notificationData.close();
    _authSubscription?.cancel();
    _notificationSub?.cancel();
  }

  void _handleNotifications(NotificationValue? notificationValue) {
    if (notificationValue == _currentNotificationValue) {
      return;
    }
    _currentNotificationValue = notificationValue;
    _doHandleNotification();
  }

  void _doHandleNotification() {
    if (_currentNotificationValue == null) {
      return;
    }
    if (_currentUser == null) {
      return;
    }
    final data = _currentNotificationValue!.data;
    if (data is CallNotificationData) {
      _handleCallNotification();
    }
    if (data is CallNotificationData) {
      _handleIncomingCallNotification();
    }
  }

  Future<void> _handleCallNotification() async {
    final data = _currentNotificationValue!.data as CallNotificationData?;
    if (_currentNotificationValue!.isMessage) {
      _notificationData.add(_currentNotificationValue);
      return;
    }
    if (data!.type != NotificationType.callCanceled) {
      // await navigationService.navigateTo(
      //   ScheduleRoute,
      //   arguments: FeedPreviewArgs<Call>(
      //     data.scheduleId,
      //   ),
      // );
      return;
    }
  }

  Future<void> _handleIncomingCallNotification() async {
    // final data = _currentNotificationValue!.data as CallNotificationData?;
    // await navigationService.navigateTo(
    //   IncomingCallRoute,
    //   // arguments: IncomingCallArgs(data),
    // );
  }
}

import 'package:equatable/equatable.dart';
import '../utils/index.dart';

enum NotificationType {
  callReminder,
  callCanceled,
  callConfirmed,
  callExpired,
  inCallMessage,
  incomingVideoCall,
  incomingAudioCall,
  unknown
}

abstract class NotificationData extends Equatable {
  final NotificationType type;

  const NotificationData(this.type);

  String? get iconUrl;

  static String stringFromNotificationType(NotificationType type) {
    switch (type) {
      case NotificationType.callConfirmed:
        return 'call/confirmed';
      case NotificationType.callCanceled:
        return 'call/cancel';
      case NotificationType.callReminder:
        return 'call/reminder';
      case NotificationType.inCallMessage:
        return 'incall/message';
      case NotificationType.incomingVideoCall:
        return 'incall/video';
      case NotificationType.incomingAudioCall:
        return 'incall/audio';
      case NotificationType.callExpired:
        return 'call/expired';
      default:
        return 'unknown';
    }
  }

  static NotificationType stringToNotificationType(String type) {
    switch (type) {
      case 'call/reminder':
        return NotificationType.callReminder;
      case 'call/cancel':
        return NotificationType.callCanceled;
      case 'call/confirmed':
        return NotificationType.callConfirmed;
      case 'incall/message':
        return NotificationType.inCallMessage;
      case 'incall/video':
        return NotificationType.incomingVideoCall;
      case 'incall/audio':
        return NotificationType.incomingAudioCall;
      case 'call/expired':
        return NotificationType.callExpired;
      default:
        return NotificationType.unknown;
    }
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    final NotificationType type = stringToNotificationType(map['type']);
    switch (type) {
      case NotificationType.callReminder:
      case NotificationType.callCanceled:
      case NotificationType.callConfirmed:
      case NotificationType.callExpired:
        return CallNotificationData.fromMap(map);
      case NotificationType.incomingVideoCall:
      case NotificationType.incomingAudioCall:
        return IncomingCallNotificationData.fromMap(map);
      default:
        throw StateError('unimplemented notification type');
    }
  }
}

class Notification extends Equatable {
  final String? title;
  final String? message;
  final NotificationData? data;

  const Notification({this.title, this.message, this.data});

  List<Object?> get props => [title, message];
}

class CallNotificationData extends NotificationData {
  final String? thumbnailUrl;
  final DateTime? scheduledAt;
  final String? hostId;
  final String? eventId;
  final String? guestId;
  final int? duration;
  final String? guestName;
  final String? hostName;
  final String? guestUsername;
  final String? hostUsername;
  final String? callId;
  final String? title;

  const CallNotificationData({
    this.callId,
    this.eventId,
    this.thumbnailUrl,
    this.duration,
    this.hostId,
    this.guestUsername,
    this.hostUsername,
    this.guestId,
    this.scheduledAt,
    this.title,
    this.guestName,
    this.hostName,
    required NotificationType type,
  }) : super(type);

  String? get iconUrl => thumbnailUrl;

  List<Object?> get props => [title, eventId, hostId, type, callId];

  factory CallNotificationData.fromMap(Map<String, dynamic> map) {
    return CallNotificationData(
        title: map['title'],
        callId: map['callId'],
        eventId: map['eventId'],
        thumbnailUrl: map['thumbnailUrl'],
        duration: int.tryParse(map['duration']),
        hostId: map['hostId'],
        guestUsername: map['guestUsername'],
        hostUsername: map['hostUsername'],
        guestId: map['guestId'],
        hostName: map['hostName'],
        guestName: map['guestName'],
        scheduledAt: parseDate(int.tryParse(map['scheduledAtMs'])),
        type: NotificationData.stringToNotificationType(map['type']));
  }
}

class IncomingCallNotificationData extends NotificationData {
  final String? eventTitle;
  final String? sessionId;
  final String? callId;
  final String? roomId;
  final String? senderUsername;
  final String? senderImageUrl;
  final String? senderId;
  final Duration? duration;
  final String? hostId;
  final DateTime? scheduledAt;
  final String? videoUrl;
  final String? videoImageUrl;
  final int? videoImageWidth;
  final int? videoImageHeight;

  const IncomingCallNotificationData({
    this.eventTitle,
    this.sessionId,
    this.callId,
    this.roomId,
    this.senderUsername,
    this.senderImageUrl,
    this.senderId,
    this.hostId,
    this.duration,
    this.scheduledAt,
    this.videoUrl,
    this.videoImageUrl,
    this.videoImageHeight,
    this.videoImageWidth,
    required NotificationType type,
  }) : super(type);

  String? get iconUrl => null;

  @override
  List<Object?> get props => [
        eventTitle,
        sessionId,
        callId,
        roomId,
        senderUsername,
        senderImageUrl,
        senderId,
        hostId,
        duration,
        scheduledAt,
        videoUrl,
        videoImageUrl,
        videoImageHeight,
        videoImageWidth,
        type,
      ];

  factory IncomingCallNotificationData.fromMap(Map<String, dynamic> map) {
    int duration = int.tryParse(map['duration'])!;
    int? videoImageWidth = int.tryParse(map['videoImageWidth']);
    int? videoImageHeight = int.tryParse(map['videoImageHeight']);
    return IncomingCallNotificationData(
        eventTitle: map['eventTitle'],
        sessionId: map['sessionId'],
        callId: map['callId'],
        roomId: map['roomId'],
        senderUsername: map['senderUsername'],
        senderImageUrl: map['senderImageUrl'],
        scheduledAt:
            map['scheduledAt'] != null ? parseDate(map['scheduledAt']) : null,
        senderId: map['senderId'],
        hostId: map['hostId'],
        duration: Duration(minutes: duration),
        videoUrl: map['videoUrl'],
        videoImageUrl: map['videoImageUrl'],
        videoImageWidth: videoImageWidth,
        videoImageHeight: videoImageHeight,
        type: NotificationData.stringToNotificationType(map['type']));
  }

  Map<String, dynamic> toMap() {
    return {
      'eventTitle': eventTitle,
      'sessionId': sessionId,
      'callId': callId,
      'roomId': roomId,
      'senderUsername': senderUsername,
      'senderImageUrl': senderImageUrl,
      'senderId': senderId,
      'hostId': hostId,
      'scheduledAt': scheduledAt?.millisecondsSinceEpoch,
      'duration': duration!.inMinutes.toString(),
      'videoUrl': videoUrl,
      'videoImageUrl': videoImageUrl,
      'videoImageWidth': videoImageWidth?.toString(),
      'videoImageHeight': videoImageHeight?.toString(),
      'type': NotificationData.stringFromNotificationType(type),
    };
  }

  String toString() {
    return "${toMap()}";
  }
}

import 'package:equatable/equatable.dart';
import 'package:goramp/models/index.dart';
import '../utils/index.dart';

class BookingResponse extends Equatable {
  BookingResponse({this.call, this.order});

  List<Object?> get props => [call, order];
  final Call? call;
  final Order? order;
  factory BookingResponse.fromMap(Map<String, dynamic> map) {
    return BookingResponse(
      call: map['call'] != null
          ? Call.fromMap(asStringKeyedMap(map['call'])!)
          : null,
      order: map['order'] != null
          ? Order.fromMap(asStringKeyedMap(map['order'])!)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'call': call?.toMap(),
      'order': order?.toMap(),
    };
  }
}

class BookingRequest extends Equatable {
  final String? callLinkId;
  final String? timezone;
  final DateTime? scheduledAt;

  BookingRequest({this.callLinkId, this.scheduledAt, this.timezone});

  List<Object?> get props => [
        callLinkId,
        scheduledAt,
        timezone,
      ];

  BookingRequest copyWith({
    String? callLinkId,
    DateTime? scheduledAt,
    String? timezone,
  }) {
    return BookingRequest(
      callLinkId: callLinkId ?? this.callLinkId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      timezone: timezone ?? this.timezone,
    );
  }

  factory BookingRequest.fromMap(Map<String, dynamic> map) {
    return BookingRequest(
      callLinkId: map['callLinkId'],
      timezone: map['timezone'],
      scheduledAt:
          map['scheduledAt'] != null ? parseDate(map['scheduledAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callLinkId': callLinkId,
      'timezone': timezone,
      'scheduledAt': scheduledAt?.toUtc().millisecondsSinceEpoch,
    };
  }

  String toString() {
    return "${toMap()}";
  }
}

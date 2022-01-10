import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import '../utils/index.dart';

enum CallStatus { pending, started, ended, unknown, canceled }
enum BookingStatus { pending, confirmed, expired, canceled }
enum EndedReason { canceled, noEndedReason, expired }
const kSectionKeyUpcoming = "Buy";
const kSectionKeyPast = "Sell";

class Call extends Equatable {
  final String? id;
  final String? callLinkId;
  final String? guestId;
  final int? dayOfWeek;
  final CallStatus? status;
  final DateTime? endAt;
  final DateTime? scheduledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? confirmedAt;
  final bool? confirmed;
  final EndedReason? endedReason;
  final String? title;
  final Duration? duration;
  final Video? video;
  final String? hostId;
  final String? hostUsername;
  final String? hostName;
  final String? hostImageUrl;

  final String? hostTimezone;
  final String? guestTimezone;
  final String? guestUsername;
  final String? guestName;
  final int? confirmationStatusCode;
  final String? guestImageUrl;
  final List<String>? participants;
  final bool? hasRecording;

  Call(
      {this.id,
      this.callLinkId,
      this.scheduledAt,
      this.dayOfWeek,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.endedReason,
      this.guestId,
      this.title,
      this.duration,
      this.video,
      this.hostId,
      this.hostUsername,
      this.hostImageUrl,
      this.participants,
      this.endAt,
      this.hasRecording,
      this.guestUsername,
      this.guestImageUrl,
      this.confirmedAt,
      this.confirmed,
      this.hostTimezone,
      this.guestTimezone,
      this.hostName,
      this.guestName,
      this.confirmationStatusCode});

  List<Object?> get props => [
        id,
        callLinkId,
        scheduledAt,
        dayOfWeek,
        guestId,
        createdAt,
        updatedAt,
        endedReason,
        title,
        duration,
        video,
        hostId,
        hostUsername,
        hostImageUrl,
        participants,
        callLinkId,
        endAt,
        hasRecording,
        guestUsername,
        guestImageUrl,
        confirmedAt,
        confirmed,
        hostTimezone,
        guestTimezone,
        confirmationStatusCode,
      ];
  Call copyWith({
    String? id,
    String? callLinkId,
    String? guestId,
    String? guestName,
    int? dayOfWeek,
    DateTime? scheduledAt,
    DateTime? endAt,
    CallStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    EndedReason? endedReason,
    Duration? expiresIn,
    Duration? duration,
    String? title,
    Video? video,
    String? hostId,
    String? hostUsername,
    String? hostName,
    String? hostImageUrl,
    List<String>? participants,
    bool? hasRecording,
    String? guestUsername,
    String? guestImageUrl,
    BookingStatus? bookingStatus,
    DateTime? confirmedAt,
    DateTime? confirmed,
    String? hostTimezone,
    String? guestTimezone,
    int? confirmationStatusCode,
  }) {
    return Call(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      callLinkId: callLinkId ?? this.callLinkId,
      guestId: guestId ?? this.guestId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      endAt: endAt ?? this.endAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      endedReason: endedReason ?? this.endedReason,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      video: video ?? this.video,
      hostId: hostId ?? this.hostId,
      hostUsername: hostUsername ?? this.hostUsername,
      hostImageUrl: hostImageUrl ?? this.hostImageUrl,
      participants: participants ?? this.participants,
      hasRecording: hasRecording ?? this.hasRecording,
      guestUsername: guestUsername ?? this.guestUsername,
      guestImageUrl: guestImageUrl ?? this.guestImageUrl,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      confirmed: confirmed as bool? ?? this.confirmed,
      hostTimezone: hostTimezone ?? this.hostTimezone,
      guestTimezone: guestTimezone ?? this.guestTimezone,
      hostName: hostName ?? this.hostName,
      guestName: guestName ?? this.guestName,
      confirmationStatusCode:
          confirmationStatusCode ?? this.confirmationStatusCode,
    );
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      id: map['id'] ?? map['_id'],
      dayOfWeek: map['dayOfWeek'],
      callLinkId: map['callLinkId'],
      guestId: map['guestId'],
      confirmationStatusCode: map['confirmationStatusCode'] is String
          ? 0
          : map['confirmationStatusCode'],
      scheduledAt: parseDate(map['scheduledAt']),
      endAt: parseDate(map['endAt']),
      createdAt: parseDate(map['createdAt']),
      endedReason: map['endedReason'] != null
          ? intToScheduleEndedReason(map['endedReason'])
          : null,
      status: map['status'] != null ? stringToCallStatus(map['status']) : null,
      title: map['title'],
      duration:
          map['duration'] != null ? Duration(minutes: map['duration']) : null,
      hostId: map['hostId'],
      hostUsername: map['hostUsername'],
      hostImageUrl: map['hostImageUrl'],
      video: map['video'] != null
          ? Video.fromMap(map['video'].cast<String, dynamic>())
          : null,
      participants: map['participants'] != null
          ? map['participants'].cast<String>()
          : null,
      guestUsername: map['guestUsername'],
      guestImageUrl: map['guestImageUrl'],
      confirmedAt: parseDate(map['confirmedAt']),
      confirmed: map['confirmed'],
      guestTimezone: map['guestTimezone'],
      hostTimezone: map['hostTimezone'],
      guestName: map['guestName'],
      hostName: map['hostName'],
    );
  }

  static String stringFromConfirmationStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.expired:
        return 'expired';
      case BookingStatus.canceled:
        return 'canceled';
      default:
        return 'pending';
    }
  }

  static BookingStatus stringToConfirmationStatus(String status) {
    switch (status) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'expired':
        return BookingStatus.expired;
      case 'canceled':
        return BookingStatus.canceled;
      default:
        return BookingStatus.pending;
    }
  }

  static String stringFromCallStatus(CallStatus? status) {
    switch (status) {
      case CallStatus.pending:
        return 'pending';
      case CallStatus.started:
        return 'started';
      case CallStatus.ended:
        return 'ended';
      case CallStatus.canceled:
        return 'canceled';
      default:
        return 'unknown';
    }
  }

  static CallStatus stringToCallStatus(String? status) {
    switch (status) {
      case 'pending':
        return CallStatus.pending;
      case 'started':
        return CallStatus.started;
      case 'ended':
        return CallStatus.ended;
      case 'canceled':
        return CallStatus.canceled;
      default:
        return CallStatus.unknown;
    }
  }

  static int intFromScheduleEndedReason(EndedReason? reason) {
    switch (reason) {
      case EndedReason.noEndedReason:
        return 0;
      case EndedReason.canceled:
        return 1;
      case EndedReason.expired:
        return 2;
      default:
        return 0;
    }
  }

  static EndedReason intToScheduleEndedReason(int? reason) {
    switch (reason) {
      case 0:
        return EndedReason.noEndedReason;
      case 1:
        return EndedReason.canceled;
      case 2:
        return EndedReason.expired;
      default:
        return EndedReason.noEndedReason;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'dayOfWeek': dayOfWeek,
      'callLinkId': callLinkId,
      'guestId': guestId,
      'scheduledAt': scheduledAt?.millisecondsSinceEpoch,
      'confirmationStatusCode': confirmationStatusCode,
      'endAt': endAt?.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'endedReason':
          endedReason != null ? intFromScheduleEndedReason(endedReason) : null,
      'status': status != null ? stringFromCallStatus(status) : null,
      'duration': duration?.inMinutes,
      'hostId': hostId,
      'hostUsername': hostUsername,
      'hostImageUrl': hostImageUrl,
      'video': video?.toMap(),
      'participants': participants,
      'guestUsername': guestUsername,
      'guestImageUrl': guestImageUrl,
      'guestTimezone': guestTimezone,
      'hostTimezone': hostTimezone,
      'confirmedAt': confirmedAt?.millisecondsSinceEpoch,
      'confirmed': confirmed,
    };
  }

  TimeOfDay get scheduledTime =>
      TimeOfDay(hour: scheduledAt!.hour, minute: scheduledAt!.minute);

  @override
  String toString() => '${toMap()}';
}

class Reservation extends Equatable implements Comparable<Reservation> {
  final String callLinkId;
  final DateTime scheduledAt;
  final DateTime? startAt;
  final DateTime? endAt;

  Reservation({
    required this.callLinkId,
    required this.scheduledAt,
    this.startAt,
    this.endAt,
  });

  List<Object?> get props => [
        callLinkId,
        scheduledAt,
      ];

  Reservation copyWith({
    String? callLinkId,
    DateTime? scheduledAt,
    DateTime? startAt,
    DateTime? endAt,
  }) {
    return Reservation(
      callLinkId: callLinkId ?? this.callLinkId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
    );
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      callLinkId: map['callLinkId'],
      scheduledAt: parseDate(map['scheduledAt'])!,
      startAt: map['startAt'] != null ? parseDate(map['startAt']) : null,
      endAt: map['endAt'] != null ? parseDate(map['endAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callLinkId': callLinkId,
      'scheduledAt': scheduledAt.toUtc().millisecondsSinceEpoch.toString(),
      'startAt': startAt?.toUtc().millisecondsSinceEpoch.toString(),
      'endAt': endAt?.toUtc().millisecondsSinceEpoch.toString(),
    };
  }

  @override
  String toString() =>
      'Reservation { callLinkId: $callLinkId, scheduledAt: $scheduledAt}';

  @override
  int compareTo(Reservation other) {
    return this.scheduledAt.compareTo(other.scheduledAt);
  }
}

class CallInput extends Equatable {
  final String? callLinkId;
  final String? guestId;
  final String? guesTimezone;
  final String? hostId;
  final DateTime? scheduledAt;

  CallInput(
      {this.callLinkId,
      this.scheduledAt,
      this.guestId,
      this.hostId,
      this.guesTimezone});

  List<Object?> get props => [
        callLinkId,
        scheduledAt,
        hostId,
        guestId,
        guesTimezone,
      ];

  CallInput copyWith({
    String? callLinkId,
    String? guestId,
    String? hostId,
    int? dayOfWeek,
    TimeOfDay? scheduledTime,
    String? guesTimezone,
  }) {
    return CallInput(
      callLinkId: callLinkId ?? this.callLinkId,
      hostId: hostId ?? this.hostId,
      guestId: guestId ?? this.guestId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      guesTimezone: guesTimezone ?? this.guesTimezone,
    );
  }

  factory CallInput.fromMap(Map<String, dynamic> map) {
    return CallInput(
      callLinkId: map['callLinkId'],
      hostId: map['hostId'],
      guestId: map['guestId'],
      guesTimezone: map['guesTimezone'],
      scheduledAt:
          map['scheduledAt'] != null ? parseDate(map['scheduledAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callLinkId': callLinkId,
      'guestId': guestId,
      'guesTimezone': guesTimezone,
      'hostId': hostId,
      'scheduledAt': scheduledAt?.toUtc().millisecondsSinceEpoch.toString(),
    };
  }

  String toString() {
    return "${toMap()}";
  }
}

class CancelCallInput extends Equatable {
  final String? callLinkId;
  final String? scheduleId;
  final String? cancelReason;
  final String? hostId;

  CancelCallInput({
    this.callLinkId,
    this.scheduleId,
    this.cancelReason,
    this.hostId,
  });

  List<Object?> get props => [
        callLinkId,
        hostId,
        scheduleId,
        cancelReason,
      ];

  CancelCallInput copyWith({
    String? callLinkId,
    String? hostId,
    String? scheduleId,
    String? cancelReason,
  }) {
    return CancelCallInput(
      callLinkId: callLinkId ?? this.callLinkId,
      hostId: hostId ?? this.hostId,
      scheduleId: scheduleId ?? this.scheduleId,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  factory CancelCallInput.fromMap(Map<String, dynamic> map) {
    return CancelCallInput(
      callLinkId: map['callLinkId'],
      hostId: map['hostId'],
      scheduleId: map['scheduleId'],
      cancelReason: map['cancelReason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callLinkId': callLinkId,
      'cancelReason': cancelReason,
      'scheduleId': scheduleId,
      'hostId': hostId,
    };
  }
}

abstract class GroupedCallItem extends Equatable {}

class GroupedScheduleDividerItem extends GroupedCallItem {
  List<Object> get props => [];
}

class GroupedCallHeaderItem extends GroupedCallItem {
  final bool active;
  final bool borderTop;
  final bool borderBottom;
  GroupedCallHeaderItem(
      {this.dateTime,
      List<Call>? schedules,
      this.active = false,
      this.borderTop = false,
      this.borderBottom = false});
  final DateTime? dateTime;
  List<Object?> get props => [
        dateTime,
        active,
        borderTop,
        borderTop,
      ];
}

class GroupedCallSectionHeaderItem extends GroupedCallItem {
  GroupedCallSectionHeaderItem(
      {this.key, this.description, this.showSeeAll = true});
  final String? key;
  final String? description;
  final bool showSeeAll;
  List<Object?> get props => [key, description, showSeeAll];
}

class GroupedCallListItem extends GroupedCallItem {
  final bool isFirst;
  final bool isLast;
  GroupedCallListItem(this.schedule, {required List<Call> schedules})
      : this.isFirst = schedule.id == schedules[0].id,
        this.isLast = schedule.id == schedules[schedules.length - 1].id;
  final Call schedule;
  List<Object> get props => [schedule, isFirst, isLast];
}

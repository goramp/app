import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';
import '../models/index.dart';
import '../utils/index.dart';

const MINUTES_PER_DAY = 1440;

const TimeOfDay DefaultStartTime = TimeOfDay(hour: 9, minute: 0);
const TimeOfDay DefaultEndTime = TimeOfDay(hour: 17, minute: 0);

const minutesInDay = (TimeOfDay.hoursPerDay * TimeOfDay.minutesPerHour);
const List<Availability> DefaultWeeklyAvailability = [
  Availability(0, [], available: false),
  Availability(1, [], available: true),
  Availability(2, [], available: true),
  Availability(3, [], available: true),
  Availability(4, [], available: true),
  Availability(5, [], available: true),
  Availability(6, [], available: false)
];

const List<AvailabilitySettings> DefaultWeeklyAvailabilitySettings = [
  AvailabilitySettings(0, available: false),
  AvailabilitySettings(1, available: true),
  AvailabilitySettings(2, available: true),
  AvailabilitySettings(3, available: true),
  AvailabilitySettings(4, available: true),
  AvailabilitySettings(5, available: true),
  AvailabilitySettings(6, available: false),
];

class GTimeInterval implements Comparable<GTimeInterval> {
  final String id;
  final String? linkId;
  final TimeOfDay? startOfDay;
  final TimeOfDay? endOfDay;
  final VideoThumb? videoThumb;
  final int day;

  const GTimeInterval(this.id, this.day,
      {this.startOfDay, this.endOfDay, this.linkId, this.videoThumb})
      : assert(day >= 0 && day <= 6);

  GTimeInterval copyWith({
    int? day,
    String? id,
    TimeOfDay? startOfDay,
    TimeOfDay? endOfDay,
    VideoThumb? thumb,
    String? linkId,
  }) {
    return GTimeInterval(
      id ?? this.id,
      day ?? this.day,
      startOfDay: startOfDay ?? this.startOfDay,
      endOfDay: endOfDay ?? this.endOfDay,
      videoThumb: thumb ?? this.videoThumb,
      linkId: linkId ?? this.linkId,
    );
  }

  GTimeInterval get toUTC {
    final now = DateTime.now();
    DateTime startTime = DateTime(
            now.year, now.month, now.day, startOfDay!.hour, startOfDay!.minute)
        .toUtc();
    DateTime endTime =
        DateTime(now.year, now.month, now.day, endOfDay!.hour, endOfDay!.minute)
            .toUtc();
    return this.copyWith(
        startOfDay: TimeOfDay(hour: startTime.hour, minute: startTime.minute),
        endOfDay: TimeOfDay(hour: endTime.hour, minute: endTime.minute));
  }

  GTimeInterval get toLocal {
    final now = DateTime.now().toUtc();
    DateTime startTime = DateTime.utc(
            now.year, now.month, now.day, startOfDay!.hour, startOfDay!.minute)
        .toLocal();
    DateTime endTime = DateTime.utc(
            now.year, now.month, now.day, endOfDay!.hour, endOfDay!.minute)
        .toLocal();
    return this.copyWith(
        startOfDay: TimeOfDay(hour: startTime.hour, minute: startTime.minute),
        endOfDay: TimeOfDay(hour: endTime.hour, minute: endTime.minute));
  }

  GTimeInterval toLocalTimeZone(Location timezone) {
    final now = DateTime.now().toUtc();
    DateTime startTime = DateTime.utc(
        now.year, now.month, now.day, startOfDay!.hour, startOfDay!.minute);
    DateTime endTime = DateTime.utc(
        now.year, now.month, now.day, endOfDay!.hour, endOfDay!.minute);
    TZDateTime startTimeInTz = TZDateTime.from(startTime, timezone);
    TZDateTime endTimeInTz = TZDateTime.from(endTime, timezone);
    return this.copyWith(
        startOfDay:
            TimeOfDay(hour: startTimeInTz.hour, minute: startTimeInTz.minute),
        endOfDay:
            TimeOfDay(hour: endTimeInTz.hour, minute: endTimeInTz.minute));
  }

  GTimeInterval toTimeZone(Location fromTimeZone) {
    final now = TZDateTime.now(fromTimeZone);
    DateTime startTime = TZDateTime(fromTimeZone, now.year, now.month, now.day,
        startOfDay!.hour, startOfDay!.minute);
    DateTime endTime = TZDateTime(fromTimeZone, now.year, now.month, now.day,
        endOfDay!.hour, endOfDay!.minute);
    return this.copyWith(
        startOfDay: TimeOfDay(hour: startTime.hour, minute: startTime.minute),
        endOfDay: TimeOfDay(hour: endTime.hour, minute: endTime.minute));
  }

  int get dayOfWeekOffsetInMinutes {
    return day * TimeOfDay.hoursPerDay * TimeOfDay.minutesPerHour;
  }

  int get startMinutesOfWeek {
    return dayOfWeekOffsetInMinutes + startMinuteOfDay;
  }

  int get startMinuteOfDay {
    return this.startOfDay!.hour * TimeOfDay.minutesPerHour +
        this.startOfDay!.minute;
  }

  int get endMinutesOfWeek {
    return dayOfWeekOffsetInMinutes + endMinuteOfDay;
  }

  int get endMinuteOfDay {
    return this.endOfDay!.hour * TimeOfDay.minutesPerHour +
        this.endOfDay!.minute;
  }

  @override
  bool operator ==(other) =>
      other is GTimeInterval &&
      // other.id == id &&
      other.day == day &&
      other.startOfDay == startOfDay &&
      other.endOfDay == endOfDay;

  @override
  int get hashCode => day.hashCode ^ startOfDay.hashCode ^ endOfDay.hashCode;

  @override
  String toString() {
    return '$runtimeType('
        'id: $id, '
        'day: $day, '
        'startOfDay: $startOfDay, '
        'linkId: $linkId, '
        'endOfDay: $endOfDay, ';
  }

  @override
  int compareTo(GTimeInterval other) {
    if (this.startMinutesOfWeek < other.startMinutesOfWeek) {
      return -1;
    } else if (this.startMinutesOfWeek == other.startMinutesOfWeek) {
      return this.endMinutesOfWeek <= other.endMinutesOfWeek ? -1 : 1;
    } else {
      return 1;
    }
  }

  static Set<int> findOverlappingIndices(List<GTimeInterval> intervals) {
    if (intervals.isEmpty) {
      return Set<int>();
    }
    Set<int> overlappingIndices = Set<int>();
    intervals.sort(GTimeInterval.intervalComparator);
    for (int i = 1; i < intervals.length; ++i) {
      if (intervals[i - 1].endOfDay == null ||
          intervals[i].startOfDay == null) {
        continue;
      }
      if (intervals[i - 1].endMinutesOfWeek > intervals[i].startMinutesOfWeek) {
        overlappingIndices.add(i - 1);
        overlappingIndices.add(i);
      }
    }
    return overlappingIndices;
  }

  static Map<String?, List<GTimeInterval?>> findOverlapping(
      List<GTimeInterval?> timeslots) {
    Map<String?, List<GTimeInterval?>> map = {};
    if (timeslots.isEmpty) {
      return map;
    }
    List<GTimeInterval?> intervals = [];
    intervals.addAll(timeslots);
    intervals.sort(intervalComparator);
    for (int i = 1; i < intervals.length; ++i) {
      if (intervals[i - 1]!.endOfDay == null ||
          intervals[i]!.startOfDay == null) {
        continue;
      }
      if (intervals[i - 1]!.endMinutesOfWeek >
          intervals[i]!.startMinutesOfWeek) {
        map.putIfAbsent(intervals[i]!.id, () => []).add(intervals[i - 1]);
        map.putIfAbsent(intervals[i - 1]!.id, () => []).add(intervals[i]);
      }
    }
    return map;
  }

  static TimeOfDay fromMinuteOfDay(int minuteOfDay) {
    return TimeOfDay(
        hour: minuteOfDay ~/ TimeOfDay.minutesPerHour,
        minute: minuteOfDay % TimeOfDay.minutesPerHour);
  }

  static int dayFromMinuteOfWeek(int minuteOfWeek) {
    return minuteOfWeek ~/ minutesInDay;
  }

  static TimeOfDay fromMinuteOfWeek(int minuteOfWeek) {
    final minuteOfDay = minuteOfWeek % minutesInDay;
    final inTimeOfDay = fromMinuteOfDay(minuteOfDay);
    return inTimeOfDay;
  }

  static int intervalComparator(GTimeInterval? a, GTimeInterval? b) {
    int i = a!.compareTo(b!);
    return i;
  }

  static int minuteOfDay(TimeOfDay time) {
    return time.hour * TimeOfDay.minutesPerHour + time.minute;
  }

  factory GTimeInterval.fromMap(Map<String, dynamic> map) {
    return GTimeInterval(
      map['_id'],
      dayFromMinuteOfWeek(map['start']),
      startOfDay: map['start'] != null ? fromMinuteOfWeek(map['start']) : null,
      endOfDay: map['end'] != null ? fromMinuteOfWeek(map['end']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'start': startMinutesOfWeek,
      'end': endMinutesOfWeek,
    };
  }
}

class AvailabilitySettings {
  final bool? available;
  final int? day;

  const AvailabilitySettings(this.day, {this.available = true});

  AvailabilitySettings copyWith({int? day, bool? available}) {
    return AvailabilitySettings(day ?? this.day,
        available: available ?? this.available);
  }

  @override
  bool operator ==(other) =>
      other is AvailabilitySettings &&
      other.available == available &&
      other.day == day;

  @override
  int get hashCode => available.hashCode ^ day.hashCode;

  @override
  String toString() {
    return '$runtimeType('
        'day: $day,'
        'available: $available, ';
  }

  factory AvailabilitySettings.fromMap(Map<String, dynamic> map) {
    return AvailabilitySettings(map["day"], available: map['available']);
  }

  Map<String, dynamic> toMap() {
    return {"day": day, 'available': available};
  }
}

class Availability {
  final List<GTimeInterval>? timeslots;
  final int? day;
  final bool? available;
  final String? linkId;
  final String? createdBy;

  const Availability(this.day, this.timeslots,
      {this.linkId, this.createdBy, this.available = false});

  Availability copyWith(
      {List<GTimeInterval>? timeslots,
      int? day,
      String? createdBy,
      String? linkId,
      bool? available}) {
    return Availability(day ?? this.day, timeslots ?? this.timeslots,
        linkId: linkId ?? this.linkId,
        createdBy: createdBy ?? this.createdBy,
        available: available ?? this.available);
  }

  bool get hasSlots => timeslots != null && timeslots!.isNotEmpty;

  @override
  bool operator ==(other) =>
      other is Availability &&
      other.day == day &&
      other.available == available &&
      other.linkId == linkId &&
      other.createdBy == createdBy &&
      equals(other.timeslots, timeslots);

  @override
  int get hashCode =>
      hashValues(day, available, linkId, createdBy, hashList(timeslots));

  @override
  String toString() {
    return '$runtimeType('
        'day: $day, '
        'linkId: $linkId, '
        'createdBy: $createdBy, '
        'timeslots: $timeslots, '
        'available: $available, ';
  }

  factory Availability.fromMap(Map<String, dynamic> map) {
    return Availability(
      map['day'],
      map['timeslots'] != null
          ? (map['timeslots'] as List<dynamic>)
              .map((dynamic timeslot) =>
                  GTimeInterval.fromMap(asStringKeyedMap(timeslot as Map)!))
              .toList()
          : null,
      available: map['available'],
      createdBy: map['createdBy'],
      linkId: map['linkId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'timeslots': timeslots
          ?.map((GTimeInterval? timeslot) => timeslot!.toMap())
          .toList(),
      'available': available,
      'linkId': linkId,
      'createdBy': createdBy,
    };
  }
}

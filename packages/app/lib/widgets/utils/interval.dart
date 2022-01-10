import 'package:interval_tree/interval_tree.dart' as iv;
import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:timezone/timezone.dart';

class IntervalHelper {
  static String formatTime(MaterialLocalizations localizations, TimeOfDay time,
      {bool? alwaysUse24HourFormat = false, bool capitalize = false}) {
    String? amPm;

    switch (time.period) {
      case DayPeriod.am:
        amPm = capitalize
            ? ' ${localizations.anteMeridiemAbbreviation.toUpperCase()}'
            : localizations.anteMeridiemAbbreviation
                .toLowerCase()
                .substring(0, 1);
        break;
      case DayPeriod.pm:
        amPm = capitalize
            ? ' ${localizations.postMeridiemAbbreviation.toUpperCase()}'
            : localizations.postMeridiemAbbreviation
                .toLowerCase()
                .substring(0, 1);
        break;
    }
    String timeS =
        '${localizations.formatHour(time, alwaysUse24HourFormat: alwaysUse24HourFormat!)}:${localizations.formatMinute(time)}';
    if (alwaysUse24HourFormat) {
      return '$timeS';
    }
    return '$timeS$amPm';
  }

  static String formatTimeL(MaterialLocalizations localizations, TimeOfDay time,
      {bool alwaysUse24HourFormat = false, bool capitalize = false}) {
    String? amPm;

    switch (time.period) {
      case DayPeriod.am:
        amPm = capitalize
            ? ' ${localizations.anteMeridiemAbbreviation.toUpperCase()}'
            : localizations.anteMeridiemAbbreviation.toLowerCase();
        break;
      case DayPeriod.pm:
        amPm = capitalize
            ? ' ${localizations.postMeridiemAbbreviation.toUpperCase()}'
            : localizations.postMeridiemAbbreviation.toLowerCase();
        break;
    }
    return '${localizations.formatHour(time, alwaysUse24HourFormat: alwaysUse24HourFormat)}:${localizations.formatMinute(time)}$amPm';
  }

  static String formatTimeS(MaterialLocalizations localizations, TimeOfDay time,
      {bool alwaysUse24HourFormat = false, bool capitalize = false}) {
    return '${localizations.formatHour(time, alwaysUse24HourFormat: alwaysUse24HourFormat)}:${localizations.formatMinute(time)}';
  }

  static String? formatAnteMeridian(
      MaterialLocalizations localizations, TimeOfDay time,
      {bool capitalize = false}) {
    String? amPm;

    switch (time.period) {
      case DayPeriod.am:
        amPm = capitalize
            ? ' ${localizations.anteMeridiemAbbreviation.toUpperCase()}'
            : localizations.anteMeridiemAbbreviation.toLowerCase();
        break;
      case DayPeriod.pm:
        amPm = capitalize
            ? ' ${localizations.postMeridiemAbbreviation.toUpperCase()}'
            : localizations.postMeridiemAbbreviation.toLowerCase();
        break;
    }
    return amPm;
  }

  static log(DateTime date, String data) {
    if (date.day != 6) {
      return;
    }
    print(data);
  }

  static void avaialbilities(
    CallLink event,
    Map<int?, Availability> weeklyAvailabilites,
    int dayOfWeek,
    iv.IntervalTree tree,
    TZDateTime beginOfDay,
    Location hostTimeZone,
    Location guestTimeZone,
    GTimeInterval interval,
    Set<Call> availableTimes,
    TZDateTime guestBeginToHost,
  ) {
    if (!event.isInRange(beginOfDay)) {
      return;
    }
    TZDateTime now = TZDateTime.now(hostTimeZone);

    TZDateTime start =
        beginOfDay.add(Duration(minutes: interval.startMinuteOfDay));
    TZDateTime end = beginOfDay.add(Duration(minutes: interval.endMinuteOfDay));
    if (end.isBefore(now)) {
      return;
    }
    while (start.isBefore(end)) {
      if (start.isBefore(guestBeginToHost)) {
        start = start.add(event.duration!);
        continue;
      }
      //myEvents that are ended
      if (start.add(event.duration!).isBefore(now)) {
        start = start.add(event.duration!);
        continue;
      }
      //myEvents that are started
      if (now.isAfter(start) && now.isBefore(start.add(event.duration!))) {
        start = start.add(event.duration!);
        continue;
      }
      //myEvents that are started to early given 1 hour break
      if (now.add(Duration(hours: 1)).isAfter(start)) {
        start = start.add(event.duration!);
        continue;
      }
      if (tree.isNotEmpty &&
          tree.overlap(
            iv.Interval(
              start.millisecondsSinceEpoch,
              start.add(event.duration!).millisecondsSinceEpoch - 1,
            ),
          )) {
        start = start.add(event.duration!);
        continue;
      }
      availableTimes.add(
        Call(
            id: '${TZDateTime.from(start, guestTimeZone).millisecondsSinceEpoch}',
            callLinkId: event.id,
            scheduledAt: TZDateTime.from(start, guestTimeZone),
            duration: event.duration,
            hostId: event.hostId),
      );
      start = start.add(event.duration!);
    }
  }

  static List<Call> getAvailableTimes(
    CallLink event,
    DateTime date,
    Map<int?, Availability> weeklyAvailabilites,
    Location? guestTimeZone, {
    List<Reservation> reservations = const [],
  }) {
    final hostTimeZone = timeZoneDatabase.get(event.timezone!);
    final intervals = reservations
        .where((element) => element.startAt != null && element.endAt != null)
        .map((e) => iv.Interval(
              TZDateTime.from(e.startAt!, hostTimeZone).millisecondsSinceEpoch,
              TZDateTime.from(e.endAt!, hostTimeZone).millisecondsSinceEpoch,
            ));
    final iv.IntervalTree tree = iv.IntervalTree.from(intervals);
    final guestBeginToHost = TZDateTime.from(date, hostTimeZone);
    final guestEnd = date
        .add(Duration(hours: 23))
        .add(Duration(minutes: 59))
        .add(Duration(seconds: 59))
        .add(Duration(milliseconds: 999));
    final hostEndDate = TZDateTime.from(guestEnd, hostTimeZone);

    TZDateTime beginOfDay = TZDateTime(hostTimeZone, guestBeginToHost.year,
        guestBeginToHost.month, guestBeginToHost.day);
    final availableTimes = Set<Call>();
    while (beginOfDay.isBefore(hostEndDate)) {
      int dayOfWeek = beginOfDay.weekday % 7;
      weeklyAvailabilites[dayOfWeek]?.timeslots?.forEach((GTimeInterval it) {
        avaialbilities(event, weeklyAvailabilites, dayOfWeek, tree, beginOfDay,
            hostTimeZone, guestTimeZone!, it, availableTimes, guestBeginToHost);
      });
      beginOfDay = beginOfDay.add(Duration(days: 1));
    }
    return availableTimes.toList();
  }

  static int search<T>(List<T> sortedList, T value,
      {bool Function(T t)? compare}) {
    var min = 0;
    var max = sortedList.length;
    while (min < max) {
      var h = ((max + min) >> 1);
      if (!compare!(sortedList[h])) {
        min = h + 1; // preserves f(i-1) == false
      } else {
        max = h; // preserves f(j) == true
      }
    }
    return min;
  }
}

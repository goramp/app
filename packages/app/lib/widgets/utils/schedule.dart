import 'package:goramp/models/index.dart';
import 'package:goramp/utils/index.dart';

class ScheduleUtils {
  static bool isUnAvailable(
      CallLink event,
      Map<int?, Availability>? weeklyAvailabilities,
      Map<int, List<Call>>? availableTimesByDay) {
    return event.isPast() ||
        (weeklyAvailabilities != null &&
            availableTimesByDay != null &&
            availableTimesByDay.values.every((element) => element.isEmpty));
  }

  static bool isAvailable(
      DateTime date,
      CallLink event,
      Map<int?, Availability>? availabilities,
      Map<int, List<Call>>? availableTimesByDay) {
    int dayOfWeek = date.weekday % 7;
    if (availabilities == null) {
      return false;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date.isBefore(today)) {
      return false;
    }
    Availability? availabilty = availabilities[dayOfWeek];
    if (!event.isInRange(date) ||
        availabilty == null ||
        !availabilty.available!) {
      return false;
    }
    if (availableTimesByDay == null) {
      return false;
    }
    final beginOfDay = DateTime(date.year, date.month, date.day);
    final availableTimes =
        availableTimesByDay[beginOfDay.millisecondsSinceEpoch];
    if (availableTimes == null) {
      return false;
    }
    return availableTimes.isNotEmpty;
  }

  static List<Call> getAvailableTimes(
    CallLink event,
    DateTime date,
    Map<int, Availability> weeklyAvailabilites, {
    List<Reservation>? reservations,
  }) {
    DateTime beginOfDay = DateTime(date.year, date.month, date.day);
    List<Call> availableTimes = [];
    int dayOfWeek = date.weekday % 7;
    weeklyAvailabilites[dayOfWeek]
        ?.timeslots
        ?.forEach((GTimeInterval? interval) {
      DateTime now = DateTime.now();

      DateTime start =
          beginOfDay.add(Duration(minutes: interval!.startMinuteOfDay));
      DateTime end = beginOfDay.add(Duration(minutes: interval.endMinuteOfDay));
      if (end.isBefore(now)) {
        // print("end: $end is before now: $now");
        return;
      }
      while (start.isBefore(end)) {
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
        if (reservations != null) {
          final scheduledTimes =
              reservations.map<DateTime?>((e) => e.scheduledAt).toList();
          int index = ScheduleUtils.search<DateTime?>(scheduledTimes, start,
              compare: (DateTime? a) =>
                  a!.isAtSameMomentAs(start) || a.isAfter(start));
          if (index < scheduledTimes.length &&
              scheduledTimes[index]!.difference(start) < event.duration!) {
            start = start.add(event.duration!);
            continue;
          }
        }
        String id = generateUniqueId();
        availableTimes.add(
          Call(
              id: id,
              callLinkId: event.id,
              scheduledAt: start,
              duration: event.duration,
              dayOfWeek: dayOfWeek,
              hostId: event.hostId),
        );
        start = start.add(event.duration!);
      }
    });
    return availableTimes;
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

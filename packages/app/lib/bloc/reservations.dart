import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:collection/collection.dart';
import 'package:timezone/timezone.dart';
import '../models/index.dart';
import '../services/index.dart';

class Reservations extends ChangeNotifier {
  final CallLink? myEvent;
  final User? user;

  StreamSubscription? _availabilitySub;
  StreamSubscription? _reservationSub;
  DateTimeRange? _dateRange;
  Map<int?, Availability>? _weeklyAvailabilities;
  Map<int, List<Call>>? _availableTimes;
  Map<DateTime, List<Reservation>>? _reservations;
  Object? _weeklyAvailabilityError;
  Object? _reservationError;
  bool _reservationLoading = false;
  Timer? _timer;
  Location? _timeZone;
  Reservations(this.myEvent, this.user, Location? timeZone)
      : _timeZone = timeZone {
    _subscribeWeeklyAvailability();
  }

  bool get reservationLoading => _reservationLoading;
  Object? get weeklyAvailabilityError => _weeklyAvailabilityError;

  Object? get reservationError => _reservationError;
  Map<int?, Availability>? get weeklyAvailabilities => _weeklyAvailabilities;
  Map<int, List<Call>>? get availableTimes => _availableTimes;

  void _updateCurrentDate() {
    _timer?.cancel();
    _timer = Timer(Duration(minutes: 1), () {
      _computeAvailableTimes();
    });
  }

  set dateRange(DateTimeRange dateTimeRange) {
    if (dateTimeRange == _dateRange) return;
    _dateRange = dateTimeRange;
    _subscribeReservations();
    notifyListeners();
  }

  DateTimeRange? get dateTimeRange => _dateRange;

  set timeZone(Location? timeZone) {
    if (_timeZone == timeZone) return;
    _timeZone = timeZone;
    _subscribeReservations();
    notifyListeners();
  }

  Location? get timeZone => _timeZone;

  _subscribeWeeklyAvailability() async {
    _availabilitySub?.cancel();
    _availabilitySub =
        AvailabilityService.getAvailabilityStreamSubscriptionForEvent(
            myEvent!.id, _onWeeklyAvailability,
            onError: _handleWeeklyAvailabilityError);
  }

  _onWeeklyAvailability(List<Availability> availabilities) {
    _weeklyAvailabilities = availabilities.fold<Map<int?, Availability>>({},
        (memo, Availability availability) {
      memo[availability.day] = availability;
      return memo;
    });
    _subscribeReservations();
    notifyListeners();
  }

  _handleWeeklyAvailabilityError(dynamic error, StackTrace stacktrace) {
    // reporter(error, stacktrace);
    _reservationLoading = false;
    _weeklyAvailabilityError = error;
    notifyListeners();
    print("error: $error");
  }

  _subscribeReservations() {
    if (weeklyAvailabilities == null) return;
    if (dateTimeRange == null) return;
    _reservationLoading = true;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime start = today.isAfter(_dateRange!.start)
        ? today
        : DateTime(_dateRange!.start.year, _dateRange!.start.month,
            _dateRange!.start.day);
    DateTime end = DateTime(
        _dateRange!.end.year, _dateRange!.end.month, _dateRange!.end.day);
    List<String?> users;

    if (user!.id == myEvent!.hostId) {
      users = [user!.id];
    } else {
      users = [user!.id, myEvent!.hostId];
    }
    _reservationSub?.cancel();
    _reservationSub =
        AvailabilityService.getUserReservationStreamSubscriptionForDateRange(
            start, end, users, _onReservations,
            onError: _onReservationError);
  }

  void _onReservations(List<Reservation> reservations) {
    _reservationLoading = false;
    _reservations = groupBy<Reservation, DateTime>(
        reservations, //Set.from(reservations),
        (obj) => DateTime(
            obj.scheduledAt.year, obj.scheduledAt.month, obj.scheduledAt.day));

    _computeAvailableTimes();
  }

  void _computeAvailableTimes() {
    if (weeklyAvailabilities == null || _reservations == null) return;
    DateTime today = DateTime(
        _dateRange!.start.year, _dateRange!.start.month, _dateRange!.start.day);
    DateTime start = DateTime(
        _dateRange!.start.year, _dateRange!.start.month, _dateRange!.start.day);
    DateTime end = DateTime(
        _dateRange!.end.year, _dateRange!.end.month, _dateRange!.end.day);
    _availableTimes = _reservations!.map<int, List<Call>>((date, reservations) {
      List<Call> times = IntervalHelper.getAvailableTimes(
          myEvent!, date, _weeklyAvailabilities!, _timeZone,
          reservations: reservations);
      return MapEntry(date.millisecondsSinceEpoch, times);
    });
    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      if (today.isAfter(start)) {
        _availableTimes![start.millisecondsSinceEpoch] = [];
      } else if (_availableTimes![start.millisecondsSinceEpoch] == null) {
        List<Call> times = IntervalHelper.getAvailableTimes(
            myEvent!, start, weeklyAvailabilities!, timeZone);
        _availableTimes![start.millisecondsSinceEpoch] = times;
      }
      start = start.add(Duration(days: 1));
    }
    _updateCurrentDate();
    notifyListeners();
    // print("AVAILABLE TIMES $_availableTimes}");
  }

  _onReservationError(dynamic error, StackTrace stacktrace) {
    // reporter(error, stacktrace);
    _reservationLoading = false;
    _reservationError = error;
    notifyListeners();
    print("error: $error");
  }

  @override
  void dispose() {
    _availabilitySub?.cancel();
    _reservationSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}

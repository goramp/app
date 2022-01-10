import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';
import '../utils/index.dart';
import '../app_config.dart';

const _kCallLinksCollection = 'call_links';

class AvailabilityService {
  final AppConfig config;
  bool configured = false;

  AvailabilityService({required this.config});

  static StreamSubscription<QuerySnapshot> getAvailabilityStreamForDay(
      int? day, String? linkId, void onData(Availability? availability),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    return FirebaseFirestore.instance
        .collectionGroup('availabilities')
        .where('linkId', isEqualTo: linkId)
        .where('day', isEqualTo: day)
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      if (snapshot.docs.isEmpty) {
        onData(null);
        return;
      }
      List<Availability> availabilities = snapshot.docs
          .map<Availability>((doc) => Availability.fromMap(
              asStringKeyedMap(doc.data() as Map<dynamic, dynamic>?)!))
          .toList();
      onData(availabilities[0]);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot> subscribeAvailabilities(
      String linkId,
      String userId,
      void onData(Map<String, List<GTimeInterval>> avaialbilities),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    return FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .collection('availabilities')
        .where("linkId", isEqualTo: linkId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      List timeslots = querySnapshot.docs.map((snapshot) {
        return GTimeInterval.fromMap(
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
      }).toList();
      final Map<String, List<GTimeInterval>> avaialbilities =
          timeslots.fold({}, (memo, timeInterval) {
        memo["${timeInterval.day}"] = [timeInterval];
        return memo;
      });
      onData(avaialbilities);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot> getSlotStreamForDate(DateTime date,
      String linkId, String userId, void onData(List<Reservation> bookings),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    DateTime beginOfDay = DateTime(date.year, date.month, date.day);
    DateTime nextDay = beginOfDay.add(Duration(days: 1));

    return FirebaseFirestore.instance
        .collectionGroup('reservations')
        .where("linkId", isEqualTo: linkId)
        .where("scheduledAt",
            isGreaterThanOrEqualTo: Timestamp.fromDate(beginOfDay))
        .where("scheduledAt", isLessThan: Timestamp.fromDate(nextDay))
        .orderBy("scheduledAt")
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      List<Reservation> bookings = snapshot.docs.map((snapshot) {
        Reservation time = Reservation.fromMap(
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
        return time;
      }).toList();
      onData(bookings);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot>
      getUserReservationStreamSubscriptionForDate(DateTime date,
          List<String> userIds, void onData(List<Reservation> bookings),
          {void onError(error, StackTrace stackTrace)?,
          void onDone()?,
          bool? cancelOnError}) {
    DateTime beginOfDay = DateTime(date.year, date.month, date.day);
    DateTime nextDay = beginOfDay.add(Duration(days: 1));
    return FirebaseFirestore.instance
        .collectionGroup('reservations')
        .where('userId', whereIn: userIds)
        .where("scheduledAt",
            isGreaterThanOrEqualTo: Timestamp.fromDate(beginOfDay))
        .where("scheduledAt", isLessThan: Timestamp.fromDate(nextDay))
        .orderBy("scheduledAt")
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      List<Reservation> bookings = snapshot.docs.map((snapshot) {
        Reservation time = Reservation.fromMap(
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
        return time;
      }).toList();
      onData(bookings);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription getUserReservationStreamSubscriptionForDateRange(
      DateTime startDate,
      DateTime endDate,
      List<String?> userIds,
      void onData(List<Reservation> bookings),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    return FirebaseFirestore.instance
        .collectionGroup('reservations')
        .where('userId', whereIn: userIds)
        .where("scheduledAt",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where("scheduledAt", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy("scheduledAt")
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      List<Reservation> bookings = snapshot.docs.map((snapshot) {
        Reservation time = Reservation.fromMap(
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
        return time;
      }).toList();
      onData(bookings);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static Stream<List<Reservation>> getUserReservationStreamForDateRange(
    DateTime startDate,
    DateTime endDate,
    List<String> userIds,
  ) {
    return FirebaseFirestore.instance
        .collectionGroup('reservations')
        .where('userId', whereIn: userIds)
        .where("scheduledAt",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where("scheduledAt", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy("scheduledAt")
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((snapshot) {
        Reservation time = Reservation.fromMap(
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
        return time;
      }).toList();
    });
  }

  static StreamSubscription<QuerySnapshot> getReservationsStreamForDay(
      int? day, String? linkId, void onData(List<Reservation> bookings),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    print("get Reservations for : $linkId and day: $day");
    return FirebaseFirestore.instance
        .collectionGroup('reservations')
        .where("linkId", isEqualTo: linkId)
        .where("dayOfWeek", isEqualTo: day)
        .orderBy("scheduledAt")
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      List<Reservation> reservations = snapshot.docs.map((snapshot) {
        Reservation time = Reservation.fromMap(
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
        return time;
      }).toList();
      onData(reservations);
    }, onError: (error) {
      print("on error: $error");
    }, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot>
      getAvailabilityStreamSubscriptionForEvent(
          String? linkId, void onData(List<Availability> availabilities),
          {void onError(error, StackTrace stackTrace)?,
          void onDone()?,
          bool? cancelOnError}) {
    return FirebaseFirestore.instance
        .collectionGroup('availabilities')
        .where('linkId', isEqualTo: linkId)
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      List<Availability> availabilities = snapshot.docs
          .map<Availability>((doc) => Availability.fromMap(
              asStringKeyedMap(doc.data() as Map<dynamic, dynamic>?)!))
          .toList();
      onData(availabilities);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static Stream<List<Availability>> getAvailabilityStreamForEvent(
    String linkId,
    String userId,
  ) {
    return FirebaseFirestore.instance
        .collectionGroup('availabilities')
        .where('linkId', isEqualTo: linkId)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Availability> availabilities = snapshot.docs
          .map<Availability>((doc) => Availability.fromMap(
              asStringKeyedMap(doc.data() as Map<dynamic, dynamic>?)!))
          .toList();
      return availabilities;
    });
  }

  static Future<void> saveAvailabilitiy(
      String? linkId, Availability availability) {
    return FirebaseFirestore.instance
        .doc(
            '$_kCallLinksCollection/$linkId/availabilities/${availability.day}')
        .set(availability.toMap(), SetOptions(merge: true));
  }

  static Future<void> addTimeInterval(GTimeInterval interval,
      {bool isDraft = true}) async {
    FirebaseFirestore.instance
        .collection('profiles')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('availabilities')
        .doc(interval.id)
        .set(interval.toMap());
  }

  static Future<void> removeTimeInterval(GTimeInterval interval,
      {bool isDraft = true}) async {
    FirebaseFirestore.instance
        .collection('profiles')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('availabilities')
        .doc(interval.id)
        .delete();
  }

  static Future<void> updateTimeInterval(GTimeInterval interval, String linkId,
      {bool isDraft = true}) async {
    FirebaseFirestore.instance
        .collection('profiles')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('availabilities')
        .doc(interval.id)
        .update(interval.toMap());
  }
}

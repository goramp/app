import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone_name/timezone_name.dart';
import '../models/index.dart';
import '../utils/index.dart';

const String path = 'calls';
const String _kerrUnavailable = '01';
const String _kerrInSufficentCredit = '02';
const String _kerrUnknown = 'unknown';

class CallException implements Exception {
  final int? statusCode;
  final String? message;
  final String? code;
  CallException({this.statusCode, this.code, this.message});

  @override
  String toString() {
    return "[statusCode: $statusCode, code: $code, message: $message]";
  }
}

class UnavailableException implements Exception {
  final String? message;
  UnavailableException({this.message});

  @override
  String toString() {
    return "[message: $message]";
  }
}

class LowCreditException implements Exception {
  final String? message;
  LowCreditException({this.message});

  @override
  String toString() {
    return "[message: $message]";
  }
}

class CallService {
  static StreamSubscription getUpcomingCallsSubscription(
      String? userId, void onData(List<Call> schedules),
      {Call? last,
      required int limit,
      void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("participants", arrayContains: userId)
        .where("confirmed", isEqualTo: true)
        .where("status", whereIn: ['pending', 'started'])
        //.orderBy("confirmationStatusCode", descending: true)
        .orderBy("scheduledAt")
        .limit(limit);
    if (last != null) {
      query = query.startAfter([last.scheduledAt]);
    }
    return query.snapshots().listen((QuerySnapshot querySnapshot) {
      List<Call> schedules =
          querySnapshot.docs.map((DocumentSnapshot snapshot) {
        final map =
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        map['id'] = snapshot.id;
        return Call.fromMap(map);
      }).toList();
      onData(schedules);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static Future<List<Call>> fetchUpcomingCalls(String? userId,
      {Call? first, Call? last, required limit}) async {
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("participants", arrayContains: userId)
        .where("confirmed", isEqualTo: true)
        .where("status", whereIn: ['pending', 'started'])
        //.orderBy("confirmationStatusCode", descending: true)
        .orderBy("scheduledAt")
        .limit(limit);
    if (first != null) {
      query = query.endBefore([first.scheduledAt]);
    }
    if (last != null) {
      query = query.startAfter([last.scheduledAt]);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return Call.fromMap(map as Map<String, dynamic>);
    }).toList();
  }

  static StreamSubscription getPastCallsSubscription(
      String? userId, void onData(List<Call> schedules),
      {Call? last,
      required int limit,
      void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("participants", arrayContains: userId)
        .where("confirmed", isEqualTo: true)
        .where("status", isEqualTo: 'ended')
        .orderBy("scheduledAt", descending: true)
        .limit(limit);
    if (last != null) {
      query = query.startAfter([last.endAt]);
    }
    return query.snapshots().listen((QuerySnapshot querySnapshot) {
      List<Call> schedules =
          querySnapshot.docs.map((DocumentSnapshot snapshot) {
        final map =
            asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        map['id'] = snapshot.id;
        return Call.fromMap(map);
      }).toList();
      onData(schedules);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static Future<List<Call>> fetchPastCalls(String? userId,
      {Call? first, Call? last, required limit}) async {
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("participants", arrayContains: userId)
        .where("confirmed", isEqualTo: true)
        .where("status", isEqualTo: 'ended')
        .orderBy("scheduledAt", descending: true)
        .limit(limit);
    if (first != null) {
      query = query.endBefore([first.scheduledAt]);
    }
    if (last != null) {
      query = query.startAfter([last.scheduledAt]);
    }
    QuerySnapshot snapshot = await query.get();
    List<Call> schedules = snapshot.docs.map((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return Call.fromMap(map as Map<String, dynamic>);
    }).toList();
    Map<String?, List<Call>> grouped =
        groupBy(schedules, (Call schedule) => schedule.callLinkId);
    schedules =
        grouped.keys.map<Call>((String? key) => grouped[key]!.first).toList();
    return schedules;
  }

  static Future<void> schedule(String? baseUrl, Call schedule) async {
    final user = fb.FirebaseAuth.instance.currentUser!;
    final String currentTimeZone = await TimezoneName.name;
    final scheduleInput = CallInput(
        callLinkId: schedule.callLinkId,
        scheduledAt: schedule.scheduledAt,
        guesTimezone: currentTimeZone,
        hostId: schedule.hostId,
        guestId: user.uid);
    final data = scheduleInput.toMap();
    final String token = await user.getIdToken();
    final response = await http.post(
      Uri.parse("$baseUrl/$path/"),
      body: json.encode(data),
      headers: {
        'Authorization': "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      final Map<String, dynamic> resData = json.decode(response.body);
      if (resData["errorType"] != null) {
        if (resData["errorType"] == _kerrUnavailable) {
          throw UnavailableException(message: resData["errorMessage"]);
        } else if (resData["errorType"] == _kerrInSufficentCredit) {
          throw LowCreditException(message: resData["errorMessage"]);
        } else {
          throw CallException(
              statusCode: response.statusCode,
              code: resData["errorType"],
              message: resData["errorMessage"]);
        }
      } else {
        throw CallException(
            statusCode: response.statusCode,
            code: _kerrUnknown,
            message: "Something went wrong");
      }
    }
  }

  static Future<void> cancel(String baseUrl, Call schedule,
      {String? cancelReason}) async {
    final user = fb.FirebaseAuth.instance.currentUser!;
    final cancelScheduleInput = CancelCallInput(
        callLinkId: schedule.callLinkId,
        hostId: schedule.hostId,
        cancelReason: cancelReason,
        scheduleId: schedule.id);
    final data = cancelScheduleInput.toMap();
    final token = await user.getIdToken();
    final url = "$baseUrl/$path/${schedule.id}/cancel";
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Authorization': "Bearer $token",
        "Content-Type": "application/json"
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      final Map<String, dynamic> resData = json.decode(response.body);
      if (resData["errorType"] != null) {
        if (resData["errorType"] == _kerrUnavailable) {
          throw UnavailableException(message: resData["errorMessage"]);
        } else if (resData["errorType"] == _kerrInSufficentCredit) {
          throw LowCreditException(message: resData["errorMessage"]);
        } else {
          throw CallException(
              statusCode: response.statusCode,
              code: resData["errorType"],
              message: resData["errorMessage"]);
        }
      } else {
        throw CallException(
            statusCode: response.statusCode,
            code: _kerrUnknown,
            message: "Something went wrong");
      }
    }
  }

  static Stream<Call> getCallStream(String? scheduleId) {
    return FirebaseFirestore.instance
        .collection(path)
        .doc(scheduleId)
        .snapshots()
        .map<Call>((DocumentSnapshot snapshot) {
      final map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return Call.fromMap(map);
    });
  }

  static Future<Call?> getCallFromId(String scheduleId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection(path).doc(scheduleId).get();
    if (snapshot.exists) {
      final map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return Call.fromMap(map);
    }
    return null;
  }

  static Future<String?> getSearchApiKey(
    String? baseUrl,
  ) async {
    final user = fb.FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    final url = "$baseUrl/$path/searchKey";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': "Bearer $idToken",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final keyData = asStringKeyedMap(json.decode(response.body))!;
      return keyData['key'];
    } else {
      final Map<String, dynamic> resData = json.decode(response.body);
      if (resData["errorType"] != null) {
        throw CallException(
            statusCode: response.statusCode,
            code: resData["errorType"],
            message: resData["errorMessage"]);
      } else {
        throw CallException(
            statusCode: response.statusCode,
            code: _kerrUnknown,
            message: "Something went wrong");
      }
    }
  }
}

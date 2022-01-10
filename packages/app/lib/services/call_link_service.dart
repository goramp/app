import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:goramp/models/cover_pattern.dart';
import 'package:goramp/models/fb_file_asset.dart';
import '../app_config.dart';
import '../models/index.dart';
import '../utils/index.dart';

const _kCollection = 'call_links';
const _kProfilesCol = 'profiles';
const _kFilesCol = 'files';
const _kPatternsCol = 'patterns';
const _kVidProcCol = 'video_processing';
const _kImagesCol = 'images';
const _kVidPrevCol = 'video_preview';

enum CallLinkExceptionCode {
  EndDateBeforeStart, //end-date-before-start
  EndDateInPast, //end-date-in-sell
  StartDateInPast, //start-date-in-sell
  DurationUnsupported, //duration-unsupported
  InvalidDate, //duration-unsupported
  InvalidVideo, //invalid-video
  InvalidPaymentProvider, //invalid-payment-provider
  InvalidAvailabilities, //invalid-availabilities
  DayOutOfRange, //availabilty-day-out-of-range
  NoFreeCallPrice, //no-free-call-price
  InvalidPriceOrCurrency, //invalid-price-or-currency
  ConnectionError, //connection-error
  Unknown, //unknown
}

class CallLinkException implements Exception {
  final CallLinkExceptionCode code;
  final String? message;
  CallLinkException(this.code, {this.message = StringResources.UNKNOWN_ERROR});

  factory CallLinkException.fromMap(Map<String, dynamic> map) {
    return CallLinkException(
      mapToCallLinkException(map['code']),
      message: map['errorMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
    };
  }

  static CallLinkExceptionCode mapToCallLinkException(String? code) {
    switch (code) {
      case "call_link/end_date_before_start":
        return CallLinkExceptionCode.EndDateBeforeStart;
      case "call_link/duration_unsupported":
        return CallLinkExceptionCode.DurationUnsupported;
      case "call_link/end_date_in_past":
        return CallLinkExceptionCode.EndDateInPast;
      case "call_link/start_date_in_past":
        return CallLinkExceptionCode.StartDateInPast;
      case "call_link/invalid_video":
        return CallLinkExceptionCode.InvalidVideo;
      case "call_link/invalid_payment_provider":
        return CallLinkExceptionCode.InvalidPaymentProvider;
      case "call_link/invalid_availabilities":
        return CallLinkExceptionCode.InvalidAvailabilities;
      case "call_link/availabilty_day_out_of_range":
        return CallLinkExceptionCode.DayOutOfRange;
      case "call_link/no_free_call_price":
        return CallLinkExceptionCode.NoFreeCallPrice;
      case "call_link/invalid_price_or_currency":
        return CallLinkExceptionCode.InvalidPriceOrCurrency;

      default:
        return CallLinkExceptionCode.Unknown;
    }
  }

  String toString() {
    return '${toMap()}';
  }
}

class UploadResult {
  UploadTask uploadTask;
  String fileName;
  UploadResult(this.uploadTask, this.fileName);
}

class CallLinkService {
  final AppConfig config;
  final Map<String, Task> videoUploadTasks = <String, Task>{};
  final Map<String, Task> thumbnailUploadTasks = <String, Task>{};

  CallLinkService(this.config);

  static Future<CallLink> createCallLink(
      CallLinkPost eventPost, AppConfig config) async {
    try {
      final data = eventPost.toMap();
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('createCallLink');
      final result = await callable.call(data);
      final callLink = CallLink.fromMap(asStringKeyedMap(result.data)!);
      return callLink;
    } on FirebaseFunctionsException catch (error) {
      throw mapToCallLinkException(error);
    } catch (error) {
      throw CallLinkException(CallLinkExceptionCode.Unknown,
          message: error.toString());
    }
  }

  static Future<CallLink> updateCallLink(
      CallLinkPost eventPost, AppConfig config) async {
    try {
      final data = eventPost.toMap();
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('updateCallLink');
      final result = await callable.call(data);
      final callLink = CallLink.fromMap(asStringKeyedMap(result.data)!);
      return callLink;
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToCallLinkException(error);
    } catch (error) {
      print('error: $error');
      throw CallLinkException(CallLinkExceptionCode.Unknown,
          message: error.toString());
    }
  }

  static Future<CallLink> updateEventPost(CallLinkPost eventPost) async {
    CallLink event = eventPost.callLink!;
    final documentPath = "events/${event.id}";
    final data = event.toUpdateMap();
    if (data['updatedAt'] == null) {
      data['updatedAt'] = FieldValue.serverTimestamp();
    } else {
      data['updatedAt'] =
          Timestamp.fromMillisecondsSinceEpoch(data['updatedAt']);
    }
    data['startDate'] = Timestamp.fromMillisecondsSinceEpoch(data['startDate']);
    data['endDate'] = Timestamp.fromMillisecondsSinceEpoch(data['endDate']);
    final eventRef = FirebaseFirestore.instance.doc(documentPath);
    await eventRef.set(data, SetOptions(merge: true));
    return event;
  }

  static Future<void> deleteCallLink(CallLink callLink) async {
    final documentPath = "$_kCollection/${callLink.id}";
    FirebaseFirestore.instance.doc(documentPath).delete();
    return;
  }

  static Future<void> saveAvailability(
      String userId, Availability availability) async {
    final availabilityPath = "profiles/$userId/availabilities";
    final batch = FirebaseFirestore.instance.batch();
    availability.timeslots!.forEach((GTimeInterval? interval) async {
      final intervalRef = FirebaseFirestore.instance
          .collection(availabilityPath)
          .doc(interval!.id);
      batch.set(intervalRef, interval.toMap(), SetOptions(merge: true));
    });
    await batch.commit();
  }

  static Future<void> updateLike(String? userId, CallLink event,
      {like = true}) async {
    if (event.hostId == userId) {
      return;
    }
    final userRef = FirebaseFirestore.instance.doc("profiles/$userId");
    final likedEventRef = userRef.collection("liked_call_links").doc(event.id);
    if (like) {
      likedEventRef.set({...event.toMap(), 'likedByUserId': userId});
    } else {
      likedEventRef.delete();
    }
  }

  static Future<void> updateFavoriteCallLink(
      String? userId, CallLink? before, CallLink? after) async {
    final userRef = FirebaseFirestore.instance.doc("profiles/$userId");
    if (before?.likedByUserId != userId) {
      return;
    }
    if (before != null) {
      final likedEventRef =
          userRef.collection("liked_call_links").doc(before.id);
      await FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentSnapshot likeSnapshot = await transaction.get(likedEventRef);
        if (!likeSnapshot.exists) {
          return;
        }
        transaction
            .set(likedEventRef, {...before.toMap(), 'likedByUserId': userId});
      });
    }
  }

  static Future<void> viewEvent(String userId, CallLink event) async {
    if (event.hostId == userId) {
      return;
    }
    final userRef = FirebaseFirestore.instance.doc("profiles/$userId");
    final viewEventRef = userRef.collection("viewed_events").doc(event.id);
    final Map<String, dynamic> data = {"userId": userId, "eventId": event.id};
    await viewEventRef.set(data, SetOptions(merge: true));
  }

  static Future<CallLink> activateEvent(
      String userId, CallLink event, bool isActive) async {
    final documentPath = "profiles/$userId/events/${event.id}";
    final eventRef = FirebaseFirestore.instance.doc(documentPath);
    await eventRef.update({'active': isActive});
    return event.copyWith(active: isActive);
  }

  static StreamSubscription<DocumentSnapshot> getEventSubscription(
      String callLinkId, String userId, void onData(CallLink callLink),
      {void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError}) {
    return FirebaseFirestore.instance
        .collection(_kCollection)
        .doc(callLinkId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) async {
      if (!snapshot.exists) {
        return null;
      }
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      CallLink event = CallLink.fromMap(map as Map<String, dynamic>);
      onData(event);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static Stream<Counter?> getLikeEventCountSubscription(String callLinkId) {
    return FirebaseFirestore.instance
        .collection(_kCollection)
        .doc(callLinkId)
        .collection('counters')
        .doc("likes")
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      Counter counter = Counter.fromMap(map as Map<String, dynamic>);
      return counter;
    });
  }

  static Stream<Video?> getVideoPreview(String? callLinkId) {
    return FirebaseFirestore.instance
        .collection(_kVidPrevCol)
        .doc(callLinkId)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      return Video.fromMap(map as Map<String, dynamic>);
    });
  }

  static Stream<Counter?> getViewEventCountSubscription(String callLinkId) {
    return FirebaseFirestore.instance
        .collection(_kCollection)
        .doc(callLinkId)
        .collection('counters')
        .doc("views")
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      return Counter.fromMap(map as Map<String, dynamic>);
    });
  }

  static Stream<CallLink> getCallLinkStream(String? eventId) {
    return FirebaseFirestore.instance
        .collection(_kCollection)
        .doc(eventId)
        .snapshots()
        .map<CallLink>((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return CallLink.fromMap(map as Map<String, dynamic>);
    });
  }

  static Stream<bool> userLikedCallLinkStream(String? eventId, String? userId) {
    return FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .collection('liked_call_links')
        .doc(eventId)
        .snapshots()
        .map<bool>((DocumentSnapshot snapshot) {
      return snapshot.exists;
    });
  }

  static StreamSubscription<QuerySnapshot> getCallLinksSubscriptionByUserId(
      String? userId, void onData(List<CallLink> events),
      {required int limit,
      void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError,
      bool public = false}) {
    return FirebaseFirestore.instance
        .collection(_kCollection)
        .limit(limit)
        .where("enabled", isEqualTo: true)
        .where("published", isEqualTo: true)
        .where("hostId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      List events = querySnapshot.docs.map((DocumentSnapshot snapshot) {
        Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        CallLink event = CallLink.fromMap(map as Map<String, dynamic>);
        return event;
      }).toList();
      onData(events as List<CallLink>);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot> getMyCallLinksSubscriptionByUserId(
      String? userId, void onData(List<CallLink> events),
      {required int limit,
      void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError,
      bool public = false}) {
    return FirebaseFirestore.instance
        .collection(_kCollection)
        .limit(limit)
        .where("hostId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      List events = querySnapshot.docs.map((DocumentSnapshot snapshot) {
        Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        CallLink event = CallLink.fromMap(map as Map<String, dynamic>);
        return event;
      }).toList();
      onData(events as List<CallLink>);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot> getMyCallLinksSubscriptionByUserName(
      String? username, void onData(List<CallLink> events),
      {required int limit,
      void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError,
      bool public = false}) {
    return FirebaseFirestore.instance
        .collection(_kCollection)
        .limit(limit)
        .where("hostUsername", isEqualTo: username)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      List events = querySnapshot.docs.map((DocumentSnapshot snapshot) {
        Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        CallLink event = CallLink.fromMap(map as Map<String, dynamic>);
        return event;
      }).toList();
      onData(events as List<CallLink>);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot> getCallLinksSubscriptionByUserName(
      String? username, void onData(List<CallLink> events),
      {required int limit,
      void onError(error, StackTrace stackTrace)?,
      void onDone()?,
      bool? cancelOnError,
      bool public = false}) {
    return FirebaseFirestore.instance
        .collection(_kCollection)
        .limit(limit)
        .where("enabled", isEqualTo: true)
        .where("published", isEqualTo: true)
        .where("hostUsername", isEqualTo: username)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      List events = querySnapshot.docs.map((DocumentSnapshot snapshot) {
        Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        CallLink event = CallLink.fromMap(map as Map<String, dynamic>);
        return event;
      }).toList();
      onData(events as List<CallLink>);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot>
      getCallLinksSubscriptionLikedByUserId(
          String? userId, void onData(List<CallLink> events),
          {required int limit,
          String? hostId,
          void onError(error, StackTrace stackTrace)?,
          void onDone()?,
          bool? cancelOnError}) {
    Query query = FirebaseFirestore.instance
        .collectionGroup('liked_call_links')
        .where("likedByUserId", isEqualTo: userId);
    if (hostId != null) {
      query = query.where("hostId", isEqualTo: hostId);
    }
    return query
        .limit(limit)
        //.where("video.enabled", isEqualTo: true)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      List events = querySnapshot.docs.map((DocumentSnapshot snapshot) {
        Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        map['id'] = snapshot.id;
        CallLink event = CallLink.fromMap(map as Map<String, dynamic>);
        return event;
      }).toList();
      onData(events as List<CallLink>);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<QuerySnapshot>
      getCallLinksSubscriptionLikedByUsername(
          String? userId, void onData(List<CallLink> events),
          {required int limit,
          String? hostId,
          void onError(error, StackTrace stackTrace)?,
          void onDone()?,
          bool? cancelOnError}) {
    Query query = FirebaseFirestore.instance
        .collectionGroup('liked_call_links')
        .where("likedByUsername", isEqualTo: userId);
    if (hostId != null) {
      query = query.where("hostId", isEqualTo: hostId);
    }
    return query
        //.where("video.enabled", isEqualTo: true)
        .orderBy("createdAt", descending: true)
        .limit(limit)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      List events = querySnapshot.docs.map((DocumentSnapshot snapshot) {
        Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
        map['id'] = snapshot.id;
        CallLink event = CallLink.fromMap(map as Map<String, dynamic>);
        return event;
      }).toList();
      onData(events as List<CallLink>);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static Future<List<CallLink>> getMyCallLinksByUserName(String userId,
      {CallLink? first, CallLink? last, required limit}) async {
    Query query = FirebaseFirestore.instance
        .collection(_kCollection)
        .where("hostId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .limit(limit);
    if (last != null) {
      query = query.startAfter([last.createdAt]);
    }
    if (first != null) {
      query = query.endBefore([first.createdAt]);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return CallLink.fromMap(map as Map<String, dynamic>);
    }).toList();
  }

  static Future<List<CallLink>> getCallLinksByUserName(String? userId,
      {CallLink? first, CallLink? last, required limit}) async {
    Query query = FirebaseFirestore.instance
        .collection(_kCollection)
        .where("enabled", isEqualTo: true)
        .where("published", isEqualTo: true)
        .where("hostId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .limit(limit);
    if (last != null) {
      query = query.startAfter([last.createdAt]);
    }
    if (first != null) {
      query = query.endBefore([first.createdAt]);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return CallLink.fromMap(map as Map<String, dynamic>);
    }).toList();
  }

  static Future<List<CallLink>> getCallLinksByUserId(String? userId,
      {CallLink? first, CallLink? last, required limit}) async {
    Query query = FirebaseFirestore.instance
        .collection(_kCollection)
        .where("enabled", isEqualTo: true)
        .where("published", isEqualTo: true)
        .where("hostId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .limit(limit);
    if (last != null) {
      query = query.startAfter([last.createdAt]);
    }
    if (first != null) {
      query = query.endBefore([first.createdAt]);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return CallLink.fromMap(map as Map<String, dynamic>);
    }).toList();
  }

  static Future<List<CallLink>> getCallLinksLikedByUserId(String? userId,
      {String? hostId, CallLink? first, CallLink? last, required limit}) async {
    Query query = FirebaseFirestore.instance
        .collectionGroup('liked_call_links')
        .where("likedByUserId", isEqualTo: userId);
    if (hostId != null) {
      query = query.where("hostId", isEqualTo: hostId);
    }
    query = query.orderBy("createdAt", descending: true).limit(limit);
    if (last != null) {
      query = query.startAfter([last.createdAt]);
    }
    if (first != null) {
      query = query.endBefore([last!.createdAt]);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return CallLink.fromMap(map as Map<String, dynamic>);
    }).toList();
  }

  static Future<List<CallLink>> getCallLinksLikedByUsername(String? userId,
      {String? hostId, CallLink? first, CallLink? last, required limit}) async {
    Query query = FirebaseFirestore.instance
        .collectionGroup('liked_call_links')
        .where("likedByUsername", isEqualTo: userId);
    if (hostId != null) {
      query = query.where("hostId", isEqualTo: hostId);
    }
    query = query.orderBy("createdAt", descending: true).limit(limit);
    if (last != null) {
      query = query.startAfter([last.createdAt]);
    }
    if (first != null) {
      query = query.endBefore([last!.createdAt]);
    }
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((DocumentSnapshot snapshot) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return CallLink.fromMap(map as Map<String, dynamic>);
    }).toList();
  }

  static Future<CallLink?> getCallLinkFromId(String? eventId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(_kCollection)
        .doc(eventId)
        .get();
    if (snapshot.exists) {
      Map map = asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!;
      map['id'] = snapshot.id;
      return CallLink.fromMap(map as Map<String, dynamic>);
    }
    return null;
  }

  dispose() {
    videoUploadTasks.clear();
  }

  static Stream<VideoProcessing?> videoProcessingStream(String? fileName) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection(_kProfilesCol)
        .doc(uid)
        .collection(_kVidProcCol)
        .doc(fileName)
        .snapshots()
        .map<VideoProcessing?>((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return VideoProcessing.fromMap(
        snapshot.id,
        asStringKeyedMap(
          snapshot.data() as Map<dynamic, dynamic>?,
        )!,
      );
    });
  }

  static Stream<ImageMedia?> coverStream(String? fileName) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection(_kFilesCol)
        .doc(uid)
        .collection(_kImagesCol)
        .doc(fileName)
        .snapshots()
        .map<ImageMedia?>((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return ImageMedia.fromMap(
        asStringKeyedMap(
          snapshot.data() as Map<dynamic, dynamic>?,
        )!,
      );
    });
  }

  static Stream<List<CoverPattern>> coverPatternStream() {
    return FirebaseFirestore.instance
        .collection(_kPatternsCol)
        .snapshots()
        .map<List<CoverPattern>>((QuerySnapshot snapshots) {
      if (snapshots.docs.isEmpty) {
        return [];
      }
      return snapshots.docs
          .map(
            (doc) => CoverPattern.fromMap(
              asStringKeyedMap(
                doc.data() as Map<dynamic, dynamic>?,
              )!,
            ),
          )
          .toList();
    });
  }

  static Future<UploadResult> uploadVideo(
      String fileName, VideoAsset videoAsset, AppConfig config) async {
    final bytes = await videoAsset.videoFile!.readAsBytes();
    final task = _doUploadVideo(fileName, videoAsset, config, bytes);
    return UploadResult(task, fileName);
  }

  static UploadTask _doUploadVideo(String fileName, VideoAsset videoAsset,
      AppConfig config, Uint8List bytes) {
    final storage =
        FirebaseStorage.instance.refFromURL("gs://${config.tempStorageBucket}");
    final Reference imageRef = storage.child(fileName);
    final videoUploadTask = imageRef.putData(
      bytes,
      SettableMetadata(
        contentType: videoAsset.mimeType,
        cacheControl: config.storageCacheControl,
      ),
    );
    return videoUploadTask;
  }

  static Future<FileAsset> uploadCustomCover(
      FileAsset file, AppConfig config) async {
    final bytes = await file.file!.readAsBytes();
    final storage =
        FirebaseStorage.instance.refFromURL("gs://${config.tempStorageBucket}");
    final Reference imageRef = storage.child(file.id!);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final documentPath = "files/$userId/images/${file.id!}";
    final imageUploadTask = imageRef.putData(
      bytes,
      SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: config.storageCacheControl,
        customMetadata: {
          "documentPath": documentPath,
          'style': 'cover',
        },
      ),
    );
    return file.copyWith(uploadTask: imageUploadTask);
  }

  static Future<String> getCustomCoverUrl(
      FileAsset file, AppConfig config) async {
    final storage =
        FirebaseStorage.instance.refFromURL("gs://${config.tempStorageBucket}");
    final Reference imageRef = storage.child(file.id!);
    final url = imageRef.getDownloadURL();
    return url;
  }

  static Future<Video> processVideo(
      String fileName, AppConfig config, String? contentType) async {
    final app = FirebaseFunctions.instanceFor(region: config.region!);
    HttpsCallable callable = app.httpsCallable(
      'processVideo',
      options: HttpsCallableOptions(
        timeout: Duration(minutes: 9),
      ),
    );
    final result = await callable.call({
      "name": fileName,
      "bucket": config.tempStorageBucket,
      "contentType": contentType
    });
    return Video.fromMap(asStringKeyedMap(result.data)!);
  }

  // static Future<Video> publish(
  //     String fileName, AppConfig config, String contentType) async {
  //   HttpsCallable callable = FirebaseFunctions.instanceFor(.httpsCallable(
  //     'publish',
  //     options: HttpsCallableOptions(
  //       timeout: Duration(minutes: 9),
  //     ),
  //   );
  //   final result = await callable.call({
  //     "name": fileName,
  //     "bucket": config.tempStorageBucket,
  //     "contentType": contentType
  //   });
  //   return Video.fromMap(asStringKeyedMap(result.data));
  // }

  static Future<void> publish(CallLink event, {publish = true}) async {
    if (event.hostId != FirebaseAuth.instance.currentUser?.uid) {
      return;
    }
    final callLinkRef =
        FirebaseFirestore.instance.collection("call_links").doc(event.id);
    final update = {'published': publish};
    await callLinkRef.update(update);
  }

  static CallLinkException mapToCallLinkException(Exception exception) {
    if (exception is FirebaseFunctionsException) {
      if (exception.details != null) {
        print('Exception Details: ${exception.details}');
        return CallLinkException.fromMap(asStringKeyedMap(exception.details)!);
      }
      return CallLinkException(CallLinkExceptionCode.Unknown);
    } else {
      return CallLinkException(CallLinkExceptionCode.Unknown);
    }
  }
}

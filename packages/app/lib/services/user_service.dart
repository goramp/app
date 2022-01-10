import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:goramp/utils/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';
import '../models/index.dart';
import '../app_config.dart';

enum UserExceptionCode {
  ProfileNotFound, //end-date-before-start
  EmailExists, //end-date-in-sell
  UsernameExists, //start-date-in-sell
  UserNotFound, //duration-unsupported
  InvalidDate, //duration-unsupported
  NameEmpty, //invalid-video
  UsernameEmpty, //invalid-payment-provider
  EmailFormatInvalid, //invalid-availabilities
  EmailEmpty, //availabilty-day-out-of-range
  NoFreeCallPrice, //no-free-call-price
  InvalidPriceOrCurrency, //invalid-price-or-currency
  ConnectionError, //connection-error
  Unknown, //unknown
}

class UserException implements Exception {
  final UserExceptionCode code;
  final String? message;
  UserException(this.code, {this.message = StringResources.UNKNOWN_ERROR});

  factory UserException.fromMap(Map<String, dynamic> map) {
    return UserException(
      mapToAuthException(map['code']),
      message: map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
    };
  }

  static UserExceptionCode mapToAuthException(String? code) {
    switch (code) {
      case "user/profile_not_found":
        return UserExceptionCode.ProfileNotFound;
      case "user/user_not_found":
        return UserExceptionCode.UserNotFound;
      case "user/email_exists":
        return UserExceptionCode.EmailExists;
      case "user/username_exists":
        return UserExceptionCode.UsernameExists;
      case "user/name_empty":
        return UserExceptionCode.NameEmpty;
      case "user/username_empty":
        return UserExceptionCode.UsernameEmpty;
      case "user/email_format_invalid":
        return UserExceptionCode.EmailFormatInvalid;
      case "user/email_empty":
        return UserExceptionCode.EmailEmpty;

      default:
        return UserExceptionCode.Unknown;
    }
  }

  String toString() {
    return '${toMap()}';
  }
}

class UserService {
  static Future<void> registerMessagingToken(String token) async {
    final user = fb.FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final ref = FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .collection("messaging_tokens")
        .doc(token);
    await ref.set({
      "token": token,
      "platform": UniversalPlatform.isWeb ? 'web' : Platform.operatingSystem,
      "updatedAt": Timestamp.now()
    }, SetOptions(merge: true));
  }

  static Future<void> unRegisterMessagingToken(String token) async {
    final user = fb.FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final ref = FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .collection("messaging_tokens")
        .doc(token);
    await ref.delete();
  }

  static Stream<UserProfile?> getProfileStream(String? userId) {
    return FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        //todo @peerwaya handle user ac count deletion
        return null;
      }
      return UserProfile.fromMap(
          asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
    });
  }

  static Stream<UserKYC?> getKYCStream(String? userId) {
    return FirebaseFirestore.instance
        .collection('kyc')
        .doc(userId)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        //todo @peerwaya handle user ac count deletion
        return null;
      }
      final userKYC = UserKYC.fromMap(
          asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
      return userKYC;
    });
  }

  static Stream<UserSession?> getUserSessionStream(String? userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        //todo @peerwaya handle user ac count deletion
        return null;
      }
      final userSession = UserSession.fromMap(
          asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
      return userSession;
    });
  }

  static Stream<UserProfile?> getProfileStreamByUsername(String username) {
    return FirebaseFirestore.instance
        .collection('profiles')
        .where('username', isEqualTo: username)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return UserProfile.fromMap(
          asStringKeyedMap(snapshot.docs[0].data() as Map<dynamic, dynamic>?)!);
    });
  }

  static Future<UserProfile?> getProfileByUsername(String username) async {
    final query = await FirebaseFirestore.instance
        .collection('profiles')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      return null;
    }
    return UserProfile.fromMap(query.docs.first.data().cast<String, dynamic>());
  }

  static Future<UserProfile?> getProfile(String? userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get();
    if (!snapshot.exists) {
      return null;
    }
    return UserProfile.fromMap(
        asStringKeyedMap(snapshot.data() as Map<dynamic, dynamic>?)!);
  }

  static Future<UserProfile> createProfile(AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('createUserProfile');
      final result = await callable.call();
      return UserProfile.fromMap(asStringKeyedMap(result.data)!);
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToAuthException(error);
    } catch (error) {
      print('error: $error');
      throw UserException(UserExceptionCode.Unknown, message: error.toString());
    }
  }

  static Future<UserProfile> updateProfile(
      String? userId, UserProfileUpdate profile, AppConfig config) async {
    try {
      final data = profile.toMap();
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('updateProfile');
      final result = await callable.call(data);
      if (profile.image != null) {
        await uploadImage(userId, profile.image!, config);
        print("IMAGE SUCCESSFULLY UPLOADED");
      }
      return UserProfile.fromMap(asStringKeyedMap(result.data)!);
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToAuthException(error);
    } catch (error) {
      print('error: $error');
      throw UserException(UserExceptionCode.Unknown, message: error.toString());
    }
  }

  static Future<bool?> usernameExist(String username, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('usernameExists');
      final result = await callable.call({'username': username});
      return result.data['exists'];
    } catch (error) {
      print('error: $error');
      return null;
    }
  }

  static Future<bool?> emailExist(String email, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('emailExists');
      final result = await callable.call({'email': email});
      return result.data['exists'] as bool?;
    } catch (error) {
      return null;
      //throw UserException(UserExceptionCode.Unknown, message: error.toString());
    }
  }

  static Future<TaskSnapshot> uploadImage(
      String? userId, XFile image, AppConfig config) async {
    final imageId = generateUniqueId();
    final documentPath = "profiles/$userId/photos/$imageId";
    final storage = FirebaseStorage.instance
        .refFromURL("gs://${config.photoStorageBucket}");
    final filename = 'profiles/$userId/$imageId';
    final Reference imageRef = storage.child(filename);
    final bytes = await image.readAsBytes();
    final imageUploadTask = imageRef.putData(
      bytes,
      SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: config.storageCacheControl,
        customMetadata: {
          "documentPath": documentPath,
          "imageField": "image",
          "updateField": "imageUrl",
          "enabledField": "enabled",
        },
      ),
    );
    return imageUploadTask;
  }

  static UserException mapToAuthException(Exception exception) {
    if (exception is FirebaseFunctionsException) {
      if (exception.details != null) {
        return UserException.fromMap(asStringKeyedMap(exception.details)!);
      }
      return UserException(UserExceptionCode.Unknown);
    } else {
      return UserException(UserExceptionCode.Unknown);
    }
  }
}

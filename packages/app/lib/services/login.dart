import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:goramp/generated/l10n.dart';
import 'package:goramp/utils/index.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:goramp/services/index.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/index.dart';
import '../app_config.dart';

const String loginPath = '/users/verifyToken';

class LinkAuthCredential extends Equatable {
  final String? email;
  final String? provider;
  final fb.AuthCredential? credential;
  LinkAuthCredential({this.provider, this.credential, this.email});

  List get props => [provider, credential, email];

  @override
  String toString() => 'LinkAuthCredential';

  factory LinkAuthCredential.fromMap(Map<String, dynamic> map) {
    final prefferedProvider = map['provider'];
    final providerId = map['credential']['providerId'];
    fb.AuthCredential authCredential;
    final credentialMap = map['credential'];
    if (providerId == fb.EmailAuthProvider.PROVIDER_ID) {
      if (credentialMap['emailLink'] != null) {
        authCredential = fb.EmailAuthProvider.credentialWithLink(
            email: credentialMap['email'],
            emailLink: credentialMap['emailLink']);
      }
      authCredential = fb.EmailAuthProvider.credential(
          email: credentialMap['email'], password: credentialMap['password']);
    } else if (providerId == fb.GoogleAuthProvider.PROVIDER_ID) {
      authCredential = fb.GoogleAuthProvider.credential(
          idToken: credentialMap['idToken'],
          accessToken: credentialMap['accessToken']);
    } else if (providerId == fb.TwitterAuthProvider.PROVIDER_ID) {
      authCredential = fb.TwitterAuthProvider.credential(
          secret: credentialMap['secret'],
          accessToken: credentialMap['accessToken']);
    } else {
      authCredential = fb.OAuthProvider(providerId).credential(
          rawNonce: credentialMap['rawNonce'],
          idToken: credentialMap['idToken'],
          accessToken: credentialMap['accessToken']);
    }
    return LinkAuthCredential(
      email: map['email'],
      provider: prefferedProvider,
      credential: authCredential,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'provider': provider,
      'credential': credential!.asMap(),
    };
  }
}

enum AuthExceptionCode {
  ExpiredActionCode,
  InvalidActionCode,
  UserDisabled,
  UserNotFound,
  Unknown,
  WeakPassword,
  WrongPassword,
  InvalidEmail,
  AccountExistWithDifferentCredentials,
  NetworkError,
  ClosedByUser,
  TokenExpired,
}

class AuthException implements Exception {
  final AuthExceptionCode code;
  final String? message;
  final String? email;
  final fb.AuthCredential? credential;
  AuthException(this.code, {this.message, this.email, this.credential});
}

class LoginException implements Exception {
  final String? message;
  final String? code;
  LoginException({this.code, this.message});
}

class UserNotFoundException implements Exception {
  final int? status;
  final String? errorMessage;
  UserNotFoundException({this.status, this.errorMessage});
}

enum SignUpExceptionCode {
  UserNotFound,
  PhoneAlreadyExists,
  EmailExists,
  UsernameExists,
  FirstNameRequired,
  LastNameRequired,
  UsernameRequired,
  UsernameMinLen,
  UsernameMaxLen,
  UsernameInvalidFormat,
  UsernameInvalidEndFormat,
  TransactionFailure,
  OrderExpired,
  OrderInProgress,
  DuplicateOrder,
  EmailFormatInvalid,
  EmailRequired,
  WrongPassword,
  PasswordFormatInvalid,
  PasswordRequired,
  NameInvalid,
  CodeRequired,
  CodeFormatInvalid,
  CodeExpired,
  CodeNotFound,
  EmailImmutable,
  Unknown, //unknown
}

class SignUpException implements Exception {
  final SignUpExceptionCode code;
  final String? message;
  SignUpException(this.code, {this.message = StringResources.UNKNOWN_ERROR});

  factory SignUpException.fromMap(Map<String, dynamic> map) {
    final code = mapToSignUpException(map['code']);
    return SignUpException(
      code,
      message: mapCodeToMessage(code, defaultMessage: map['errorMessage']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'errorMessage': message,
    };
  }

  static String mapCodeToMessage(SignUpExceptionCode code,
      {String? defaultMessage, BuildContext? context}) {
    final s = context != null ? S.of(context) : S.current;
    switch (code) {
      case SignUpExceptionCode.UserNotFound:
        return s.user_not_found;
      case SignUpExceptionCode.PhoneAlreadyExists:
        return s.phone_number_exists;
      case SignUpExceptionCode.EmailExists:
        return s.email_already_exists;
      case SignUpExceptionCode.UsernameExists:
        return s.username_already_exists;
      case SignUpExceptionCode.FirstNameRequired:
        return s.first_name_required;
      case SignUpExceptionCode.LastNameRequired:
        return s.last_name_required;
      case SignUpExceptionCode.UsernameRequired:
        return s.username_required;
      case SignUpExceptionCode.UsernameMinLen:
        return s.min_username_chars;
      case SignUpExceptionCode.UsernameMaxLen:
        return s.username_lt_max_chars;
      case SignUpExceptionCode.UsernameExists:
        return s.usernmae_already_exists;
      case SignUpExceptionCode.UsernameInvalidFormat:
        return s.username_must_include_latin_chars;
      case SignUpExceptionCode.UsernameInvalidEndFormat:
        return s.username_must_end_in_letter_or_num;
      case SignUpExceptionCode.EmailFormatInvalid:
        return s.email_invalid;
      case SignUpExceptionCode.EmailRequired:
        return s.email_required;
      case SignUpExceptionCode.EmailImmutable:
        return s.email_immutable;
      case SignUpExceptionCode.PasswordRequired:
        return s.password_required;
      case SignUpExceptionCode.WrongPassword:
        return s.wrong_password;
      case SignUpExceptionCode.PasswordFormatInvalid:
        return s.password_invalid;
      case SignUpExceptionCode.NameInvalid:
        return s.name_invalid;
      case SignUpExceptionCode.CodeRequired:
        return s.code_required;
      case SignUpExceptionCode.CodeFormatInvalid:
        return s.code_is_number;
      case SignUpExceptionCode.CodeExpired:
        return s.code_expired;
      case SignUpExceptionCode.CodeNotFound:
        return s.code_not_found;
      default:
        return defaultMessage ?? s.something_went_wrong;
    }
  }

  static SignUpExceptionCode mapToSignUpException(String? code) {
    switch (code) {
      case 'user/not_found':
        return SignUpExceptionCode.UserNotFound;
      case 'user/phonenumber_exists':
        return SignUpExceptionCode.PhoneAlreadyExists;
      case 'user/email_exists':
        return SignUpExceptionCode.EmailExists;
      case 'user/username_exists':
        return SignUpExceptionCode.UsernameExists;
      case 'user/username_min_len':
        return SignUpExceptionCode.UsernameMinLen;
      case 'user/username_max_len':
        return SignUpExceptionCode.UsernameMaxLen;
      case 'user/username_end_format_invalid':
        return SignUpExceptionCode.UsernameInvalidEndFormat;
      case 'user/username_format_invalid':
        return SignUpExceptionCode.UsernameInvalidFormat;
      case 'user/first_name_required':
        return SignUpExceptionCode.FirstNameRequired;
      case 'user/last_name_required':
        return SignUpExceptionCode.LastNameRequired;
      case 'user/username_required':
        return SignUpExceptionCode.UsernameRequired;
      case 'user/email_format_invalid':
        return SignUpExceptionCode.EmailFormatInvalid;
      case 'user/email_required':
        return SignUpExceptionCode.EmailRequired;
      case 'user/email_immutable':
        return SignUpExceptionCode.EmailImmutable;
      case 'user/password_required':
        return SignUpExceptionCode.PasswordRequired;
      case 'user/wrong_password':
        return SignUpExceptionCode.WrongPassword;
      case 'user/password_format_invalid':
        return SignUpExceptionCode.PasswordFormatInvalid;
      case 'user/name_invalid':
        return SignUpExceptionCode.NameInvalid;
      case 'user/code_required':
        return SignUpExceptionCode.CodeRequired;
      case 'user/code_format_invalid':
        return SignUpExceptionCode.CodeFormatInvalid;
      case 'user/code_expired':
        return SignUpExceptionCode.CodeExpired;
      case 'user/code_not_found':
        return SignUpExceptionCode.CodeNotFound;
      default:
        return SignUpExceptionCode.Unknown;
    }
  }

  String toString() {
    return '${toMap()}';
  }
}

class DuplicateAccountException implements Exception {
  final int? status;
  final String? errorMessage;
  DuplicateAccountException({this.status, this.errorMessage});
}

class UnknownException implements Exception {
  final String? message;
  UnknownException({this.message});
}

class LoginService {
  final AppConfig config;
  bool configured = false;

  LoginService({required this.config});

  String? get baseUrl => config.baseApiUrl;

  static Future<User?> login(String email, String password) async {
    try {
      final credential = await fb.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return User.fromFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      print("error : $e");
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static SignUpException mapToSignUpException(Exception exception) {
    if (exception is FirebaseFunctionsException) {
      if (exception.details != null) {
        return SignUpException.fromMap(asStringKeyedMap(exception.details)!);
      }
      return SignUpException(SignUpExceptionCode.Unknown);
    } else {
      return SignUpException(SignUpExceptionCode.Unknown);
    }
  }

  static Future<void> updateLogin(AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('updateUserLogin');
      await callable.call();
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToAuthException(error);
    } catch (error) {
      print('error: $error');
      throw UserException(UserExceptionCode.Unknown, message: error.toString());
    }
  }

  static Future<User> loginAnonymous() async {
    final credentials = await fb.FirebaseAuth.instance.signInAnonymously();
    return User(id: credentials.user!.uid, isAnonymous: true);
  }

  static Future<void> saveUser(User user, {String? appGroupId}) async {
    final userS = json.encode(user.toMap());
    await StorageService.write(
        key: 'user', value: userS, iosAppGroupId: appGroupId);
  }

  static Future<User?> getCurrentUser({String? appGroupId}) async {
    fb.User? fbUser = fb.FirebaseAuth.instance.currentUser;
    if (fbUser != null) {
      if (fbUser.isAnonymous) {
        return User(id: fbUser.uid, isAnonymous: true);
      }
      String? userS =
          await StorageService.read(key: 'user', iosAppGroupId: appGroupId);
      if (userS != null) {
        User user = User.fromMap(json.decode(userS));
        if (fbUser.uid == user.id) {
          return user;
        }
      }
    }
    return null;
  }

  static Future<void> unregisterMessagingToken() async {
    try {
      String? messageToken = await FirebaseMessaging.instance.getToken();
      if (messageToken != null) {
        await UserService.unRegisterMessagingToken(messageToken);
      }
    } catch (error) {}
  }

  static Future<void> unregisterVOIPToken() async {
    try {
      if (UniversalPlatform.isIOS) {
        //String pushToken = await _voipPush.getToken();
        // await UserService.unRegisterVoipToken(pushToken);
      }
    } catch (error) {}
  }

  static Future<void> logout() async {
    try {
      //final FlutterVoipPushNotification _voipPush = FlutterVoipPushNotification();
      print("Start logout");
      await unregisterMessagingToken();
      await unregisterVOIPToken();
      //final uid = fb.FirebaseAuth.instance.currentUser?.uid;
      print("start delete all");
      StorageService.deleteAll();
      fb.FirebaseAuth.instance.signOut();
      print("End logout");
    } catch (error, stack) {
      print("logout-error: $error");
      print("logout-stack: $stack");
    }
  }

  Future<void> doFirebaseLogin(String token) async {
    final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
    await _auth.signInWithCustomToken(token);
  }

  static Future<fb.OAuthCredential> createAppleOAuthCred(
      AppConfig config) async {
    final nonce = createNonce(32);
    final clientId = "${config.iosBundleId}.svc";
    final nativeAppleCred = UniversalPlatform.isIOS
        ? await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: sha256.convert(utf8.encode(nonce)).toString(),
          )
        : await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              redirectUri: Uri.parse(config.firebaseAuthRedirectCallbackUrl!),
              clientId: clientId,
            ),
            nonce: sha256.convert(utf8.encode(nonce)).toString(),
          );
    return new fb.OAuthCredential(
      providerId: "apple.com", // MUST be "apple.com"
      signInMethod: "oauth", // MUST be "oauth"
      accessToken: nativeAppleCred
          .identityToken, // propagate Apple ID token to BOTH accessToken and idToken parameters
      idToken: nativeAppleCred.identityToken,
      rawNonce: nonce,
    );
  }

  static Future<String> verifyEmailCode(String actionCode) async {
    try {
      final email =
          await fb.FirebaseAuth.instance.verifyPasswordResetCode(actionCode);
      return email;
    } on fb.FirebaseAuthException catch (e) {
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<String> verifyPasswordResetCode(String actionCode) async {
    try {
      final email =
          await fb.FirebaseAuth.instance.verifyPasswordResetCode(actionCode);
      return email;
    } on fb.FirebaseAuthException catch (e) {
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<User> signInWithEmailLink(String email, String link) async {
    try {
      final credential = await fb.FirebaseAuth.instance
          .signInWithEmailLink(email: email, emailLink: link);
      return User.fromFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      print("error : $e");
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<UserWithProfile> register(String username, String firstName,
      String lastName, AppConfig config) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: config.region)
            .httpsCallable('register');
    final result = await callable.call(
        {"username": username, "firstName": firstName, "lastName": lastName});
    await fb.FirebaseAuth.instance.currentUser?.reload();
    final user = User.fromFirebaseUser(fb.FirebaseAuth.instance.currentUser!);
    final profile = UserProfile.fromMap(asStringKeyedMap(result.data)!);
    return UserWithProfile(profile: profile, user: user);
  }

  static Future<User> signUp(
    String email,
    String password,
    String code,
    AppConfig config,
  ) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('signUp');
      final result = await callable
          .call({'email': email, 'code': code, 'password': password});
      final profile = UserProfile.fromMap(asStringKeyedMap(result.data)!);
      await saveProfile(profile);
      final userCred = await fb.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return User.fromFirebaseUser(userCred.user!);
    } on FirebaseFunctionsException catch (error) {
      print('error: $error');
      throw mapToSignUpException(error);
    } catch (error) {
      print('ERROR: $error');
      throw SignUpException(
        SignUpExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }

  static Future<void> forgotPassword(String email, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('forgotPassword');
      await callable.call({
        "email": email,
      });
    } on FirebaseFunctionsException catch (error) {
      throw mapToSignUpException(error);
    } catch (error) {
      print('ERROR: $error');
      throw SignUpException(
        SignUpExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }

  static Future<void> recoverPassword(String code, String password) async {
    try {
      await fb.FirebaseAuth.instance
          .confirmPasswordReset(code: code, newPassword: password);
    } on fb.FirebaseAuthException catch (e) {
      print("error : $e");
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<void> saveProfile(UserProfile profile) async {
    await StorageService.write(
        key: 'profile-${profile.uid}', value: jsonEncode(profile.toMap()));
  }

  static void removeProfile(String uid) async {
    await StorageService.delete(key: 'profile-$uid');
  }

  static Future<UserProfile?> readProfile(String? uid) async {
    final String? data = await StorageService.read(key: 'profile-$uid');
    if (data != null) {
      final map = jsonDecode(data);
      if (map != null) {
        return UserProfile.fromMap(asStringKeyedMap(map)!);
      }
    }
    return null;
  }

  static Future<String?> confirmPasswordResetCode(
      String actionCode, String password) {
    try {
      return fb.FirebaseAuth.instance
          .confirmPasswordReset(code: actionCode, newPassword: password)
          .then((value) => value as String?);
    } on fb.FirebaseAuthException catch (error) {
      throw mapToAuthException(error);
    }
  }

  static Future<User?> signInWithApple(AppConfig config,
      {bool useRedirect = false}) async {
    try {
      if (UniversalPlatform.isWeb) {
        final provider = fb.OAuthProvider("apple.com");
        provider.addScope("email");
        provider.addScope("name");
        provider.setCustomParameters({"locale": "en"});
        if (useRedirect) {
          await fb.FirebaseAuth.instance.signInWithRedirect(provider);
          return null;
        }
        final fb.UserCredential credential =
            await fb.FirebaseAuth.instance.signInWithPopup(provider);
        return User.fromFirebaseUser(credential.user!);
      } else {
        final user = await FirebaseAuthOAuth()
            .openSignInFlow("apple.com", ["email", "name"], {"locale": "en"});
        if (user == null) {
          return null;
        }
        return User.fromFirebaseUser(user);
      }
    } on fb.FirebaseAuthException catch (e) {
      print("error : $e");
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<User> linkWithCredentials(fb.AuthCredential credential) async {
    try {
      final userCredential = await fb.FirebaseAuth.instance.currentUser!
          .linkWithCredential(credential);
      return User.fromFirebaseUser(userCredential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<User?> signInWithGoogle({bool useRedirect = false}) async {
    if (UniversalPlatform.isWeb) {
      return signInWithGoogleWeb(useRedirect: useRedirect);
    }
    return signInWithGoogleNative();
  }

  static Future<User?> signInWithTwitter(AppConfig config,
      {bool useRedirect = false}) async {
    try {
      if (UniversalPlatform.isWeb) {
        fb.TwitterAuthProvider twitterProvider = fb.TwitterAuthProvider();
        if (useRedirect) {
          await fb.FirebaseAuth.instance.signInWithRedirect(twitterProvider);
          return null;
        } else {
          final fb.UserCredential credential =
              await fb.FirebaseAuth.instance.signInWithPopup(twitterProvider);
          return User.fromFirebaseUser(credential.user!);
        }
      }
      final user = await signInWithTwitterNative(config);
      return user;
    } on fb.FirebaseAuthException catch (e) {
      throw mapToAuthException(e);
    } catch (error) {
      throw mapToAuthException(error);
    }
  }

  static Future<String> preferredProvider(String email) async {
    try {
      List<String> userSignInMethods =
          await fb.FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return userSignInMethods.first;
    } on fb.FirebaseAuthException catch (e) {
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<User?> signInWithFacebook(AppConfig config,
      {bool useRedirect = false}) async {
    try {
      if (UniversalPlatform.isWeb) {
        fb.FacebookAuthProvider facebookProvider = fb.FacebookAuthProvider();
        if (useRedirect) {
          await fb.FirebaseAuth.instance.signInWithRedirect(facebookProvider);
          return null;
        } else {
          final fb.UserCredential credential =
              await fb.FirebaseAuth.instance.signInWithPopup(facebookProvider);
          return User.fromFirebaseUser(credential.user!);
        }
      }
      final user = await signInWithFacebookNative(config);
      return user;
    } on fb.FirebaseAuthException catch (e) {
      print("error : $e");
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<User?> signInWithFacebookNative(AppConfig config) async {
    // Trigger the sign-in flow
    final loginResult = await FacebookAuth.instance.login();

    if (loginResult.accessToken == null) {
      return null;
    }
    // Create a credential from the access token
    final facebookAuthCredential =
        fb.FacebookAuthProvider.credential(loginResult.accessToken!.token);
    var currentUser = fb.FirebaseAuth.instance.currentUser;
    var userCredential;
    if (currentUser != null && currentUser.isAnonymous) {
      userCredential =
          await currentUser.linkWithCredential(facebookAuthCredential);
      return User.fromFirebaseUser(currentUser);
    }
    // Once signed in, return the UserCredential
    userCredential = await fb.FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    return User.fromFirebaseUser(userCredential.user);
  }

  static Future<User?> signInWithTwitterNative(AppConfig config) async {
    // Trigger the authentication flow
    final twitterLogin = TwitterLogin(
      // Consumer API keys
      apiKey: config.twitterApiKey!,
      apiSecretKey: config.twitterApiSecret!,
      // Callback URL for Twitter App
      // Android is a deeplink
      // iOS is a URLScheme
      redirectURI: "twittersdk://",
    );
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        // Obtain the auth details from the request
        final fb.AuthCredential twitterAuthCredential =
            fb.TwitterAuthProvider.credential(
                accessToken: authResult.authToken!,
                secret: authResult.authTokenSecret!);
        var currentUser = fb.FirebaseAuth.instance.currentUser;
        var userCredential;
        if (currentUser != null && currentUser.isAnonymous) {
          userCredential =
              await currentUser.linkWithCredential(twitterAuthCredential);
          return User.fromFirebaseUser(currentUser);
        }
        // Once signed in, return the UserCredential
        userCredential = await fb.FirebaseAuth.instance
            .signInWithCredential(twitterAuthCredential);
        return User.fromFirebaseUser(userCredential.user);
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        break;
      case TwitterLoginStatus.error:
        // error
        break;
      default:
        return null;
    }
    return null;
  }

  static Future<User?> signInWithGoogleNative() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ["email", "profile"]).signIn();
      if (googleUser == null) {
        return null;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final fb.GoogleAuthCredential credential =
          fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ) as fb.GoogleAuthCredential;

      // Once signed in, return the UserCredential
      final userCredential =
          await fb.FirebaseAuth.instance.signInWithCredential(credential);
      return User.fromFirebaseUser(userCredential.user!);
    } on fb.FirebaseAuthException catch (e) {
      print("error : $e");
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<User?> signInWithGoogleWeb({bool useRedirect = false}) async {
    try {
      fb.GoogleAuthProvider googleProvider = fb.GoogleAuthProvider();
      googleProvider.addScope('email').addScope('profile');
      if (useRedirect) {
        await fb.FirebaseAuth.instance.signInWithRedirect(googleProvider);
        return null;
      } else {
        final fb.UserCredential credential =
            await fb.FirebaseAuth.instance.signInWithPopup(googleProvider);
        return User.fromFirebaseUser(credential.user!);
      }
    } on fb.FirebaseAuthException catch (e) {
      print("error : $e");
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<User?> getRedirectResult() async {
    try {
      final fb.UserCredential credential =
          await fb.FirebaseAuth.instance.getRedirectResult();
      if (credential.user != null) {
        return User.fromFirebaseUser(credential.user!);
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      print("error : $e");
      throw mapToAuthException(e);
    } catch (error) {
      print("error a: $error");
      throw mapToAuthException(error);
    }
  }

  static Future<void> applyActionCode(
    String actionCode,
  ) {
    try {
      return fb.FirebaseAuth.instance.applyActionCode(actionCode);
    } on fb.FirebaseAuthException catch (error) {
      throw mapToAuthException(error);
    }
  }

  static Future<void> sendVerificationEmail(String email) {
    return fb.FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  static Future<void> sendEmailLink(String email, AppConfig config,
      {String? continueUrl}) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: config.region)
            .httpsCallable('sendEmailLink');
    await callable.call({"email": email, "continueUrl": continueUrl});
  }

  static Future<void> updateEmail(String email, AppConfig config,
      {String? continueUrl}) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: config.region)
            .httpsCallable('updateEmail');
    await callable.call({"email": email, "continueUrl": continueUrl});
  }

  static Future<User?> updateEmailOTP(
      String email, String code, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('updateEmailOTP');
      final result = await callable.call({"email": email, "code": code});
      return User.fromFirebaseMap(asStringKeyedMap(result.data)!);
    } on FirebaseFunctionsException catch (e) {
      throw mapToSignUpException(e);
    } catch (error) {
      throw SignUpException(
        SignUpExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }

  static Future<void> sendEmailOTP(String email, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('sendEmailOTP');
      await callable.call({"email": email});
    } on FirebaseFunctionsException catch (e) {
      throw mapToSignUpException(e);
    } catch (error) {
      throw SignUpException(
        SignUpExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }

  static Future<void> sendSignUpEmailOTP(String email, AppConfig config) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: config.region)
              .httpsCallable('sendSignUpEmailOTP');
      await callable.call({"email": email});
    } on FirebaseFunctionsException catch (e) {
      throw mapToSignUpException(e);
    } catch (error) {
      throw SignUpException(
        SignUpExceptionCode.Unknown,
        message: error.toString(),
      );
    }
  }

  static Future<void> resendEmailVerification(AppConfig config,
      {String? continueUrl}) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: config.region)
            .httpsCallable('resendEmailVerification');
    await callable.call({"continueUrl": continueUrl});
  }

  // static Future<void> solCreateAccount(
  //   String email,
  // ) {
  //   return fb.FirebaseAuth.instance
  //       .sendSignInLinkToEmail(email: null, actionCodeSettings: null);
  // }

  static AuthException mapToAuthException(Object authException) {
    if (authException is fb.FirebaseAuthException) {
      switch (authException.code) {
        case "account-exists-with-different-credential":
          return AuthException(
              AuthExceptionCode.AccountExistWithDifferentCredentials,
              //message: s.an_account_already_exists,
              email: authException.email,
              credential: authException.credential);
        case "invalid-email":
          return AuthException(
            AuthExceptionCode.InvalidEmail,
          );
        case "expired-action-code":
          return AuthException(
            AuthExceptionCode.ExpiredActionCode,
            //message: s.verification_code_expired
          );
        case "invalid-action-code":
          return AuthException(
            AuthExceptionCode.InvalidActionCode,
            //message: s.invalid_verification_code
          );
        case "user-disabled":
          return AuthException(
            AuthExceptionCode.UserDisabled,
            //message: s.account_disabled
          );
        case "user-not-found":
          return AuthException(
            AuthExceptionCode.UserNotFound,
            //message: s.user_not_found
          );
        case "weak-password":
          return AuthException(
            AuthExceptionCode.WeakPassword,
            // message: s.weak_password
          );
        case "network-request-failed":
          return AuthException(
            AuthExceptionCode.NetworkError,
            //message: s.please_check_your_connection
          );
        case "popup-closed-by-user":
          return AuthException(
            AuthExceptionCode.ClosedByUser,
            //message: authException.message
          );
        case "wrong-password":
          return AuthException(
            AuthExceptionCode.WrongPassword,
            //message: authException.message
          );
        case "user-token-expired":
          return AuthException(
            AuthExceptionCode.TokenExpired,
            //message: authException.message
          );
        default:
          return AuthException(
            AuthExceptionCode.Unknown,
            //message: s.unknown_error
          );
      }
    } else {
      return AuthException(AuthExceptionCode.Unknown);
    }
  }

  static String createNonce(int length) {
    final random = Random();
    final charCodes = List<int?>.generate(length, (_) {
      int? codeUnit;

      switch (random.nextInt(3)) {
        case 0:
          codeUnit = random.nextInt(10) + 48;
          break;
        case 1:
          codeUnit = random.nextInt(26) + 65;
          break;
        case 2:
          codeUnit = random.nextInt(26) + 97;
          break;
      }

      return codeUnit;
    });

    return String.fromCharCodes(charCodes as Iterable<int>);
  }

  static Future<void> savePendingAuthCredential(
      LinkAuthCredential credential) async {
    await StorageService.write(
        key: 'pending-auth', value: jsonEncode(credential.toMap()));
  }

  static Future<LinkAuthCredential?> readPendingAuthCredential() async {
    final String? data = await StorageService.read(key: 'pending-auth');
    if (data != null) {
      final map = jsonDecode(data);
      if (map != null) {
        return LinkAuthCredential.fromMap(asStringKeyedMap(map)!);
      }
    }
    return null;
  }

  static Future<void> deletePendingAuthCredential() async {
    await StorageService.delete(key: 'pending-auth');
  }
}

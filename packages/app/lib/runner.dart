import 'dart:async';

import 'package:browser_adapter/browser_adapter.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: require_trailing_commas
//import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goramp/bloc/index.dart';
import 'package:goramp/models/index.dart' as models;
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/data/gotok_options.dart';
import 'package:goramp/widgets/utils/index.dart';
import 'package:passbase_flutter/passbase_flutter.dart';

import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:timezone_name/timezone_name.dart';
import 'package:torus_firebase_jwt/torus_firebase_jwt.dart';
import 'package:universal_platform/universal_platform.dart';
import 'app_config.dart';
import 'app.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

Future<dynamic> getRedirectResult() async {
  try {
    return await LoginService.getRedirectResult();
  } on AuthException catch (error) {
    if (error.code == AuthExceptionCode.AccountExistWithDifferentCredentials) {
      final preferredProvider =
          await LoginService.preferredProvider(error.email!);
      final pendingAuth = LinkAuthCredential(
          provider: preferredProvider,
          credential: error.credential,
          email: error.email);
      await LoginService.savePendingAuthCredential(pendingAuth);
      return pendingAuth;
    } else {
      return null;
    }
  } catch (error) {
    print("ERROR code ${error}");
    return null;
  }
}

Future<void> run(AppConfig config) async {
  configureApp();
  Provider.debugCheckInvalidValueType = null;
  // GestureBinding.instance?.resamplingEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (config.firebaseEmulatorOrigin != null) {
    FirebaseFunctions.instanceFor(region: config.region)
        .useFunctionsEmulator('localhost', 5001);
  }
  // if (!UniversalPlatform.isWeb) {
  //   await FirebaseAppCheck.instance
  //       .activate(webRecaptchaSiteKey: config.recaptcha);
  // }
  initializeViewPort();
  tz.initializeTimeZones();
  String currentTimeZone = await TimezoneName.name;
  final currentTimeZoneLocation = timeZoneDatabase.get(currentTimeZone);
  List<Location> allTimeZones = timeZoneDatabase.locations.values.toList();
  allTimeZones.sort((a, b) => a.name.compareTo(b.name));
  final torusDirectSdk = directSDK();
  await torusDirectSdk.init(DirectSDKOptions(
      network:
          config.torusNetwork == 'mainnet' ? Network.mainnet : Network.testnet,
      verifier: config.torusVerifier,
      enableLogging: false));
  if (kReleaseMode)
    await SentryFlutter.init(
      (options) {
        options.dsn = config.sentryDSN;
        options.environment = AppConfig.flavorToString(config.flavor);
        options.release = config.sentryReleaseName;
        options.beforeSend = (event, {hint}) {
          if (hint == null || !(hint is String)) {
            return event;
          }

          return event.copyWith(message: SentryMessage(hint));
        };
      },
    );
  if (!UniversalPlatform.isWeb) {
    PassbaseSDK.initialize(publishableApiKey: config.passbaseApiKey!);
  }
  final currentUser = await FirebaseAuth.instance.authStateChanges().first;

  config = config.copyWith(
      timeZone: currentTimeZoneLocation, timeZones: allTimeZones);
  models.User? user;
  models.UserProfile? profile;
  LinkAuthCredential? pendingAuthCredential;
  if (currentUser != null) {
    profile = await LoginService.readProfile(currentUser.uid);
    user = models.User.fromFirebaseUser(currentUser);
  } else if (UniversalPlatform.isWeb) {
    final result = await getRedirectResult();
    if (result is models.User) {
      user = result;
      profile = await LoginService.readProfile(user.id);
    } else if (result is LinkAuthCredential) {
      pendingAuthCredential = result;
    }
  }
  if (user == null) {
    final fbUser = (await FirebaseAuth.instance.signInAnonymously()).user;
    if (fbUser != null) {
      user = models.User.fromFirebaseUser(fbUser);
    }
  }
  final appModel = MyAppModel(config,
      user: user,
      profile: profile,
      pendingAuthCredential: pendingAuthCredential);
  final authenticationBloc = AuthenticationBloc(appModel);
  runZonedGuarded(
    () async {
      runApp(
        App(
          config: config.copyWith(
              timeZone: currentTimeZoneLocation, timeZones: allTimeZones),
          authenticationBloc: authenticationBloc,
          appModel: appModel,
          //årecordingService: recordingService,
          options: GotokOptions(
            themeMode: ThemeMode.system,
            textScaleFactor: systemTextScaleFactorOption,
            customTextDirection: CustomTextDirection.localeBased,
            locale: null,
            platform: defaultTargetPlatform,
            //isTestMode: isTestMode,
          ),
        ),
      );
    },
    (Object error, StackTrace stackTrace) {
      ErrorHandler.report(error, stackTrace);
    },
  );
}

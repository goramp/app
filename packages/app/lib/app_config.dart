import 'package:timezone/timezone.dart';
import 'package:universal_platform/universal_platform.dart';

enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class AppConfig {
  const AppConfig({
    this.firebaseApiKey,
    this.firebaseAppId,
    this.firebaseMessagingSenderId,
    this.firebaseProjectId,
    this.firebaseDatabaseURL,
    this.firebaseStorageBucket,
    this.firebaseMeasurementId,
    this.firebaseAndroidClientId,
    this.frebaseIosClientId,
    this.firebaseAuthDomain,
    this.appName,
    this.flavor,
    this.baseApiUrl,
    this.pusherApiKey,
    this.pusherCluster,
    this.dynamicLinkDomain,
    this.appShortLinkDomain,
    this.iceServersUrls,
    this.appPackageName,
    this.iosBundleId,
    this.scheme,
    this.host,
    this.useAppLink,
    this.sentryDSN,
    this.photoStorageBucket,
    this.tempStorageBucket,
    this.storageCacheControl,
    this.flutterWaveEncriptionKey,
    this.flutterWavePublicKey,
    this.transackAPIKey,
    // this.nswfParams,
    // this.nswfLiveVideoParams,
    this.agoliaAppId,
    this.modelFileRemoteConfig,
    this.modelClassFileRemoteConfig,
    this.wireDashProjectId,
    this.wireDashSecret,
    this.webDomain,
    this.twitterApiKey,
    this.twitterApiSecret,
    this.firebaseAuthRedirectCallbackUrl,
    this.defaultModelClassFileRemoteConfig,
    this.defaultModelFileRemoteConfig,
    this.iosAppGroupId,
    this.timeZone,
    this.timeZones,
    this.firebaseEmulatorOrigin,
    this.vapidKey,
    this.enableAppleLogin = false,
    this.isKuro = false,
    this.isBeta = false,
    this.termsUrl,
    this.privacyUrl,
    this.landingUrl,
    this.stripePublishKey,
    this.stripeElementFontUrl,
    this.stripeElementFontFamily,
    this.stripeElementFontWeight,
    this.region,
    this.applePayMerchantId,
    this.torusNetwork,
    this.torusVerifier,
    this.solanaRPCUrl,
    this.solanaWebsocketRPCUrl,
    this.solanaCluster,
    this.sentryReleaseName,
    this.roomConnectionUrl,
    this.roomApiUrl,
    this.passbaseApiKey,
    this.passbaseVerificationUrl,
    this.recaptcha,
    this.ftxPayBaseUrl,
    this.transackBaseUrl,
    this.torusUrl,
    this.kuroMarketUrl,
    this.kuroMarketName,
    this.rampBaseUrl,
    this.rampAPIKey,
    this.solanaExploreUrl,
    this.playstoreUrl,
    this.appStoreUrl,
    this.downloadUrl,
  });

  final String? region;
  final String? torusUrl;
  final String? torusNetwork;
  final String? solanaRPCUrl;
  final String? solanaWebsocketRPCUrl;
  final String? stripePublishKey;
  final String? landingUrl;
  final String? webDomain;
  final String? appName;
  final Flavor? flavor;
  final String? baseApiUrl;
  final String? pusherApiKey;
  final String? pusherCluster;
  final String? dynamicLinkDomain;
  final String? appShortLinkDomain;
  final String? iceServersUrls;
  final String? appPackageName;
  final String? iosBundleId;
  final String? scheme;
  final String? host;
  final String? sentryDSN;
  final String? photoStorageBucket;
  final String? tempStorageBucket;
  final String? iosAppGroupId;
  final String? storageCacheControl;
  final String? flutterWaveEncriptionKey;
  final String? flutterWavePublicKey;
  final Location? timeZone;
  final List<Location>? timeZones;
  final bool? useAppLink;
  final String? vapidKey;
  final bool isBeta;
  final String? termsUrl;
  final String? privacyUrl;
  final String? kuroMarketUrl;
  final String? kuroMarketName;
  // final NSFWParams nswfParams;
  // final NSFWParams nswfLiveVideoParams;
  final String? passbaseApiKey;
  final String? agoliaAppId;
  final String? modelFileRemoteConfig;
  final String? modelClassFileRemoteConfig;
  final String? defaultModelFileRemoteConfig;
  final String? defaultModelClassFileRemoteConfig;
  final String? wireDashProjectId;
  final String? wireDashSecret;
  final String? twitterApiKey;
  final String? twitterApiSecret;
  final String? firebaseAuthRedirectCallbackUrl;
  final String? firebaseEmulatorOrigin;
  final String? stripeElementFontUrl;
  final String? stripeElementFontFamily;
  final String? stripeElementFontWeight;
  final bool enableAppleLogin;
  final bool isKuro;
  final String? applePayMerchantId;
  final String? torusVerifier;
  bool get isDev => flavor == Flavor.DEVELOPMENT;
  String? get package => UniversalPlatform.isIOS ? iosBundleId : appPackageName;
  final String? firebaseApiKey;
  final String? firebaseAppId;
  final String? firebaseMessagingSenderId;
  final String? firebaseAuthDomain;
  final String? firebaseProjectId;
  final String? firebaseDatabaseURL;
  final String? firebaseStorageBucket;
  final String? firebaseMeasurementId;
  final String? firebaseAndroidClientId;
  final String? frebaseIosClientId;
  final String? transackAPIKey;
  final String? solanaCluster;
  final String? sentryReleaseName;
  final String? roomConnectionUrl;
  final String? roomApiUrl;
  final String? passbaseVerificationUrl;
  final String? recaptcha;
  final String? ftxPayBaseUrl;
  final String? transackBaseUrl;
  final String? rampBaseUrl;
  final String? rampAPIKey;
  final String? solanaExploreUrl;
  final String? playstoreUrl;
  final String? appStoreUrl;
  final String? downloadUrl;

  AppConfig copyWith({
    bool? firebaseApiKey,
    String? firebaseAppId,
    String? firebaseMessagingSenderId,
    String? firebaseProjectId,
    String? firebaseDatabaseURL,
    String? firebaseStorageBucket,
    String? firebaseMeasurementId,
    String? firebaseAndroidClientId,
    String? frebaseIosClientId,
    String? firebaseAuthDomain,
    Flavor? flavor,
    String? appName,
    String? baseApiUrl,
    String? pusherApiKey,
    String? pusherCluster,
    String? dynamicLinkDomain,
    String? appShortLinkDomain,
    String? iceServersUrls,
    String? appPackageName,
    String? iosBundleId,
    String? passbaseApiKey,
    String? scheme,
    String? host,
    String? sentryDSN,
    String? photoStorageBucket,
    String? tempStorageBucket,
    String? iosAppGroupId,
    String? storageCacheControl,
    String? flutterWaveEncriptionKey,
    String? flutterWavePublicKey,
    bool? useAppLink,
    Location? timeZone,
    bool? enableAppleLogin,
    bool? isBeta,
    // NSFWParams nswfParams,
    // NSFWParams nswfLiveVideoParams,
    String? agoliaAppId,
    String? modelFileRemoteConfig,
    String? modelClassFileRemoteConfig,
    String? defaultModelFileRemoteConfig,
    String? defaultModelClassFileRemoteConfig,
    List<Location>? timeZones,
    String? webDomain,
    String? twitterApiKey,
    String? twitterApiSecret,
    String? firebaseAuthRedirectCallbackUrl,
    String? firebaseEmulatorOrigin,
    String? vapidKey,
    bool? isKuro,
    String? termsUrl,
    String? privacyUrl,
    String? landingUrl,
    String? stripePublishKey,
    String? stripeElementFontUrl,
    String? stripeElementFontFamily,
    String? stripeElementFontWeight,
    String? region,
    String? applePayMerchantId,
    String? torusNetwork,
    String? torusVerifier,
    String? solanaRPCUrl,
    String? solanaWebsocketRPCUrl,
    String? transackAPIKey,
    String? solanaCluster,
    String? sentryReleaseName,
    String? roomConnectionUrl,
    String? roomApiUrl,
    String? roomIceServers,
    String? roomIceServerCredential,
    String? roomIceServerUsername,
    String? passbaseVerificationUrl,
    String? recaptcha,
    String? ftxPayBaseUrl,
    String? transackBaseUrl,
    String? torusUrl,
    String? kuroMarketUrl,
    String? kuroMarketName,
    String? rampBaseUrl,
    String? rampAPIKey,
    String? solanaExploreUrl,
    String? playstoreUrl,
    String? downloadUrl,
    String? appStoreUrl,
  }) {
    return AppConfig(
      firebaseApiKey: firebaseApiKey as String? ?? this.firebaseApiKey,
      firebaseMessagingSenderId:
          firebaseMessagingSenderId ?? this.firebaseMessagingSenderId,
      firebaseAppId: firebaseAppId ?? this.firebaseAppId,
      firebaseProjectId: firebaseProjectId ?? this.firebaseProjectId,
      firebaseDatabaseURL: firebaseDatabaseURL ?? this.firebaseDatabaseURL,
      firebaseStorageBucket:
          firebaseStorageBucket ?? this.firebaseStorageBucket,
      firebaseMeasurementId:
          firebaseMeasurementId ?? this.firebaseMeasurementId,
      firebaseAndroidClientId:
          firebaseAndroidClientId ?? this.firebaseAndroidClientId,
      frebaseIosClientId: frebaseIosClientId ?? this.frebaseIosClientId,
      firebaseAuthDomain: firebaseAuthDomain ?? this.firebaseAuthDomain,
      flavor: flavor ?? this.flavor,
      appName: appName ?? this.appName,
      baseApiUrl: baseApiUrl ?? this.baseApiUrl,
      pusherApiKey: pusherApiKey ?? this.pusherApiKey,
      pusherCluster: pusherCluster ?? this.pusherCluster,
      dynamicLinkDomain: dynamicLinkDomain ?? this.dynamicLinkDomain,
      appShortLinkDomain: appShortLinkDomain ?? this.appShortLinkDomain,
      iceServersUrls: iceServersUrls ?? this.iceServersUrls,
      appPackageName: appPackageName ?? this.appPackageName,
      iosBundleId: iosBundleId ?? this.iosBundleId,
      scheme: scheme ?? this.scheme,
      host: host ?? this.host,
      sentryDSN: sentryDSN ?? this.sentryDSN,
      photoStorageBucket: photoStorageBucket ?? this.photoStorageBucket,
      tempStorageBucket: tempStorageBucket ?? this.tempStorageBucket,
      iosAppGroupId: iosAppGroupId ?? this.iosAppGroupId,
      storageCacheControl: storageCacheControl ?? this.storageCacheControl,
      flutterWaveEncriptionKey:
          flutterWaveEncriptionKey ?? this.flutterWaveEncriptionKey,
      flutterWavePublicKey: flutterWavePublicKey ?? this.flutterWavePublicKey,
      useAppLink: useAppLink ?? this.useAppLink,
      timeZone: timeZone ?? this.timeZone,
      // nswfParams: nswfParams ?? this.nswfParams,
      // nswfLiveVideoParams: nswfLiveVideoParams ?? this.nswfLiveVideoParams,
      agoliaAppId: agoliaAppId ?? this.agoliaAppId,
      modelFileRemoteConfig:
          modelFileRemoteConfig ?? this.modelFileRemoteConfig,
      modelClassFileRemoteConfig:
          modelClassFileRemoteConfig ?? this.modelClassFileRemoteConfig,
      defaultModelFileRemoteConfig:
          defaultModelFileRemoteConfig ?? this.defaultModelFileRemoteConfig,
      defaultModelClassFileRemoteConfig: defaultModelClassFileRemoteConfig ??
          this.defaultModelClassFileRemoteConfig,
      wireDashProjectId: wireDashProjectId ?? this.wireDashProjectId,
      wireDashSecret: wireDashSecret ?? this.wireDashSecret,
      timeZones: timeZones ?? this.timeZones,
      twitterApiKey: twitterApiKey ?? this.twitterApiKey,
      twitterApiSecret: twitterApiSecret ?? this.twitterApiSecret,
      firebaseAuthRedirectCallbackUrl: firebaseAuthRedirectCallbackUrl ??
          this.firebaseAuthRedirectCallbackUrl,
      firebaseEmulatorOrigin:
          firebaseEmulatorOrigin ?? this.firebaseEmulatorOrigin,
      vapidKey: vapidKey ?? this.vapidKey,
      enableAppleLogin: enableAppleLogin ?? this.enableAppleLogin,
      isKuro: isKuro ?? this.isKuro,
      isBeta: isBeta ?? this.isBeta,
      privacyUrl: privacyUrl ?? this.privacyUrl,
      termsUrl: termsUrl ?? this.termsUrl,
      landingUrl: landingUrl ?? this.landingUrl,
      stripePublishKey: stripePublishKey ?? this.stripePublishKey,
      stripeElementFontUrl: stripeElementFontUrl ?? this.stripeElementFontUrl,
      stripeElementFontFamily:
          stripeElementFontFamily ?? this.stripeElementFontFamily,
      stripeElementFontWeight:
          stripeElementFontWeight ?? this.stripeElementFontWeight,
      region: region ?? this.region,
      applePayMerchantId: applePayMerchantId ?? this.applePayMerchantId,
      torusNetwork: torusNetwork ?? this.torusNetwork,
      torusVerifier: torusVerifier ?? this.torusVerifier,
      solanaRPCUrl: solanaRPCUrl ?? this.solanaRPCUrl,
      solanaWebsocketRPCUrl:
          solanaWebsocketRPCUrl ?? this.solanaWebsocketRPCUrl,
      transackAPIKey: transackAPIKey ?? this.transackAPIKey,
      solanaCluster: solanaCluster ?? this.solanaCluster,
      webDomain: webDomain ?? this.webDomain,
      sentryReleaseName: sentryReleaseName ?? this.sentryReleaseName,
      roomConnectionUrl: roomConnectionUrl ?? this.roomConnectionUrl,
      roomApiUrl: roomApiUrl ?? this.roomApiUrl,
      passbaseApiKey: passbaseApiKey ?? this.passbaseApiKey,
      passbaseVerificationUrl:
          passbaseVerificationUrl ?? this.passbaseVerificationUrl,
      recaptcha: recaptcha ?? this.recaptcha,
      ftxPayBaseUrl: ftxPayBaseUrl ?? this.ftxPayBaseUrl,
      transackBaseUrl: transackBaseUrl ?? this.transackBaseUrl,
      torusUrl: torusUrl ?? this.torusUrl,
      kuroMarketUrl: kuroMarketUrl ?? this.kuroMarketUrl,
      kuroMarketName: kuroMarketName ?? this.kuroMarketName,
      rampBaseUrl: rampBaseUrl ?? this.rampBaseUrl,
      rampAPIKey: rampAPIKey ?? this.rampAPIKey,
      solanaExploreUrl: solanaExploreUrl ?? this.solanaExploreUrl,
      playstoreUrl: playstoreUrl ?? this.playstoreUrl,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'flavor': flavor,
      'webDomain': webDomain,
      'baseApiUrl': baseApiUrl,
      'pusherApiKey': pusherApiKey,
      'pusherCluster': pusherCluster,
      'dynamicLinkDomain': dynamicLinkDomain,
      'appShortLinkDomain': appShortLinkDomain,
      'iceServersUrls': iceServersUrls,
      'appPackageName': appPackageName,
      'iosBundleId': iosBundleId,
      'scheme': scheme,
      'host': host,
      'sentryDSN': sentryDSN,
      'photoStorageBucket': photoStorageBucket,
      'tempStorageBucket': tempStorageBucket,
      'iosAppGroupId': iosAppGroupId,
      'storageCacheControl': storageCacheControl,
      'flutterWaveEncriptionKey': flutterWaveEncriptionKey,
      'flutterWavePublicKey': flutterWavePublicKey,
      'useAppLink': useAppLink,
      'timeZone': timeZone,
      // 'nswfParams': nswfParams,
      // 'nswfLiveVideoParams': nswfLiveVideoParams,
      'agoliaAppId': agoliaAppId,
      'modelFileRemoteConfig': modelFileRemoteConfig,
      'modelClassFileRemoteConfig': modelClassFileRemoteConfig,
      'defaultModelFileRemoteConfig': defaultModelFileRemoteConfig,
      'defaultModelClassFileRemoteConfig': defaultModelClassFileRemoteConfig,
      'wireDashProjectId': wireDashProjectId,
      'wireDashSecret': wireDashSecret,
      'timeZones': timeZones,
      'twitterApiKey': twitterApiKey,
      'twitterApiSecret': twitterApiSecret,
      'firebaseAuthRedirectCallbackUrl': firebaseAuthRedirectCallbackUrl,
      'firebaseEmulatorOrigin': firebaseEmulatorOrigin,
      'vapidKey': vapidKey,
      'enableAppleLogin': enableAppleLogin,
      'privacyUrl': privacyUrl,
      'termsUrl': termsUrl,
      'landingUrl': landingUrl,
      'stripePublishKey': stripePublishKey,
      'stripeElementFontUrl': stripeElementFontUrl,
      'stripeElementFontFamily': stripeElementFontFamily,
      'stripeElementFontWeight': stripeElementFontWeight,
      'region': region,
      'applePayMerchantId': applePayMerchantId,
      'torusNetwork': torusNetwork,
      'torusVerifier': torusVerifier,
      'solanaRPCUrl': solanaRPCUrl,
      'solanaWebsocketRPCUrl': solanaWebsocketRPCUrl,
      'transackAPIKey': transackAPIKey,
      'solanaCluster': solanaCluster,
      'roomConnectionUrl': roomConnectionUrl,
      'roomApiUrl': roomApiUrl,
      'passbaseApiKey': passbaseApiKey,
      'passbaseVerificationUrl': passbaseVerificationUrl,
      'recaptcha': recaptcha,
      'ftxPayBaseUrl': ftxPayBaseUrl,
      'transackBaseUrl': transackBaseUrl,
      'torusUrl': torusUrl,
      'kuroMarketUrl': kuroMarketUrl,
      'kuroMarketName': kuroMarketName,
      'rampBaseUrl': rampBaseUrl,
      'rampAPIKey': rampAPIKey,
      'solanaExploreUrl': solanaExploreUrl,
      'playstoreUrl': playstoreUrl,
      'appStoreUrl': appStoreUrl,
      'downloadUrl': downloadUrl,
    };
  }

  static String flavorToString(Flavor? flavor) {
    switch (flavor) {
      case Flavor.DEVELOPMENT:
        return 'dev';
      case Flavor.RELEASE:
        return 'prod';
      default:
        return 'dev';
    }
  }

  static Flavor flavorFromString(String flavor) {
    switch (flavor) {
      case 'dev':
        return Flavor.DEVELOPMENT;
      case 'prod':
        return Flavor.RELEASE;
      default:
        return Flavor.DEVELOPMENT;
    }
  }
}

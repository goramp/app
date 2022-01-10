//import 'package:recordly_webrtc/nsfw_detector.dart';

import 'app_config.dart';
import 'runner.dart';
import '.env.prod.dart';
//import '.env.dev.dart';

AppConfig config = AppConfig(
  flavor: Flavor.RELEASE,
  appName: environment['APP_NAME'],
  webDomain: environment['WEB_DOMAIN'],
  sentryDSN: environment['DSN'],
  photoStorageBucket: environment['PHOTO_STORAGE_BUCKET'],
  tempStorageBucket: environment['TEMP_STORAGE_BUCKET'],
  storageCacheControl: environment['CACHE_CONTROL'],
  iosAppGroupId: environment['IOS_APP_GROUP_ID'],
  wireDashProjectId: environment['WIREDASH_PROJECT_ID'],
  wireDashSecret: environment['WIREDASH_DASH_SECRET'],
  twitterApiKey: environment['TWITTER_API_KEY'],
  twitterApiSecret: environment['TWITTER_API_SECRET'],
  vapidKey: environment['VAPID_KEY'],
  isKuro: environment['IS_KURO'] == 'true',
  isBeta: environment['IS_BETA'] == 'true',
  termsUrl: environment['TERMS_URL'],
  privacyUrl: environment['PRIVACY_URL'],
  landingUrl: environment['LANDING_URL'],
  stripePublishKey: environment['STRIPE_PUBLISH_KEY'],
  stripeElementFontUrl: environment['STRIPE_ELEMENT_FONT_URL'],
  stripeElementFontFamily: environment['STRIPE_ELEMENT_FONT_FAMILY'],
  stripeElementFontWeight: environment['STRIPE_ELEMENT_FONT_WEIGHT'],
  region: environment['REGION'],
  applePayMerchantId: environment['APPLE_PAY_MERCHANT_ID'],
  torusNetwork: environment['TORUS_NETWORK'],
  torusVerifier: environment['TORUS_VERIFIER'],
  solanaRPCUrl: environment['SOLANA_URL'],
  solanaWebsocketRPCUrl: environment['SOLANA_WEBSOCKET_URL'],
  firebaseApiKey: environment['FIREBASE_API_KEY'],
  firebaseMessagingSenderId: environment['FIREBASE_MESSAGING_SENDER_ID'],
  firebaseAppId: environment['FIREBASE_APP_ID'],
  firebaseAuthDomain: environment['FIREBASE_AUTH_DOMAIN'],
  firebaseProjectId: environment['FIREBASE_PROJECT_ID'],
  firebaseDatabaseURL: environment['FIREBASE_PROJECT_ID'],
  firebaseStorageBucket: environment['FIREBASE_STORAGE_BUCKET'],
  firebaseMeasurementId: environment['FIREBASE_MEASUREMENT_ID'],
  firebaseAndroidClientId: environment['FIREBASE_ANDROID_CLIENT_ID'],
  frebaseIosClientId: environment['FIREBASE_IOS_CLIENT_ID'],
  //firebaseEmulatorOrigin: 'http://localhost:5000',
  solanaCluster: environment['SOLANA_CLUSTER'],
  transackAPIKey: environment['TRANSACK_API_KEY'],
  sentryReleaseName: environment['SENTRY_RELEASE_NAME'],
  roomConnectionUrl: environment['ROOM_CONNECTION_URL'],
  roomApiUrl: environment['ROOM_API_URL'],
  passbaseApiKey: environment['PASSBASE_API_KEY'],
  passbaseVerificationUrl: environment['PASSBASE_VERIFICATION_URL'],
  recaptcha: environment['RECAPTCHA_V3'],
  transackBaseUrl: environment['TRANSACK_BASE_URL'],
  ftxPayBaseUrl: environment['FTX_PAY_BASE_URL'],
  torusUrl: environment['TORUS_URL'],
  kuroMarketName: environment['KURO_MARKET_NAME'],
  kuroMarketUrl: environment['KURO_MARKET_URL'],
  solanaExploreUrl: environment['SOLANA_EXPLORE_URL'],
  appStoreUrl: environment['APPSTORE_URL'],
  playstoreUrl: environment['PLAYSTORE_URL'],
  downloadUrl: environment['DOWNLOAD_URL'],
  scheme: environment['SCHEME'],
);

void main() async {
  run(config);
}
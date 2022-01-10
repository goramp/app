import 'dart:io';
import 'dart:convert';

import 'package:dotenv/dotenv.dart' show load, env;

Future<void> main() async {
  final configFile = env['CONFIG_FILE_NAME'];
  if (configFile != null) {
    load(configFile);
  }
  final config = {
    'APP_NAME': env['APP_NAME'],
    'WEB_DOMAIN': env['WEB_DOMAIN'],
    'FIREBASE_SERVICE_URL': env['FIREBASE_SERVICE_URL'],
    'PRIVACY_URL': env['PRIVACY_URL'],
    'TERMS_URL': env['TERMS_URL'],
    'LANDING_URL': env['LANDING_URL'],
    'BASE_API_URL': env['BASE_API_URL'],
    'INTERCOM_IOS_API_KEY': env['INTERCOM_IOS_API_KEY'],
    'INTERCOM_APP_ID': env['INTERCOM_APP_ID'],
    'DSN': env['DSN'],
    'PHOTO_STORAGE_BUCKET': env['PHOTO_STORAGE_BUCKET'],
    'TEMP_STORAGE_BUCKET': env['TEMP_STORAGE_BUCKET'],
    'CACHE_CONTROL': env['CACHE_CONTROL'],
    'IOS_APP_GROUP_ID': env['IOS_APP_GROUP_ID'],
    'AGOLIA_APP_ID': env['AGOLIA_APP_ID'],
    'WIREDASH_PROJECT_ID': env['WIREDASH_PROJECT_ID'],
    'WIREDASH_DASH_SECRET': env['WIREDASH_DASH_SECRET'],
    'TWITTER_API_KEY': env['TWITTER_API_KEY'],
    'TWITTER_API_SECRET': env['TWITTER_API_SECRET'],
    'VAPID_KEY': env['VAPID_KEY'],
    'IS_KURO': env['IS_KURO'],
    'IS_BETA': env['IS_BETA'],
    'SENTRY_RELEASE_NAME': env['SENTRY_RELEASE_NAME'],
    'STRIPE_PUBLISH_KEY': env['STRIPE_PUBLISH_KEY'],
    'STRIPE_ELEMENT_FONT_URL': env['STRIPE_PUBLISH_KEY'],
    'STRIPE_ELEMENT_FONT_FAMILY': env['STRIPE_ELEMENT_FONT_FAMILY'],
    'STRIPE_ELEMENT_FONT_WEIGHT': env['STRIPE_ELEMENT_FONT_WEIGHT'],
    'REGION': env['REGION'],
    'APPLE_PAY_MERCHANT_ID': env['APPLE_PAY_MERCHANT_ID'],
    'TORUS_VERIFIER': env['TORUS_VERIFIER'],
    'TORUS_NETWORK': env['TORUS_NETWORK'],
    'SOLANA_URL': env['SOLANA_URL'],
    'SOLANA_WEBSOCKET_URL': env['SOLANA_WEBSOCKET_URL'],
    'FIREBASE_API_KEY': env['FIREBASE_API_KEY'],
    'FIREBASE_AUTH_DOMAIN': env['FIREBASE_AUTH_DOMAIN'],
    'FIREBASE_PROJECT_ID': env['FIREBASE_PROJECT_ID'],
    'FIREBASE_STORAGE_BUCKET': env['FIREBASE_STORAGE_BUCKET'],
    'FIREBASE_MESSAGING_SENDER_ID': env['FIREBASE_MESSAGING_SENDER_ID'],
    'FIREBASE_APP_ID': env['FIREBASE_APP_ID'],
    'FIREBASE_MEASUREMENT_ID': env['FIREBASE_MEASUREMENT_ID'],
    'FIREBASE_ANDROID_CLIENT_ID': env['FIREBASE_ANDROID_CLIENT_ID'],
    'FIREBASE_IOS_CLIENT_ID': env['FIREBASE_IOS_CLIENT_ID'],
    'FIREBASE_DATABASE_URL': env['FIREBASE_DATABASE_URL'],
    'RECAPTCHA_V3': env['RECAPTCHA_V3'],
    'SOLANA_CLUSTER': env['SOLANA_CLUSTER'],
    'TRANSACK_API_KEY': env['TRANSACK_API_KEY'],
    'ROOM_CONNECTION_URL': env['ROOM_CONNECTION_URL'],
    'ROOM_API_URL': env['ROOM_API_URL'],
    'PASSBASE_API_KEY': env['PASSBASE_API_KEY'],
    'PASSBASE_VERIFICATION_URL': env['PASSBASE_VERIFICATION_URL'],
    'FTX_PAY_BASE_URL': env['FTX_PAY_BASE_URL'],
    'TRANSACK_BASE_URL': env['TRANSACK_BASE_URL'],
    'TORUS_URL': env['TORUS_URL'],
    'KURO_MARKET_URL': env['KURO_MARKET_URL'],
    'KURO_MARKET_NAME': env['KURO_MARKET_NAME'],
    'RAMP_API_KEY': env['RAMP_API_KEY'],
    'RAMP_BASE_URL': env['RAMP_BASE_URL'],
    'SOLANA_EXPLORE_URL': env['SOLANA_EXPLORE_URL'],
    'PLAYSTORE_URL': env['PLAYSTORE_URL'],
    'APPSTORE_URL': env['APPSTORE_URL'],
    'DOWNLOAD_URL': env['DOWNLOAD_URL'],
    'SCHEME': env['SCHEME']
  };
  File('lib/.env.dev.dart')
      .writeAsString('const environment = ${json.encode(config)};');
  File('lib/.env.prod.dart')
      .writeAsString('const environment = ${json.encode(config)};');
}

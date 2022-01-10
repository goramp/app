import 'dart:ui';

import 'package:goramp/models/index.dart';
import 'package:goramp/models/token.dart';
import 'package:intl/intl.dart';

import 'notification_channels.dart';

const IOS_IAP_PRODUCTS = {
  "io.goramp.credit.tier5": 4.99,
  "io.goramp.credit.tier10": 9.99,
  "io.goramp.credit.tier25": 24.99,
  "io.goramp.credit.tier50": 49.99,
  "io.goramp.credit.tier55": 74.99,
  "io.goramp.credit.tier60": 99.99,
  "io.goramp.credit.tier66": 149.99,
  "io.goramp.credit.tier72": 199.99,
  "io.goramp.credit.tier78": 299.99,
  "io.goramp.credit.tier80": 399.99,
};

class AppIcons {
  static const CALENDAR_MONTH = "assets/svg/calendar-month-outline.svg";
  static const CALENDAR_ALERT = "assets/svg/calendar-month-outline.svg";
}

class PaymentCardIcons {
  static const MASTER_CARD_LIGHT =
      "assets/images/payment_methods/light/mastercard.svg";
  static const MASTER_CARD_DARK =
      "assets/images/payment_methods/dark/mastercard.svg";
  static const VISA_CARD_LIGHT = "assets/images/payment_methods/light/visa.svg";
  static const VISA_CARD_DARK = "assets/images/payment_methods/dark/visa.svg";
  static const DINERS_CARD_LIGHT =
      "assets/images/payment_methods/light/diners.svg";
  static const DINERS_CARD_DARK =
      "assets/images/payment_methods/dark/diners.svg";
  static const AMEX_CARD_LIGHT = "assets/images/payment_methods/amex.svg";
  static const AMEX_CARD_DARK = "assets/images/payment_methods/amex.svg";
  static const DISCOVER_CARD_LIGHT =
      "assets/images/payment_methods/discover.svg";
  static const DISCOVER_CARD_DARK =
      "assets/images/payment_methods/discover.svg";
  static const UNION_CARD_LIGHT = "assets/images/payment_methods/union.svg";
  static const UNION_CARD_DARK = "assets/images/payment_methods/union.svg";
  static const JCB_CARD_LIGHT = "assets/images/payment_methods/jcb.svg";
  static const JCB_CARD_DARK = "assets/images/payment_methods/jcb.svg";
}

class SocialIcons {
  static const TWITTER = "assets/images/social_icons/twitter.svg";
  static const FACEBOOK = "assets/images/social_icons/facebook.svg";
  static const WHATSAPP = "assets/images/social_icons/whatsapp.svg";
  static const LINE = "assets/images/social_icons/line.png";
  static const LinkedIn = "assets/images/social_icons/linkedin.svg";
}

class COINS {
  static const USDC = "assets/images/usdc/usdc.svg";
  static const KURO = "assets/images/klogo/kurobi.svg";
  static const SOL = "assets/images/solana/solana.svg";
  static const KIN = "assets/images/kin/kin.svg";
  static const USDT = "assets/images/usdt/usdt.svg";
}

class AFRO_BUBBLE {
  static const AFRO0 = "assets/images/afrobubble/kurobi_afro0.png";
  static const AFRO1 = "assets/images/afrobubble/kurobi_afro1.png";
  static const AFRO2 = "assets/images/afrobubble/kurobi_afro2.png";
  static const AFRO3 = "assets/images/afrobubble/kurobi_afro3.png";
  static const AFRO4 = "assets/images/afrobubble/kurobi_afro4.png";
  static const GIVEAWAY = "assets/images/afrobubble/giveaway.png";
  static const DEAD = "assets/images/afrobubble/dead.png";
}

class WALLETS {
  static const sollet = "assets/images/wallets/sollet.svg";
  static const kurobi = "assets/images/klogo/kurobi.svg";
  static const phantom = "assets/images/wallets/phantom.svg";
  static const solletExtension = "assets/images/wallets/sollet_extension.png";
}

class PARTNERS {
  static const TRANSACK = "assets/images/transack/transack.png";
  static const FTX = "assets/images/ftx/ftx.svg";
  static const RAMP = "assets/images/ramp/ramp.svg";
}

class Constants {
  static const NFT = "assets/images/nft/nft.png";
  static const APP_LOGO_WEB = "assets/assets/images/glogo/logo.svg";
  static const APP_LOGO_SVG = "assets/images/glogo/logo.svg";
  static const APP_LOGO_KURO_SVG = "assets/images/klogo/kurobi.svg";

  static const CONTRIBUTIONS_WHITE_SVG =
      "assets/images/contribution/ended-light.svg";
  static const CONTRIBUTIONS_DARK_SVG =
      "assets/images/contribution/ended-dark.svg";

  static const SERVICE_UNAVAILABLE_WHITE_SVG =
      "assets/images/service/no-region-light.svg";
  static const SERVICE_UNAVAILABLE_DARK_SVG =
      "assets/images/service/no-region-dark.svg";

  static const CONTRIBUTIONS_MAX_WHITE_SVG =
      "assets/images/contribution/max-contribution-light.svg";
  static const CONTRIBUTIONS_MAX_DARK_SVG =
      "assets/images/contribution/max-contribution-dark.svg";
  static const PATTERN_SVG = "assets/images/pattern/bg.svg";
  static const PATTERN_PNG = "assets/images/pattern/bg.png";
  static const ALT_PATTERN_SVG = "assets/images/pattern/bg-dark-gradient.svg";

  static const DARK_GRADIENT_PATTERN_SVG =
      "assets/images/pattern/bg-dark-gradient.svg";

  static const TORUS_LOGO_WHITE_SVG = "assets/images/torus/white.svg";
  static const TORUS_LOGO_BLUE_SVG = "assets/images/torus/blue.svg";
  static const STRIPE_LOGO_WEB = "assets/assets/images/stripe/white.svg";
  static const STRIPE_LOGO_WHITE_SVG = "assets/images/stripe/white.svg";
  static const STRIPE_LOGO_BLURPLE_SVG = "assets/images/stripe/blurple.svg";
  static const STRIPE_LOGO_SLATE_SVG = "assets/images/stripe/slate.svg";
  static const COINBASE_LOGO_WEB =
      "assets/assets/images/coinbase_commerce/logo.svg";
  static const COINBASE_LOGO_SVG = "assets/images/coinbase_commerce/logo.svg";
  static const NAME = "name";
  static const APP_ICON_FONT = "recordly";
  static const DEFAULT_ERROR_TITLE = 'Something went wrong';
  static const UNIQUE_ERROR_KEY = "unique";
  static const UNIQUE_ERROR_KEY_MESSAGE = "Already exist";
  static const INVALID_ERROR_KEY = "invalid";
  static const INVALID_ERROR_KEY_MESSAGE = "Invalid";
  static const REQUIRED_ERROR_KEY = "required";
  static const REQUIRED_ERROR_KEY_MESSAGE = "Can't be empty";
  static const MIN_LENGTH_ERROR_KEY = "minLength";
  static const MIN_LENGTH_ERROR_KEY_MESSAGE = "Must be at least ";
  static const MAX_LENGTH_ERROR_KEY = "maxLength";
  static const MAX_LENGTH_ERROR_KEY_MESSAGE = "Must not be more than ";
  static const NOT_MATCH_ERROR_KEY = "notMatch";
  static const NOT_MATCH_ERROR_KEY_MESSAGE = "Does not match";
  static const NOT_FOUND_ERROR_KEY = "notFound";
  static const NOT_FOUND_ERROR_KEY_MESSAGE = "Not found";
  static const UNKNOWN_ERROR_KEY = "unknown";
  static const UNKNOWN_ERROR_KEY_MESSAGE = "Unknown error";
  static const FORMAT_ERROR_KEY = "format";
  static const FORMAT_ERROR_KEY_MESSAGE = "Invalid format";
  static const WHITE_SPACE_ERROR_KEY = "whiteSpace";
  static const WHITE_SPACE_ERROR_KEY_MESSAGE = "No spaces";
  static const USERNAME_FIELD = "username";
  static const CODE_FIELD = "code";
  static const EMAIL_FIELD = "email";
  static const PHONE_NUMBER_FIELD = "phoneNumber";
  static const FIRST_NAME_FIELD = "firstName";
  static const LAST_NAME_FIELD = "lastName";
  static const NAME_FIELD = "name";
  static const API_KEY_FIELD = "apiKey";
  static const BIO_FIELD = "bio";
  static const AGE_FIELD = "age";
  static const BIRTHDAY_FIELD = "birthday";
  static const PASSWORD_FIELD = "password";
  static const PASSWORD_CONFIRM_FIELD = "confirm_password";
  static const UID_FIELD = "uid";
  static const PROVIDER_FIELD = "provider";
  static const UNKNOWN_FIELD = "unknown";
  static const IMAGE_FIELD = "image";
  static const VIDEO_THUMB_SIZE = Size(300, 300);
  static const MIN_VIDEO_PREVIEW_DURATION = Duration(seconds: 30);
  static const PENDING_EVENT_KEY = "pendingEvent";
  static const PENDING_UPLOAD_KEY = "pendingUpload";
  static const CAMERA_PERMISSION_ERROR_CODE = "PermissionError";
  static const CAMERA_OVERCONSTRAINED_ERROR_CODE = "OverconstrainedError";
  static const IOS_IAP = IOS_IAP_PRODUCTS;
  static const IAP_SYNC_PATH = "iapreceipts/create";
  static const INCOMING_CALL_NOTIFICATION_CHANNEL =
      "notification/incoming-call";
  static const MISSED_CALL_NOTIFICATION_CHANNEL = "notification/missed-call";

  static const BLOB_VIDEO_CONTENT_TYOE = 'video/blob';
}

const ANDROID_NOTIFICATION_CHANNELS = {
  Constants.INCOMING_CALL_NOTIFICATION_CHANNEL: const NotificationChannel(
      channelId: Constants.INCOMING_CALL_NOTIFICATION_CHANNEL,
      channelName: "In-call Notifications",
      channelDescription: ""),
  Constants.MISSED_CALL_NOTIFICATION_CHANNEL: const NotificationChannel(
      channelId: Constants.MISSED_CALL_NOTIFICATION_CHANNEL,
      channelName: "Missed calls",
      channelDescription: ""),
};

final kCryptoFormatter = NumberFormat(
  '##,###.####',
);

const SOLANA_CHAIN_ID = "101";
const LUNA_CHAIN_ID = "101";
const NATIVE_SOL = Token(
    mintAddress: 'Ejmc1UB4EsES5oAaRN63SpoxMJidt3ZGBrqrZk49vjTZ',
    tokenName: 'Solana',
    tokenSymbol: 'SOL',
    decimals: 9,
    isNative: true,
    deprecated: false,
    canSwap: true,
    canBuy: true,
    chainId: SOLANA_CHAIN_ID,
    icon: COINS.SOL);

const WSOL = Token(
    mintAddress: 'So11111111111111111111111111111111111111112',
    tokenName: 'Wrapped Solana',
    tokenSymbol: 'WSOL',
    decimals: 9,
    canSwap: true,
    chainId: SOLANA_CHAIN_ID,
    icon: COINS.SOL);
const USDCMain = Token(
    mintAddress: 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v',
    tokenName: 'USD Coin',
    tokenSymbol: 'USDC',
    canSwap: true,
    decimals: 6,
    canBuy: true,
    chainId: SOLANA_CHAIN_ID,
    icon: COINS.USDC);
const USDTMain = Token(
    mintAddress: 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB',
    tokenName: 'USDT',
    tokenSymbol: 'USDT',
    canSwap: true,
    canBuy: true,
    decimals: 6,
    chainId: SOLANA_CHAIN_ID,
    //deprecated: true,
    icon: COINS.USDT);
const KUROMain = Token(
    mintAddress: '2Kc38rfQ49DFaKHQaWbijkE7fcymUMLY5guUiUsDmFfn',
    tokenName: 'Kurobi',
    tokenSymbol: 'KURO',
    decimals: 6,
    canSwap: true,
    canBuy: true,
    chainId: SOLANA_CHAIN_ID,
    icon: COINS.KURO);
const KINMain = Token(
    mintAddress: 'kinXdEcpDQeHPEuQnqmUgtYykqKGVFq6CeVX5iAHJq6',
    tokenName: 'KIN',
    tokenSymbol: 'KIN',
    canBuy: true,
    canSwap: true,
    decimals: 5,
    chainId: SOLANA_CHAIN_ID,
    icon: COINS.KIN);
const KURO_TOKENS = {
  'devnet': [
    Token(
        mintAddress: 'GGD42RFqi15NTJ5f6vhkHgdSsNj7JgBrP5aDbwYbJX1p',
        tokenName: 'Kurobi',
        tokenSymbol: 'KURO',
        canSwap: true,
        canBuy: true,
        decimals: 6,
        chainId: SOLANA_CHAIN_ID,
        icon: COINS.KURO),
    Token(
        mintAddress: 'AceG2Tu2RpyAX6UhDYdmQdrp6rRxkoCaNEnRKx3S7jTs',
        tokenName: 'USDT',
        tokenSymbol: 'USDT',
        canBuy: true,
        decimals: 6,
        chainId: SOLANA_CHAIN_ID,
        icon: COINS.USDT),
    NATIVE_SOL,
    Token(
        mintAddress: '9rLKRnixt98jUeSp74xgrrsXKeqgCKAQM3WLNpdm5SmX',
        tokenName: 'USD Coin',
        tokenSymbol: 'USDC',
        canSwap: true,
        decimals: 6,
        chainId: SOLANA_CHAIN_ID,
        icon: COINS.USDC),
  ],
  'mainnet': [KUROMain, USDCMain, USDTMain, KINMain, NATIVE_SOL]
};

const SPL_TOKEN_PROGRAM = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA';
const OWNER_VALIDATION_PROGRAM_ID =
    '4MNPdKu9wFMvEeZBMt3Eipfs5ovVWTJb31pEXDJAAxX5';

import 'package:goramp/widgets/pages/wallets/crypto/buy/buy_mobile.dart';

class RampOptions {
  RampOptions({
    this.swapAsset,
    this.userAddress,
    this.swapAmount,
    this.userEmailAddress,
    this.hostApiKey,
    this.hostLogoUrl,
    this.hostAppName,
    this.baseUrl,
    this.finalUrl,
    this.variant,
    this.defaultAsset,
  });
  final String? swapAsset;
  final String? userAddress;
  final String? swapAmount;
  final String? userEmailAddress;
  final String? hostApiKey;
  final String? hostLogoUrl;
  final String? hostAppName;
  final String? baseUrl;
  final String? finalUrl;
  final String? variant;
  final String? defaultAsset;

  String get url {
    final query = encodeMap(toMap());
    final url = '$baseUrl?$query';
    return url;
  }

  @override
  RampOptions.fromMap(Map<String, dynamic> map)
      : swapAsset = map['swapAsset'],
        userAddress = map['userAddress'],
        swapAmount = map['swapAmount'],
        userEmailAddress = map['userEmailAddress'],
        hostApiKey = map['hostApiKey'],
        hostLogoUrl = map['hostLogoUrl'],
        hostAppName = map['hostAppName'],
        baseUrl = map['baseUrl'],
        finalUrl = map['finalUrl'],
        variant = map['variant'],
        defaultAsset = map['defaultAsset'];

  Map<String, dynamic> toMap() {
    return {
      'swapAsset': swapAsset,
      'userAddress': userAddress,
      'swapAmount': swapAmount,
      'userEmailAddress': userEmailAddress,
      'hostApiKey': hostApiKey,
      'hostLogoUrl': hostLogoUrl,
      'hostAppName': hostAppName,
      //'url': baseUrl,
      'finalUrl': finalUrl,
      'variant': variant,
      'defaultAsset': defaultAsset,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class TransackOptions {
  TransackOptions(this.baseUrl,
      {this.environment,
      this.cryptoCurrencyCode,
      this.walletAddress,
      this.redirectURL,
      this.email,
      this.themeColor,
      this.apiKey,
      this.hostURL,
      this.network,
      this.fiatCurrency,
      this.fiatAmount,
      this.disableWalletAddressForm = true,
      this.hideExchangeScreen = true,
      this.hideMenu = true,
      this.partnerCustomerId,
      this.partnerOrderId,
      this.defaultCryptoAmount,
      this.defaultCryptoCurrency});
  final String baseUrl;
  final String? environment;
  final String? cryptoCurrencyCode;
  final String? walletAddress;
  final String? redirectURL;
  final String? email;
  final String? themeColor;
  final String? apiKey;
  final String? hostURL;
  final String? network;
  final String? fiatCurrency;
  final String? fiatAmount;
  final String? partnerOrderId;
  final bool? disableWalletAddressForm;
  final bool? hideExchangeScreen;
  final bool? hideMenu;
  final String? partnerCustomerId;
  final String? defaultCryptoAmount;
  final String? defaultCryptoCurrency;

  String get url {
    final query = encodeMap(toMap());
    final url = '$baseUrl?$query';
    print('TRANSAK URL: $url');
    return url;
  }

  @override
  TransackOptions.fromMap(Map<String, dynamic> map)
      : baseUrl = map['baseUrl'],
        environment = map['environment'],
        redirectURL = map['redirectURL'],
        cryptoCurrencyCode = map['cryptoCurrencyCode'],
        email = map['email'],
        themeColor = map['themeColor'],
        apiKey = map['apiKey'],
        hostURL = map['hostURL'],
        network = map['network'],
        fiatCurrency = map['fiatCurrency'],
        fiatAmount = map['fiatAmount'],
        walletAddress = map['walletAddress'],
        partnerOrderId = map['partnerOrderId'],
        hideExchangeScreen = map['hideExchangeScreen'],
        hideMenu = map['hideMenu'],
        disableWalletAddressForm = map['disableWalletAddressForm'],
        partnerCustomerId = map['partnerCustomerId'],
        defaultCryptoAmount = map['defaultCryptoAmount'],
        defaultCryptoCurrency = map['defaultCryptoCurrency'];

  Map<String, dynamic> toMap() {
    return {
      'baseUrl': baseUrl,
      'environment': environment,
      'cryptoCurrencyCode': cryptoCurrencyCode,
      'walletAddress': walletAddress,
      'redirectURL': redirectURL,
      'email': email,
      'themeColor': themeColor,
      'apiKey': apiKey,
      'hostURL': hostURL,
      'fiatCurrency': fiatCurrency,
      'fiatAmount': fiatAmount,
      'network': network,
      'disableWalletAddressForm': disableWalletAddressForm,
      'hideExchangeScreen': hideExchangeScreen,
      'partnerOrderId': partnerOrderId,
      'hideMenu': hideMenu,
      'partnerCustomerId': partnerCustomerId,
      'defaultCryptoAmount': defaultCryptoAmount,
      'defaultCryptoCurrency': defaultCryptoCurrency,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class FTXOptions {
  FTXOptions(this.baseUrl,
      {this.coin,
      this.address,
      this.wallet,
      this.memoIsRequired,
      this.redirectURL});
  final String baseUrl;
  final String? coin;
  final String? address;
  final String? wallet;
  final bool? memoIsRequired;
  final String? redirectURL;

  @override
  FTXOptions.fromMap(Map<String, dynamic> map)
      : baseUrl = map['baseUrl'],
        coin = map['coin'],
        address = map['address'],
        wallet = map['wallet'],
        memoIsRequired = map['memoIsRequired'],
        redirectURL = map['redirectURL'];

  String get url {
    final query = encodeMap(toMap());
    return '$baseUrl?/$query';
  }

  Map<String, dynamic> toMap() {
    return {
      'baseUrl': baseUrl,
      'coin': coin,
      'address': address,
      'wallet': wallet,
      'memoIsRequired': memoIsRequired,
      'redirectURL': redirectURL,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

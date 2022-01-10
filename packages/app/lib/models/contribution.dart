import 'package:equatable/equatable.dart';
import 'package:goramp/utils/index.dart';

class Contribution extends Equatable {
  Contribution(
      {required this.id,
      required this.contributionId,
      required this.maxAmount,
      required this.minAmount,
      required this.sourceToken,
      required this.destinationToken,
      required this.createdAt,
      required this.updatedAt,
      required this.startAt,
      required this.endAt,
      required this.totalAmountSourceToken,
      required this.rate,
      required this.enabled,
      required this.targetAmountSourceToken,
      required this.sourceDecimal,
      required this.destinationDecimal,
      required this.canBuy,
      required this.preBuyInfo,
      required this.canClaim,
      this.buyInfo,
      this.marketUrl1,
      this.marketUrl2,
      this.marketName1,
      this.marketName2,
      this.totalAmountDestinationToken,
      this.sourceTokenMintAddress,
      this.destinationTokenMintAddress,
      this.title,
      this.subTitle,
      this.kycRequired,
      this.claimMessage});

  final String? id;
  final String? contributionId;
  final String? sourceTokenMintAddress;
  final String? destinationTokenMintAddress;
  final num? totalAmountDestinationToken;
  final String? title;
  final String? subTitle;
  final bool? kycRequired;
  final num rate;
  final num maxAmount;
  final num sourceDecimal;
  final num destinationDecimal;
  final bool enabled;
  final bool canBuy;
  final bool canClaim;
  final String? claimMessage;
  final String preBuyInfo;
  final String? buyInfo;
  final String? marketUrl1;
  final String? marketUrl2;
  final String? marketName1;
  final String? marketName2;
  final num minAmount;
  final num totalAmountSourceToken;
  final num targetAmountSourceToken;
  final String sourceToken;
  final String destinationToken;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? startAt;

  final DateTime? endAt;

  List<Object?> get props => [
        id,
        contributionId,
        totalAmountDestinationToken,
        title,
        subTitle,
        rate,
        maxAmount,
        minAmount,
        totalAmountSourceToken,
        sourceToken,
        destinationToken,
        createdAt,
        updatedAt,
        startAt,
        endAt,
        enabled,
        targetAmountSourceToken,
        sourceDecimal,
        destinationDecimal,
        sourceTokenMintAddress,
        destinationTokenMintAddress,
        kycRequired,
        canBuy,
        preBuyInfo,
        buyInfo,
        marketUrl1,
        marketUrl2,
        marketName1,
        marketName2,
        canClaim,
        claimMessage
      ];

  @override
  Contribution.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        contributionId = map['contributionId'],
        totalAmountDestinationToken = map['totalAmountDestinationToken'],
        sourceTokenMintAddress = map['sourceTokenMintAddress'],
        destinationTokenMintAddress = map['destinationTokenMintAddress'],
        title = map['title'],
        subTitle = map['subTitle'],
        maxAmount = map['maxAmount'],
        minAmount = map['minAmount'],
        kycRequired = map['kycRequired'],
        rate = map['rate'],
        enabled = map['enabled'],
        totalAmountSourceToken = map['totalAmountSourceToken'] ?? 0,
        targetAmountSourceToken = map['targetAmountSourceToken'] ?? 0,
        sourceToken = map['sourceToken'],
        destinationDecimal = map['destinationDecimal'],
        sourceDecimal = map['sourceDecimal'],
        destinationToken = map['destinationToken'],
        canBuy = map['canBuy'],
        preBuyInfo = map['preBuyInfo'],
        buyInfo = map['buyInfo'],
        marketUrl1 = map['marketUrl1'],
        marketUrl2 = map['marketUrl2'],
        marketName1 = map['marketName1'],
        marketName2 = map['marketName2'],
        canClaim = map['canClaim'],
        claimMessage = map['claimMessage'],
        createdAt = parseDate(map['createdAt']),
        updatedAt = parseDate(map['updatedAt']),
        startAt = parseDate(map['startAt']),
        endAt = parseDate(map['endAt']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contributionId': contributionId,
      'totalAmountDestinationToken': totalAmountDestinationToken,
      'sourceTokenMintAddress': sourceTokenMintAddress,
      'destinationTokenMintAddress': destinationTokenMintAddress,
      'title': title,
      'subTitle': subTitle,
      'enabled': enabled,
      'maxAmount': maxAmount,
      'minAmount': minAmount,
      'kycRequired': kycRequired,
      'rate': rate,
      'totalAmountSourceToken': totalAmountSourceToken,
      'targetAmountSourceToken': targetAmountSourceToken,
      'sourceToken': sourceToken,
      'sourceDecimal': sourceDecimal,
      'destinationDecimal': destinationDecimal,
      'destinationToken': destinationToken,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'startAt': startAt?.millisecondsSinceEpoch,
      'endAt': endAt?.millisecondsSinceEpoch,
      'canBuy': canBuy,
      'preBuyInfo': preBuyInfo,
      'buyInfo': buyInfo,
      'marketUrl1': marketUrl1,
      'marketUrl2': marketUrl2,
      'marketName1': marketName1,
      'marketName2': marketName2,
      'canClaim': canClaim,
      'claimMessage': claimMessage,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }

  bool get ended => endAt!.isBefore(DateTime.now());
  bool get started => startAt!.isBefore(DateTime.now());
  bool get notStarted => startAt!.isAfter(DateTime.now());
}

class UserContribution extends Equatable {
  UserContribution({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.totalAmountSourceToken,
    required this.totalAmountDestinationToken,
    required this.contributionId,
    required this.totalAmountDestinationTokenClaim,
  });

  final String? contributionId;
  final String? userId;
  final num totalAmountSourceToken;
  final num totalAmountDestinationToken;
  final num totalAmountDestinationTokenClaim;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  List<Object?> get props => [
        contributionId,
        userId,
        totalAmountSourceToken,
        totalAmountDestinationToken,
        totalAmountDestinationTokenClaim,
        createdAt,
        updatedAt,
      ];

  bool get hasClaimed => totalAmountDestinationToken > 0;
  bool get hasContributed => totalAmountDestinationTokenClaim > 0;

  @override
  UserContribution.fromMap(Map<String, dynamic> map)
      : contributionId = map['contributionId'],
        userId = map['userId'],
        totalAmountDestinationToken = map['totalAmountDestinationToken'] ?? 0,
        totalAmountSourceToken = map['totalAmountSourceToken'] ?? 0,
        totalAmountDestinationTokenClaim =
            map['totalAmountDestinationTokenClaim'] ?? 0,
        createdAt = parseDate(map['createdAt']),
        updatedAt = parseDate(map['updatedAt']);

  Map<String, dynamic> toMap() {
    return {
      'contributionId': contributionId,
      'totalAmountDestinationToken': totalAmountDestinationToken,
      'totalAmountDestinationTokenClaim': totalAmountDestinationTokenClaim,
      'userId': userId,
      'totalAmountSourceToken': totalAmountSourceToken,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

class RewardClaim extends Equatable {
  RewardClaim({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.claimedAt,
    required this.expiresAt,
    required this.amount,
    required this.decimal,
    required this.currency,
    this.mintAddress,
    this.photoUrl,
    this.title,
    this.type,
    this.subtitle,
    this.status,
    this.description,
    this.backgroundColor,
  });

  final String id;
  final String? type;
  final String? title;
  final String? mintAddress;
  final String? subtitle;
  final String? photoUrl;
  final String? userId;
  final String? status;
  final DateTime? claimedAt;
  final String amount;
  final int decimal;
  final String currency;
  final String? description;
  final String? backgroundColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;

  List<Object?> get props => [
        id,
        type,
        title,
        userId,
        amount,
        decimal,
        currency,
        status,
        subtitle,
        photoUrl,
        claimedAt,
        createdAt,
        updatedAt,
        expiresAt,
        mintAddress,
        description,
        backgroundColor,
      ];

  @override
  RewardClaim.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        type = map['type'],
        userId = map['userId'],
        amount = map['amount'],
        decimal = map['decimal'],
        currency = map['currency'],
        mintAddress = map['mintAddress'],
        title = map['title'],
        subtitle = map['subtitle'],
        status = map['status'],
        photoUrl = map['photoUrl'],
        description = map['description'],
        backgroundColor = map['backgroundColor'],
        createdAt = parseDate(map['createdAt']),
        updatedAt = parseDate(map['updatedAt']),
        claimedAt = parseDate(map['claimedAt']),
        expiresAt = parseDate(map['expiresAt']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'userId': userId,
      'amount': amount,
      'decimal': decimal,
      'currency': currency,
      'title': title,
      'subtitle': subtitle,
      'photoUrl': photoUrl,
      'mintAddress': mintAddress,
      'description': description,
      'backgroundColor': backgroundColor,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'claimedAt': claimedAt?.millisecondsSinceEpoch,
      'expiresAt': expiresAt?.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

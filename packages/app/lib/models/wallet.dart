import 'package:equatable/equatable.dart';

class UserWallet extends Equatable {
  final String? type;
  final String? address;
  final String? providerId;
  final int? chainId;

  const UserWallet({
    this.providerId,
    this.type,
    this.chainId,
    this.address,
  });

  List<Object?> get props => [
        providerId,
        chainId,
        type,
        providerId,
        address
      ];

  factory UserWallet.fromMap(Map<String, dynamic> map) {
    return UserWallet(
      providerId: map['providerId'],
      type: map['type'],
      chainId: map['chainId'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'type': type,
      'chainId': chainId,
      'address': address
    };
  }
}

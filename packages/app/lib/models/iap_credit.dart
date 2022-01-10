

class IAPCredit {
  final double? availableBalance;
  final double? totalBalance;

  const IAPCredit({
    this.availableBalance,
    this.totalBalance,
  });

  factory IAPCredit.fromMap(Map<String, dynamic> map) {
    return IAPCredit(
      availableBalance: map['availableBalance'],
      totalBalance: map['totalBalance'],
    );
  }

  @override
  bool operator ==(other) =>
      other is IAPCredit &&
      other.availableBalance == availableBalance &&
      other.totalBalance == totalBalance;

  @override
  int get hashCode => availableBalance.hashCode ^ totalBalance.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'availableBalance': availableBalance,
      'totalBalance': totalBalance,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

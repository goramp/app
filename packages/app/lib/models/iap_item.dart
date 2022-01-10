const DEFAULT_IOS_IAP_PRODUCTS = [
  IAPItem(sku: "io.goramp.credit.tier5", value: 499, tier: 5),
  IAPItem(sku: "io.goramp.credit.tier10", value: 999, tier: 10),
  IAPItem(sku: "io.goramp.credit.tier25", value: 2499, tier: 25),
  IAPItem(sku: "io.goramp.credit.tier50", value: 4999, tier: 50),
  IAPItem(sku: "io.goramp.credit.tier55", value: 7499, tier: 55),
  IAPItem(sku: "io.goramp.credit.tier60", value: 9999, tier: 60),
  IAPItem(sku: "io.goramp.credit.tier66", value: 14999, tier: 66),
  IAPItem(sku: "io.goramp.credit.tier72", value: 19999, tier: 72),
  IAPItem(sku: "io.goramp.credit.tier78", value: 29999, tier: 78),
  IAPItem(sku: "io.goramp.credit.tier80", value: 39999, tier: 80),
];

class IAPItem {
  final String? sku;
  final int? value;
  final int? tier;
  final bool? enabled;

  const IAPItem({this.sku, this.value, this.tier, this.enabled = true});

  factory IAPItem.fromMap(Map<String, dynamic> map) {
    return IAPItem(
      sku: map['sku'],
      value: map['value'],
      tier: map['tier'],
      enabled: map['enabled'],
    );
  }

  @override
  bool operator ==(other) =>
      other is IAPItem &&
      other.sku == sku &&
      other.value == value &&
      other.tier == tier &&
      other.enabled == enabled;

  @override
  int get hashCode => sku.hashCode ^ value.hashCode ^ tier.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'sku': sku,
      'value': value,
      'tier': tier,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

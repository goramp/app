class Checkout {
  Checkout(
      {this.id,
      this.successUrl,
      this.checkoutUrl,
      this.cancelUrl,
      this.providerId,
      this.stripeAccountId,
      this.apiKey});
  final String? id;
  final String? successUrl;
  final String? checkoutUrl;
  final String? cancelUrl;
  final String? providerId;
  final String? stripeAccountId;
  final String? apiKey;

  @override
  Checkout.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        cancelUrl = map['cancelUrl'],
        successUrl = map['successUrl'],
        providerId = map['providerId'],
        stripeAccountId = map['stripeAccountId'],
        apiKey = map['apiKey'],
        checkoutUrl = map['checkoutUrl'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'successUrl': successUrl,
      'checkoutUrl': checkoutUrl,
      'cancelUrl': cancelUrl,
      'providerId': providerId,
      'stripeAccountId': stripeAccountId,
      'apiKey': apiKey,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

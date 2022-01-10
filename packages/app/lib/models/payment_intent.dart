class PaymentIntent {
  PaymentIntent(
      {this.amount,
      this.currency,
      this.paymentMethodTypes,
      this.applicationFee,
      this.providerId,
      this.providerName,
      this.apiKey});
  final num? amount;
  final String? currency;
  final List<String>? paymentMethodTypes;
  final num? applicationFee;
  final String? providerId;
  final String? providerName;
  final String? apiKey;

  @override
  PaymentIntent.fromMap(Map<String, dynamic> map)
      : amount = map['amount'],
        applicationFee = map['applicationFee'],
        currency = map['currency'],
        providerId = map['providerId'],
        providerName = map['providerName'],
        apiKey = map['apiKey'],
        paymentMethodTypes = map['payment_method_types'] != null
            ? map['payment_method_types'].cast<String>()
            : null;

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
      'paymentMethodTypes': paymentMethodTypes,
      'applicationFee': applicationFee,
      'providerId': providerId,
      'providerName': providerName,
      'apiKey': apiKey,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

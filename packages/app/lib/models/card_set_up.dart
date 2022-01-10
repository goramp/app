class CardSetup {
  final String? clientSecret;
  final String? publishKey;
  final String? country;

  const CardSetup({
    this.clientSecret,
    this.publishKey,
    this.country,
  });

  factory CardSetup.fromMap(Map<String, dynamic> map) {
    return CardSetup(
        clientSecret: map['clientSecret'],
        publishKey: map['publishKey'],
        country: map['country'] ?? 'US');
  }

  @override
  bool operator ==(other) =>
      other is CardSetup &&
      other.clientSecret == clientSecret &&
      other.publishKey == publishKey &&
      other.country == country;

  @override
  int get hashCode => clientSecret.hashCode ^ publishKey.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'clientSecret': clientSecret,
      'publishKey': publishKey,
      'country': country,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

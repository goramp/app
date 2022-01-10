import 'package:equatable/equatable.dart';

class CoverPattern extends Equatable {
  const CoverPattern(
      {required this.name,
      required this.url,
      required this.mimeType,
      this.color});

  final String name;
  final String url;
  final String? color;
  final String mimeType;

  List<Object?> get props => [name, url, mimeType, color];

  factory CoverPattern.fromMap(Map<String, dynamic> map) {
    return CoverPattern(
      name: map['name'],
      url: map['url'],
      mimeType: map['mimeType'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'mimeType': mimeType,
      'color': color,
    };
  }
}

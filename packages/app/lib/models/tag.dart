import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final String? name;
  final String? locale;
  final int? count;
  Tag({
    this.name,
    this.locale,
    this.count = 0,
  });

  List<Object?> get props => [name, locale];

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      name: map['name'],
      locale: map['locale'],
      count: map['count'],
    );
  }  

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'locale': locale,
      'count': count,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

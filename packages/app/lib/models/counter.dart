import 'package:equatable/equatable.dart';

class Counter extends Equatable {
  final int? count;

  Counter(this.count);

  List<Object?> get props => [count];

  @override
  String toString() {
    return '$runtimeType('
        'count: $count, ';
  }

  factory Counter.fromMap(Map<String, dynamic> map) {
    return Counter(map['count']);
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
    };
  }
}

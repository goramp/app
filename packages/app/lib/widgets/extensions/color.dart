import 'package:flutter/material.dart';

extension ColorsExtensions on Color {
  String toHex() => '#${this.value.toRadixString(16).substring(2)}';
  String toRgba() =>
      'rgba(${this.red},${this.green},${this.blue},${this.opacity})';
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

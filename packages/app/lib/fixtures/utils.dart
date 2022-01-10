
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<dynamic> loadAsset(String asset) async {
  return await rootBundle.loadString(asset);
}
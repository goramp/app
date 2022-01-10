import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorHandler {
  /// Exception will be logged to console during debug mode
  /// and sent to Sentry during release mode
  static void report(
    e,
    StackTrace? s, {
    Map<String, dynamic>? hint,
  }) {
    if (kDebugMode) {
      // only print to console during debug mode
      print(e);
      print(s);

      if (hint != null) {
        print('---------hint-------');
        print(hint);
      }
      return;
    }

    Sentry.captureException(
      e,
      stackTrace: s,
      hint: hint != null ? jsonEncode(hint) : hint,
    );
  }
}

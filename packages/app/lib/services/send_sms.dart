import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


enum SendSMSResult {
  complete,
  error,
  canceled,
}

class SendSMSPlugin {

  static const MethodChannel _channel =
  const MethodChannel('SendSMSPlugin');

  static Future<SendSMSResult> sendSMS({
    required String body,
    required List<String> recipients,
  }) async {
    var mapData = Map();
    mapData["body"] = body;
    mapData["recipients"] = recipients;
    final ret = await _channel.invokeMethod('sendSMS', mapData);
    Map<String, dynamic>? result = ret.cast<String, dynamic>();
    if (result != null && result['complete'] != null && result['complete']) {
      return SendSMSResult.complete;
    }
    if (result != null && result['canceled'] != null && result['canceled']) {
      return SendSMSResult.canceled;
    }
    return SendSMSResult.error ;
  }
}

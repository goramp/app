import 'dart:async';
import 'dart:convert';
import 'utils.dart';
import "../models/index.dart";

class EventFixtures {
  static Future<List<CallLink>> getUsers() async {
    final rawData = await loadAsset('assets/data/events.json');
    final List resData = json.decode(rawData);
    return resData
        .map<CallLink>(
            (event) => CallLink.fromMap(event.cast<String, dynamic>()))
        .toList();
  }
}

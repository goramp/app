import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:universal_platform/universal_platform.dart';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanoid/nanoid.dart';
import 'push_id_generator.dart';

const alphabet =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

Map<String, dynamic>? asStringKeyedMap(Map<dynamic, dynamic>? map) {
  if (map == null) return null;
  if (map is Map<String, dynamic>) {
    return map;
  } else {
    return Map<String, dynamic>.from(map);
  }
}

DateTime? parseDate(dynamic date) {
  if (date is DateTime) {
    return date;
  } else if (date is int) {
    return DateTime.fromMillisecondsSinceEpoch(date);
  } else if (date is String) {
    return DateTime.parse(date);
  } else if (date is Timestamp) {
    return date.toDate();
  }
  return null;
}

String pluralize(num count, String singular) {
  return count == 1 ? '$count $singular' : '$count ${singular}s';
}

String changeTextToInitials(String text) {
  if (text != null && text.length > 0) {
    if (text.length <= 2) {
      return text;
    }
    List<String> split = text.split(" ");
    String result = split[0].substring(0, 1);
    if (split.length >= 2) {
      result += split[1].substring(0, 1);
    }
    return result;
  } else {
    return '';
  }
}

toTitleCase(String? str) {
  final String s = str ?? '';
  return s.split(' ').map((s) => _upperCaseFirstLetter(s)).join(' ');
}

String _upperCaseFirstLetter(String word) {
  if (word.isEmpty) {
    return word;
  }
  return '${word.substring(0, 1).toUpperCase()}${word.substring(1)}';
}

bool isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

String generateUniqueId() {
  return PushIdGenerator.generatePushChildName();
}

String generateShareId() {
  return customAlphabet(alphabet, 10);
}

bool equals(List? list1, List? list2) {
  if (identical(list1, list2)) return true;
  if (list1 == null || list2 == null) return false;
  int length = list1.length;
  if (length != list2.length) return false;
  for (int i = 0; i < length; i++) {
    if (list1[i] is List && list2[i] is List) {
      if (!equals(list1[i] as List?, list2[i] as List?)) return false;
    } else {
      if (list1[i] != list2[i]) return false;
    }
  }
  return true;
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

Future<String?> calculateMD5SumAsync(String filePath) async {
  String ret = "";
  var file = File(filePath);
  if (await file.exists()) {
    try {
      if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        //ret = await Md5Plugin.getMD5WithPath(filePath);
        print('MD5 Hash from NATIVE PLUGIN: $ret');
      }
      var hash = await md5.bind(file.openRead()).first;
      ret = base64.encode(hash.bytes);
      print('MD5 Hash from CRYPTO: $ret');
    } catch (exception) {
      print("Unable to evaluate the MD5 sum :$exception");
      return null;
    }
  } else {
    print(
        "'" + filePath + "' doesn't exits so unable to evaluate its MD5 sum.");
    return null;
  }
  return ret;
}

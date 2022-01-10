import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

class StorageService {
  const StorageService();

  static Future<void> write(
      {required String key,
      required String? value,
      String? iosAppGroupId}) async {
    if (UniversalPlatform.isWeb) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setString(key, value!);
    } else {
      final FlutterSecureStorage storage = FlutterSecureStorage();
      return storage.write(key: key, value: value);
    }
  }

  static Future<String?> read(
      {required String key, String? iosAppGroupId}) async {
    if (UniversalPlatform.isWeb) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      return preferences.getString(key);
    } else {
      final FlutterSecureStorage storage = FlutterSecureStorage();
      return storage.read(key: key);
    }
  }

  static Future<void> delete(
      {required String key, String? iosAppGroupId}) async {
    if (UniversalPlatform.isWeb) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.remove(key);
    } else {
      final FlutterSecureStorage storage = FlutterSecureStorage();
      return storage.delete(key: key);
    }
  }

  static Future<void> deleteAll() async {
    if (UniversalPlatform.isWeb) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.clear();
    } else {
      final FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.deleteAll();
    }
  }
}

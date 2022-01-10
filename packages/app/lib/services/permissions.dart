import 'dart:async';
import 'package:flutter/services.dart';

enum PermissionStatus { authorized, denied, restricted, undetermined }

enum PermissionType {
  location,
  camera,
  microphone,
  photo,
  contacts,
  event,
  reminder,
  bluetooth,
  notification,
  backgroundRefresh,
  speechRecognition,
  mediaLibrary,
  motion
}

const permissionTypes = [
  PermissionType.location,
  PermissionType.camera,
  PermissionType.microphone,
  PermissionType.photo,
  PermissionType.contacts,
  PermissionType.event,
  PermissionType.reminder,
  PermissionType.bluetooth,
  PermissionType.notification,
  PermissionType.backgroundRefresh,
  PermissionType.speechRecognition,
  PermissionType.mediaLibrary,
  PermissionType.motion
];

const PERMISSION_DEFAULTS = {
  PermissionType.location: 'whenInUse',
  PermissionType.notification: ['alert', 'badge', 'sound'],
};

class Rationale {
  final String title;
  final String message;
  Rationale(this.title, this.message);
}

class CheckOptions {
  final String type;
  CheckOptions(this.type);
}

class RequestOptions {
  final String type;
  final Rationale? rationale;
  RequestOptions(this.type, {this.rationale});
}

String permissionTypeToString(PermissionType type) {
  switch (type) {
    case PermissionType.location:
      return 'location';
    case PermissionType.camera:
      return 'camera';
    case PermissionType.microphone:
      return 'microphone';
    case PermissionType.photo:
      return 'photo';
    case PermissionType.contacts:
      return 'contacts';
    case PermissionType.event:
      return 'event';
    case PermissionType.reminder:
      return 'reminder';
    case PermissionType.bluetooth:
      return 'bluetooth';
    case PermissionType.notification:
      return 'notification';
    case PermissionType.backgroundRefresh:
      return 'backgroundRefresh';
    case PermissionType.speechRecognition:
      return 'speechRecognition';
    case PermissionType.mediaLibrary:
      return 'mediaLibrary';
    case PermissionType.motion:
      return 'motion';
  }
}

PermissionStatus permissionStatusFromString(String? status) {
  switch (status) {
    case 'authorized':
      return PermissionStatus.authorized;
    case 'denied':
      return PermissionStatus.denied;
    case 'restricted':
      return PermissionStatus.restricted;
    case 'undetermined':
      return PermissionStatus.undetermined;
  }
  return PermissionStatus.undetermined;
}

class PermissionsPlugin {
  static const MethodChannel _channel =
      const MethodChannel('PermissionsPlugin');

  static Future<bool?> canOpenSettings() async {
    return _channel.invokeMethod('canOpenSettings');
  }

  static Future<void> openSetting() async {
    _channel.invokeMethod('openSetting');
  }

  static List<PermissionType> getTypes() => permissionTypes;

  static Future<PermissionStatus> check(PermissionType permission,
      {CheckOptions? optionsType}) async {
    String? status = await _channel.invokeMethod('getPermissionStatus', {
      'permission': permissionTypeToString(permission),
      'options': optionsType?.type ?? PERMISSION_DEFAULTS[permission]
    });
    return permissionStatusFromString(status);
  }

  static Future<PermissionStatus> request(PermissionType permission,
      {RequestOptions? requestOption}) async {
    String? status = await _channel.invokeMethod('requestPermission', {
      'permission': permissionTypeToString(permission),
      'options': requestOption?.type ?? PERMISSION_DEFAULTS[permission]
    });
    return permissionStatusFromString(status);
  }

  static Future<List<PermissionStatus>> checkMultiple(
      List<PermissionType> permissions) async {
    List<PermissionStatus> results = await Future.wait(permissions
        .map<Future<PermissionStatus>>((permission) => check(permission))
        .toList());
    return results;
  }
}

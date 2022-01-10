import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:bloc/bloc.dart';

enum RequestPermissionType {
  mic,
  camera,
  contacts,
  photos,
  storage,
}

abstract class PermissionAction extends Equatable {}

class RequestPermission extends PermissionAction {
  final RequestPermissionType permissionType;
  RequestPermission(this.permissionType);
  List<Object> get props => [permissionType];
  @override
  String toString() => '$runtimeType($permissionType)';
}

class RequestMultiplePermission extends PermissionAction {
  final List<RequestPermissionType> permissions;
  RequestMultiplePermission(this.permissions);
  List<Object> get props => [permissions];
  @override
  String toString() => '$runtimeType($permissions)';
}

class CheckPermission extends PermissionAction {
  final RequestPermissionType permissionType;
  CheckPermission(this.permissionType);

  List<Object> get props => [permissionType];
  @override
  String toString() => '$runtimeType($permissionType)';
}

class PermissionState extends Equatable {
  final PermissionStatus? microphoneStatus;
  final PermissionStatus? cameraStatus;
  final PermissionStatus? contactStatus;
  final PermissionStatus? photoStatus;
  final PermissionStatus? storageStatus;

  static bool isPermissionGranted(PermissionStatus? status) {
    return status != null && status == PermissionStatus.granted;
  }

  static bool isPermissionDenied(PermissionStatus? status) {
    return status != null && status == PermissionStatus.denied;
  }

  bool get hasMicPermision => isPermissionGranted(microphoneStatus);
  bool get hasCameraPermision => isPermissionGranted(cameraStatus);
  bool get hasContactsPermision => isPermissionGranted(contactStatus);
  bool get hasPhotosPermision => isPermissionGranted(photoStatus);
  bool get hasStoragePermision => isPermissionGranted(photoStatus);

  static Future<bool> canRequestShowPermission(
      RequestPermissionType permissionType) async {
    if (UniversalPlatform.isIOS) {
      return true;
    } else {
      return toNativePermission(permissionType).shouldShowRequestRationale;
    }
  }

  static Permission toNativePermission(RequestPermissionType permission) {
    switch (permission) {
      case RequestPermissionType.camera:
        return Permission.camera;
      case RequestPermissionType.contacts:
        return Permission.contacts;
      case RequestPermissionType.mic:
        return Permission.microphone;
      case RequestPermissionType.photos:
        return Permission.photos;
      case RequestPermissionType.storage:
        return Permission.storage;
    }
    throw StateError("Invalid permission: $permission");
  }

  PermissionState(
      {this.microphoneStatus,
      this.cameraStatus,
      this.contactStatus,
      this.photoStatus,
      this.storageStatus});

  List<Object?> get props => [
        microphoneStatus,
        cameraStatus,
        contactStatus,
        photoStatus,
        storageStatus
      ];

  PermissionState.uninitialized()
      : this.microphoneStatus = null,
        this.cameraStatus = null,
        this.contactStatus = null,
        this.photoStatus = null,
        this.storageStatus = null;

  PermissionState copyWith({
    PermissionStatus? microphoneStatus,
    PermissionStatus? cameraStatus,
    PermissionStatus? contactStatus,
    PermissionStatus? photoStatus,
    PermissionStatus? storageStatus,
  }) {
    return PermissionState(
        microphoneStatus: microphoneStatus ?? this.microphoneStatus,
        cameraStatus: cameraStatus ?? this.cameraStatus,
        contactStatus: contactStatus ?? this.contactStatus,
        photoStatus: photoStatus ?? this.photoStatus,
        storageStatus: storageStatus ?? this.storageStatus);
  }

  String toString() =>
      'PermissionState { microphoneStatus: $microphoneStatus, cameraStatus: $cameraStatus , contactStatus: $contactStatus, photoStatus: $photoStatus, storageStatus: $storageStatus }';
}

class PermissionBloc extends Bloc<PermissionAction, PermissionState>
    with WidgetsBindingObserver {
  PermissionBloc(): super(PermissionState.uninitialized()) {
    WidgetsBinding.instance!.addObserver(this);
    fetchPermissions();
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance!.removeObserver(this);
    super.close();
  }

  fetchPermissions() {
    add(CheckPermission(RequestPermissionType.camera));
    add(CheckPermission(RequestPermissionType.mic));
    add(CheckPermission(RequestPermissionType.contacts));
    add(CheckPermission(RequestPermissionType.photos));
    add(CheckPermission(RequestPermissionType.storage));
    print("fetch permissions");
  }

  didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    switch (appLifecycleState) {
      case AppLifecycleState.inactive:
        {
          return;
        }
      case AppLifecycleState.resumed:
        {
          fetchPermissions();
          return;
        }
      default:
        return;
    }
  }

  Future<PermissionStatus> _getPermission(
      Permission permissionGroup) async {
    return permissionGroup.status;
  }

  Stream<PermissionState> _handleCheckPermission(
      CheckPermission action) async* {
    yield* _getState(
        action.permissionType,
        await _getPermission(
            PermissionState.toNativePermission(action.permissionType)));
  }

  Stream<PermissionState> _getState(
      RequestPermissionType permissionType, PermissionStatus? status) async* {
    PermissionState currentState = state;
    if (permissionType == RequestPermissionType.camera) {
      currentState = state.copyWith(cameraStatus: status);
    }
    if (permissionType == RequestPermissionType.mic) {
      currentState = state.copyWith(microphoneStatus: status);
    }
    if (permissionType == RequestPermissionType.contacts) {
      currentState = state.copyWith(contactStatus: status);
    }
    if (permissionType == RequestPermissionType.photos) {
      currentState = state.copyWith(photoStatus: status);
    }
    if (permissionType == RequestPermissionType.storage) {
      currentState = state.copyWith(storageStatus: status);
    }
    yield currentState;
  }

  Stream<PermissionState> _handleSingleRequestPermission(
      RequestPermissionType permission) async* {
    Permission permissionGroup =
        PermissionState.toNativePermission(permission);
    PermissionStatus? status = await _getPermission(permissionGroup);
    Map<Permission, PermissionStatus>? result;
    if (PermissionState.isPermissionGranted(status)) {
      yield* _getState(permission, status);
      return;
    } else {
      if (UniversalPlatform.isAndroid) {
        result =
            await [permissionGroup].request();
        status = result[permissionGroup];
        if (PermissionState.isPermissionDenied(status) &&
            !await permissionGroup.shouldShowRequestRationale) {
          openAppSettings();
        }
      } else {
        if (PermissionState.isPermissionDenied(status)) {
          openAppSettings();
        } else {
          result = await [permissionGroup].request();
        }
      }
    }
    if (result == null) {
      return;
    }
    yield* _handlePermissionResult(result);
  }

  Stream<PermissionState> _handlePermissionResult(
      Map<Permission, PermissionStatus> result) async* {
    PermissionState currentState = state;
    result.forEach((Permission group, PermissionStatus status) {
      if (group == Permission.camera) {
        currentState = state.copyWith(cameraStatus: status);
      }
      if (group == Permission.microphone) {
        currentState = state.copyWith(microphoneStatus: status);
      }
      if (group == Permission.contacts) {
        currentState = state.copyWith(contactStatus: status);
      }
      if (group == Permission.photos) {
        currentState = state.copyWith(photoStatus: status);
      }
      if (group == Permission.storage) {
        currentState = state.copyWith(storageStatus: status);
      }
    });
    yield currentState;
  }

  Stream<PermissionState> _handleRequestPermission(
      List<RequestPermissionType> permissions) async* {
    List<Permission> perm =
        permissions.map<Permission>((RequestPermissionType perm) {
      return PermissionState.toNativePermission(perm);
    }).toList();
    Map<Permission, PermissionStatus> nativePermissions = await perm.request();
    yield* _handlePermissionResult(nativePermissions);
  }

  @override
  Stream<PermissionState> mapEventToState(PermissionAction action) async* {
    if (action is CheckPermission) {
      yield* _handleCheckPermission(action);
    }
    if (action is RequestPermission) {
      yield* _handleSingleRequestPermission(action.permissionType);
    }
    if (action is RequestMultiplePermission) {
      yield* _handleRequestPermission(action.permissions);
    }
  }
}

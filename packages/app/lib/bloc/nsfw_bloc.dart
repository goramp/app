// import 'dart:async';
// import 'package:goramp/services/index.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import '../app_config.dart';
// import '../utils/index.dart';

// /// [FirebaseHttpFileService] is another common file service which parses a
// /// firebase reference into, to standard url which can be passed to the
// /// standard [HttpFileService].
// class RemoteModelHttpFileService extends HttpFileService {
//   @override
//   Future<FileServiceResponse> get(String url,
//       {Map<String, String> headers = const {}}) async {
//     var ref = FirebaseStorage.instance.ref().child(url);
//     var _url = await ref.getDownloadURL() as String;

//     return super.get(_url);
//   }
// }

// class RemoteModelCacheManager extends BaseCacheManager {
//   static const key = 'remote_model_cache';

//   static RemoteModelCacheManager _instance;

//   factory RemoteModelCacheManager() {
//     _instance ??= RemoteModelCacheManager._();
//     return _instance;
//   }

//   RemoteModelCacheManager._()
//       : super(key,
//             fileService: RemoteModelHttpFileService(),
//             maxAgeCacheObject: Duration(days: 1000));

//   @override
//   Future<String> getFilePath() async {
//     var directory = await getApplicationDocumentsDirectory();
//     return p.join(directory.path, key);
//   }
// }

// class NSFWBloc {
//   final ErrorReporter reporter;
//   StreamSubscription<auth.User> _authSubscription;
//   final AppConfig config;
//   String _modelFilePath;
//   String _modelClassesFilePath;

//   NSFWBloc(this.reporter, this.config) {
//     _authSubscription =
//         auth.FirebaseAuth.instance.authStateChanges().listen(this._handleAuth);
//   }

//   String get modelFilePath => _modelFilePath;
//   String get modelClassesFilePath => _modelClassesFilePath;

//   _fetchRemoteModel() async {
//     try {
//       // _modelFilePath =
//       //     await preferences.read(key: config.modelFileRemoteConfig);
//       // if (_modelFilePath != null) {
//       //   print('modelFileUrl downloaded: $_modelFilePath');
//       //   return;
//       // }
//       final String modelFileName = config.defaultModelFileRemoteConfig;
//       if (modelFileName == null) {
//         return;
//       }
//       print('modelFileName: $modelFileName');
//       var file = await RemoteModelCacheManager().getSingleFile(modelFileName);
//       _modelFilePath = file.path;
//       await StorageService.write(
//           key: config.modelFileRemoteConfig,
//           value: _modelFilePath,
//           iosAppGroupId: config.iosAppGroupId);
//       print("modelFileUrl: ${file.path}");
//     } catch (error) {
//       print('error: $error');
//     }
//   }

//   _fetchRemoteModelClasses() async {
//     try {
//       // _modelClassesFilePath =
//       //     await preferences.read(key: config.modelFileRemoteConfig);
//       // if (_modelClassesFilePath != null) {
//       //   print('modelClassFileUrl downloaded: $_modelClassesFilePath');
//       //   return;
//       // }
//       final String modelClassName = config.defaultModelClassFileRemoteConfig;
//       if (modelClassName == null) {
//         return;
//       }
//       var file = await RemoteModelCacheManager().getSingleFile(modelClassName);
//       _modelClassesFilePath = file.path;
//       await StorageService.write(
//           key: config.modelFileRemoteConfig,
//           value: _modelClassesFilePath,
//           iosAppGroupId: config.iosAppGroupId);
//       print("modelClassFileUrl: ${file.path}");
//     } catch (error) {
//       print('error: $error');
//     }
//   }

//   _handleAuth(auth.User fbUser) async {
//     if (fbUser != null) {
//       // _fetchRemoteModel();
//       // _fetchRemoteModelClasses();
//     }
//   }

//   void dispose() {
//     _authSubscription.cancel();
//   }
// }

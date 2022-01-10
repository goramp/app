import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FileAsset extends Equatable {
  final XFile? file;
  final String? id;
  final String? remoteUrl;
  final UploadTask? uploadTask;
  List get props => [file, id, uploadTask, remoteUrl];

  FileAsset({this.file, this.id, this.uploadTask, this.remoteUrl});

  FileAsset.fromMap(Map m)
      : file = m["path"] != null ? XFile(m["path"]) : null,
        id = m["id"],
        remoteUrl = m["remoteUrl"],
        uploadTask = m['uploadTask'];

  FileAsset copyWith({XFile? file, UploadTask? uploadTask, String? remoteUrl}) {
    return FileAsset(
      file: file ?? this.file,
      id: id ?? this.id,
      uploadTask: uploadTask ?? this.uploadTask,
      remoteUrl: remoteUrl ?? this.remoteUrl,
    );
  }
}

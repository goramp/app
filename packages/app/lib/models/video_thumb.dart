import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class VideoAsset extends Equatable {
  final String? id;
  final XFile? videoFile;
  final VideoThumb? thumbnail;
  final String? mimeType;
  List get props => [id, videoFile, thumbnail, mimeType];
  VideoAsset(
      {this.id, this.videoFile, this.thumbnail, this.mimeType = "video/mp4"});

  VideoAsset.fromMap(Map m)
      : id = m["id"],
        videoFile = m["path"] != null ? XFile(m["path"]) : null,
        thumbnail =
            m["thumbnail"] != null ? VideoThumb.fromMap(m["thumbnail"]) : null,
        mimeType = m['mimeType'];

  VideoAsset copyWith(
      {String? id,
      XFile? videoFile,
      VideoThumb? thumbnail,
      bool? requiresReview,
      String? mimeType}) {
    return VideoAsset(
      id: id ?? this.id,
      videoFile: videoFile ?? this.videoFile,
      thumbnail: thumbnail ?? this.thumbnail,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': videoFile?.path,
      'thumbnail': thumbnail?.toMap(),
      'mimeType': mimeType
    };
  }
}

class VideoThumb {
  VideoThumb({this.width, this.height, this.data});

  int? width;
  int? height;
  Uint8List? data;

  VideoThumb.fromMap(Map m) {
    width = m["width"];
    height = m["height"];
    data = m["data"] != null
        ? m["data"] is String
            ? base64.decode(m["data"])
            : m["data"]
        : null;
  }

  @override
  String toString() {
    return "width:$width, height:$height, length=${data!.length}";
  }

  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
      'data': data != null ? base64.encode(data!) : null,
    };
  }
}

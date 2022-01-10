import 'dart:io';
import 'package:equatable/equatable.dart';
import '../utils/index.dart';


class ImageMedia extends Equatable {
  final String? displayUrl;
  final String? thumbnailUrl;
  final String? name;
  final String? blurHash;

  ImageMedia({
    this.displayUrl,
    this.thumbnailUrl,
    this.blurHash,
    this.name,
  });


  List<Object?> get props => [displayUrl, thumbnailUrl, blurHash, name];

  factory ImageMedia.fromMap(Map<String, dynamic> map) {
    return ImageMedia(
      displayUrl: map['displayUrl'],
      thumbnailUrl: map['thumbnailUrl'],
      blurHash: map['blurHash'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayUrl': displayUrl,
      'thumbnailUrl': thumbnailUrl,
      'blurHash': blurHash,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}


class ImageItem extends Equatable {
  final String? url;
  final int? width;
  final int? height;

  ImageItem({
    this.url,
    this.width,
    this.height,
  });

  double get aspectRatio {
    if (height == 0) return 0;
    return width! / height!;
  }

  List<Object?> get props => [url, width, height];

  factory ImageItem.fromMap(Map<String, dynamic> map) {
    return ImageItem(
      url: map['url'],
      width: map['width'],
      height: map['height'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'width': width,
      'height': height,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

// class Video extends Equatable {
//   Video({
//     this.thumbnailImage,
//     this.displayImage,
//     this.media,
//     this.localFile,
//     this.enabled: false,
//   });

//   List<Object> get props =>
//       [thumbnailImage, displayImage, media, localFile, enabled];
//   final ImageItem thumbnailImage;
//   final ImageItem displayImage;
//   final VideoMedia media;
//   final bool enabled;
//   final File localFile;
//   factory Video.fromMap(Map<String, dynamic> map) {
//     return Video(
//         media: map['media'] != null
//             ? VideoMedia.fromMap(asStringKeyedMap(map['media']))
//             : null,
//         thumbnailImage: map['thumbnailImage'] != null
//             ? ImageItem.fromMap(asStringKeyedMap(map['thumbnailImage']))
//             : null,
//         enabled: map['enabled'] ?? false,
//         displayImage: map['displayImage'] != null
//             ? ImageItem.fromMap(asStringKeyedMap(map['displayImage']))
//             : null,
//         localFile: null);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'media': media?.toMap(),
//       'thumbnailImage': thumbnailImage?.toMap(),
//       'displayImage': displayImage?.toMap(),
//       'enabled': enabled,
//     };
//   }

//   @override
//   String toString() {
//     return '${toMap()}';
//   }
// }

class Photo extends Equatable {
  Photo({
    required this.original,
    this.thumbnail,
    this.display,
    this.enabled,
    this.localFile,
  });

  List<Object?> get props => [original, thumbnail, display, localFile, enabled];

  final ImageItem? thumbnail;
  final ImageItem? display;
  final ImageItem? original;
  final bool? enabled;
  final File? localFile;

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
        original: map['original'] != null
            ? ImageItem.fromMap(asStringKeyedMap(map['original'])!)
            : null,
        thumbnail: map['thumbnail'] != null
            ? ImageItem.fromMap(asStringKeyedMap(map['thumbnail'])!)
            : null,
        enabled: map['enabled'],
        display: map['display'] != null
            ? ImageItem.fromMap(asStringKeyedMap(map['display'])!)
            : null,
        localFile: null);
  }

  Map<String, dynamic> toMap() {
    return {
      'original': original?.toMap(),
      'thumbnail': thumbnail?.toMap(),
      'display': display?.toMap(),
      'enabled': enabled,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}

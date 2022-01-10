import 'package:equatable/equatable.dart';
import 'package:goramp/utils/index.dart';

class VideoFrame extends Equatable {
  final String? name;
  final String? url;

  VideoFrame({
    this.name,
    this.url,
  });

  List<Object?> get props => [
        url,
        name,
      ];

  factory VideoFrame.fromMap(Map<String, dynamic> map) {
    return VideoFrame(
      name: map['name'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class PredictionType extends Equatable {
  final String? className;
  final num? probability;
  PredictionType(this.className, this.probability);
  List get props => [className, probability];

  factory PredictionType.fromMap(Map<String, dynamic> map) {
    return PredictionType(map['className'], map['probability']);
  }

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'probability': probability,
    };
  }
}

class FrameAnalysis extends Equatable {
  final List<PredictionType>? predictions;
  final int? frameNumber;
  final String? thumbnailFileName;
  final String? displayFileName;
  final String? thumbnailUrl;
  final String? displayUrl;
  FrameAnalysis(
      {this.predictions,
      this.frameNumber,
      this.thumbnailUrl,
      this.displayUrl,
      this.thumbnailFileName,
      this.displayFileName});
  List get props => [predictions, frameNumber, thumbnailUrl];
  factory FrameAnalysis.fromMap(Map<String, dynamic> map) {
    return FrameAnalysis(
      predictions: map['predictions'] != null
          ? (map['predictions'] as List)
              .map(
                (e) => PredictionType.fromMap(
                  asStringKeyedMap(e)!,
                ),
              )
              .toList()
          : null,
      frameNumber: map['frameNumber'],
      thumbnailUrl: map['thumbnailUrl'],
      displayUrl: map['displayUrl'],
      thumbnailFileName: map['thumbnailFileName'],
      displayFileName: map['displayFileName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'predictions': predictions?.map((e) => e.toMap()).toList(),
      'frameNumber': frameNumber,
      'thumbnailUrl': thumbnailUrl,
      'displayUrl': displayUrl,
      'thumbnailFileName': thumbnailFileName,
      'displayFileName': displayFileName,
    };
  }
}

class Video extends Equatable {
  final num? width;
  final num? height;
  final num? duration;
  final num? selectedFrameIndex;
  final String? url;
  final String? captionDisplayUrl;
  final String? captionThumbnailUrl;
  final String? captionBlurHash;
  final String? name;
  final VideoFrame? thumbnail;
  final VideoFrame? display;
  final List<FrameAnalysis>? frames;

  Video({
    this.width,
    this.height,
    this.duration,
    this.url,
    this.name,
    this.thumbnail,
    this.display,
    this.frames,
    this.selectedFrameIndex,
    this.captionThumbnailUrl,
    this.captionDisplayUrl,
    this.captionBlurHash,
  });

  List<Object?> get props => [
        width,
        height,
        duration,
        url,
        name,
        thumbnail,
        display,
        frames,
        selectedFrameIndex,
        captionDisplayUrl,
        captionThumbnailUrl,
        captionBlurHash
      ];

  double get aspectRatio {
    if (width == null || height == null || width == 0 || height == 0) {
      return 1.0;
    }
    return width! / height!;
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      width: map['width'],
      height: map['height'],
      duration: map['duration'],
      url: map['url'],
      name: map['name'],
      selectedFrameIndex: map['selectedFrameIndex'],
      thumbnail: map['thumbnail'] != null
          ? VideoFrame.fromMap(asStringKeyedMap(map['thumbnail'])!)
          : null,
      display: map['display'] != null
          ? VideoFrame.fromMap(asStringKeyedMap(map['display'])!)
          : null,
      frames: map['frames'] != null
          ? (map['frames'] as List)
              .map(
                (e) => FrameAnalysis.fromMap(
                  asStringKeyedMap(e)!,
                ),
              )
              .toList()
          : null,
      captionDisplayUrl: map['captionDisplayUrl'],
      captionThumbnailUrl: map['captionThumbnailUrl'],
      captionBlurHash: map['captionBlurHash'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
      'duration': duration,
      'url': url,
      'name': name,
      'thumbnail': thumbnail?.toMap(),
      'display': display?.toMap(),
      'frames': frames?.map((e) => e.toMap()).toList() ?? [],
      'selectedFrameIndex': selectedFrameIndex,
      'captionDisplayUrl': captionDisplayUrl,
      'captionThumbnailUrl': captionThumbnailUrl,
      'captionBlurHash': captionBlurHash,
    };
  }

  Video copyWith({
    num? width,
    num? height,
    num? duration,
    num? selectedFrameIndex,
    String? url,
    String? name,
    VideoFrame? thumbnail,
    VideoFrame? display,
    List<FrameAnalysis>? frames,
    String? captionDisplayUrl,
    String? captionThumbnailUrl,
    String? captionBlurHash,
  }) {
    return Video(
      width: width ?? this.width,
      height: height ?? this.height,
      duration: duration ?? this.duration,
      selectedFrameIndex: selectedFrameIndex ?? this.selectedFrameIndex,
      url: url ?? this.url,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      display: display ?? this.display,
      frames: frames ?? this.frames,
      captionDisplayUrl: captionDisplayUrl ?? this.captionDisplayUrl,
      captionThumbnailUrl: captionThumbnailUrl ?? this.captionThumbnailUrl,
      captionBlurHash: captionBlurHash ?? this.captionBlurHash,
    );
  }
}

enum VideoProcessingStatus {
  started,
  pending,
  inProgress,
  completed,
  failed,
}

enum VideoProcessingStage {
  processing,
  //analyzing,
  previewing,
}

class VideoProcessing extends Equatable {
  final String? id;
  final VideoProcessingStatus? status;
  final VideoProcessingStage? stage;
  final String? errorMessage;
  final num? progress;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? errorAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Video? video;

  VideoProcessing({
    this.id,
    this.status,
    this.stage,
    this.errorMessage,
    this.progress,
    this.startedAt,
    this.completedAt,
    this.errorAt,
    this.createdAt,
    this.updatedAt,
    this.video,
  });

  static String stringFromVideoProcessingStatus(VideoProcessingStatus status) {
    switch (status) {
      case VideoProcessingStatus.pending:
        return 'pending';
      case VideoProcessingStatus.inProgress:
        return 'inProgress';
      case VideoProcessingStatus.completed:
        return 'completed';
      case VideoProcessingStatus.failed:
        return 'failed';
      case VideoProcessingStatus.started:
        return 'started';
    }
  }

  static VideoProcessingStatus stringToVideoProcessingStatus(String? status) {
    switch (status) {
      case 'pending':
        return VideoProcessingStatus.pending;
      case 'inProgress':
        return VideoProcessingStatus.inProgress;
      case 'completed':
        return VideoProcessingStatus.completed;
      case 'failed':
        return VideoProcessingStatus.failed;
      case 'started':
        return VideoProcessingStatus.started;
    }
    throw StateError('Invalid status');
  }

  static String stringFromVideoProcessingStage(VideoProcessingStage stage) {
    switch (stage) {
      case VideoProcessingStage.previewing:
        return 'previewing';
      case VideoProcessingStage.processing:
        return 'processing';
    }
  }

  static VideoProcessingStage stringToVideoProcessingStage(String? stage) {
    switch (stage) {
      case 'previewing':
        return VideoProcessingStage.previewing;
      case 'processing':
        return VideoProcessingStage.processing;
    }
    throw StateError('Invalid status');
  }

  List<Object?> get props => [
        id,
        status,
        stage,
        errorMessage,
        progress,
        startedAt,
        completedAt,
        errorAt,
        createdAt,
        updatedAt,
        video,
      ];

  factory VideoProcessing.fromMap(id, Map<String, dynamic> map) {
    return VideoProcessing(
      id: id,
      status: map['status'] != null
          ? stringToVideoProcessingStatus(map['status'])
          : null,
      stage: map['stage'] != null
          ? stringToVideoProcessingStage(map['stage'])
          : null,
      errorMessage: map['errorMessage'],
      progress: map['progress'],
      completedAt: parseDate(map['completedAt']),
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      startedAt: parseDate(map['startedAt']),
      errorAt: parseDate(map['errorAt']),
      video: map['video'] != null ? Video.fromMap(map['video']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status':
          status != null ? stringFromVideoProcessingStatus(status!) : null,
      'stage': stage != null ? stringFromVideoProcessingStage(stage!) : null,
      'errorMessage': errorMessage,
      'progress': progress,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'startedAt': startedAt?.millisecondsSinceEpoch,
      'errorAt': startedAt?.millisecondsSinceEpoch,
    };
  }
}

// import 'dart:async';
// import 'package:flutter/widgets.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:bloc/bloc.dart';
// import '../models/index.dart';

// final defaultAudioConstraint = AudioConstraint();

// class VideoTrackRouteObserver implements RouteAware {
//   MediaBloc<VideoTrack> _videoTrackBloc;
//   RouteObserver<ModalRoute> _observer;
//   Route _currentRoute;

//   void registerRouteObserver(RouteObserver<ModalRoute> routeObserver,
//       Route currentRoute, MediaBloc<VideoTrack> videoTrackBloc) {
//     _videoTrackBloc = videoTrackBloc;
//     _observer = routeObserver;
//     _currentRoute = currentRoute;
//     _observer?.unsubscribe(this);
//     _observer?.subscribe(this, _currentRoute);
//   }

//   void unRegisterRouteObserver() {
//     _observer?.unsubscribe(this);
//   }

//   @override
//   void didPushNext() {
//     UserMediaState state = _videoTrackBloc?.state;
//     if (state is MediaTrackInitialized) {
//       VideoTrack track = (state.track as VideoTrack);
//       track?.stop();
//       print("should stop camera");
//     }
//   }

//   @override
//   void didPopNext() {
//     UserMediaState state = _videoTrackBloc?.state;
//     if (state is MediaTrackInitialized) {
//       VideoTrack track = (state.track as VideoTrack);
//       track?.start();
//       print("should start camera");
//     }
//   }

//   /// Called when the current route has been pushed.
//   void didPush() {}

//   /// Called when the current route has been popped off.
//   void didPop() {}
// }

// class GetUserMedia extends Equatable {
//   final MediaType mediaType;
//   final MediaConstraint mediaConstraint;

//   GetUserMedia({this.mediaType, this.mediaConstraint})
//       : assert(mediaType != null),
//         assert(mediaConstraint != null);

//   const GetUserMedia.audio({MediaConstraint mediaConstraint})
//       : mediaType = MediaType.audio,
//         this.mediaConstraint = mediaConstraint ?? const AudioConstraint();

//   const GetUserMedia.video({MediaConstraint mediaConstraint})
//       : mediaType = MediaType.video,
//         this.mediaConstraint = mediaConstraint ?? const VideoConstraint();

//   List<Object> get props => [mediaType, mediaConstraint];

//   GetUserMedia copyWith(
//       {MediaType mediaType, MediaConstraint mediaConstraint}) {
//     return GetUserMedia(
//       mediaType: mediaType ?? this.mediaType,
//       mediaConstraint: mediaConstraint ?? this.mediaConstraint,
//     );
//   }
// }

// class MediaException implements Exception {
//   MediaType mediaType;
//   MediaException(this.mediaType, this.code, this.description);

//   String code;
//   String description;

//   @override
//   String toString() => '$runtimeType($code, $description)';
// }

// class VideoRenderer {
//   VideoRenderer(this.renderer, {this.initialized = false});
//   final RTCVideoRenderer renderer;
//   final bool initialized;
// }

// abstract class UserMediaAction extends Equatable {
//   UserMediaAction();
// }

// class InitializeMediaTrack extends UserMediaAction {
//   final GetUserMedia gum;
//   InitializeMediaTrack(this.gum);
//   List<Object> get props => [gum];
//   @override
//   String toString() => 'InitializeMediaTrack';
// }

// class UninitializeMediaTrack extends UserMediaAction {
//   List<Object> get props => [];
//   @override
//   String toString() => 'UninitializeMediaTrack';
// }

// class DeactivateMediaTrack extends UserMediaAction {
//   List<Object> get props => [];
//   @override
//   String toString() => 'DeactivateMediaTrack';
// }

// abstract class UserMediaState extends Equatable {}

// class MediaTrackInitialized extends UserMediaState {
//   final MediaStreamTrack track;
//   final GetUserMedia gum;
//   MediaTrackInitialized(this.track, this.gum);
//   List<Object> get props => [track, gum];
//   @override
//   String toString() => 'MediaTrackInitialized';
// }

// class MediaTrackUninitialized extends UserMediaState {
//   final String trackId;
//   MediaTrackUninitialized({this.trackId});
//   List<Object> get props => [trackId];
//   @override
//   String toString() => 'MediaTrackUninitialized';
// }

// class MediaTrackInactive extends UserMediaState {
//   final GetUserMedia gum;
//   MediaTrackInactive(this.gum);
//   List<Object> get props => [gum];
//   @override
//   String toString() => 'MediaTrackInactive';
// }

// class MediaTrackFailed extends UserMediaState {
//   final MediaException exception;
//   MediaTrackFailed(this.exception);
//   List<Object> get props => [exception];

//   @override
//   String toString() => 'MediaTrackFailed';
// }

// class MediaBloc<T extends MediaStreamTrack>
//     extends Bloc<UserMediaAction, UserMediaState> {
//   MediaStreamTrack track;
//   MediaBloc() : super(MediaTrackUninitialized());

//   @override
//   Future<void> close() async {
//     track?.dispose();
//     track = null;
//     super.close();
//   }

//   Future<MediaStreamTrack> _initializeTrack(GetUserMedia request) async {
//     try {
//       track?.dispose();
//       if (request.mediaType == MediaType.audio) {
//         track = await navigator.getUserMedia(mediaConstraints)
//             .createAudioTrack(request.mediaConstraint.toConstraintMap());
//       } else {
//         track = await navigator
//             .createVideoTrack(request.mediaConstraint.toConstraintMap());
//       }
//       return track;
//     } on GetUserMediaException catch (e) {
//       print(e.toString());
//       throw MediaException(request.mediaType, e.code, e.description);
//     }
//   }

//   @override
//   Stream<UserMediaState> mapEventToState(UserMediaAction event) async* {
//     print("event: $event");
//     try {
//       if (state is MediaTrackInitialized) {
//         if (event is DeactivateMediaTrack) {
//           await track?.dispose();
//           track = null;
//           final gum = (state as MediaTrackInitialized).gum;
//           yield MediaTrackInactive(gum);
//           return;
//         }
//       }
//       if (event is InitializeMediaTrack) {
//         MediaStreamTrack track;
//         track = await _initializeTrack(event.gum);
//         yield MediaTrackInitialized(track, event.gum);
//         return;
//       }
//       if (event is UninitializeMediaTrack) {
//         String id = track.id;
//         await track?.dispose();
//         track = null;
//         yield MediaTrackUninitialized(trackId: id);
//         return;
//       }
//     } on MediaException catch (error) {
//       yield MediaTrackFailed(error);
//     }
//   }
// }

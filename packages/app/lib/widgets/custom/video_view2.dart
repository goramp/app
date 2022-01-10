// import 'dart:async';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:recordly_webrtc/webrtc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../../bloc/index.dart';
// import '../../utils/index.dart';
// import '../styles/index.dart';

// const _offset = 16.0;

// class VideoViewTest extends StatefulWidget {
//   final WidgetBuilder builder;
//   VideoViewTest(this.builder, {Key key})
//       : assert(builder != null),
//         super(key: key);
//   @override
//   _VideoViewState createState() {
//     return _VideoViewState();
//   }
// }

// class _VideoViewState extends State<VideoViewTest>
//     with RouteAware, TickerProviderStateMixin {
//   RTCVideoRenderer _videoRenderer;
//   MediaBloc<VideoTrack> _videoTrackBloc;
//   MediaBloc<AudioTrack> _audioTrackBloc;
//   RouteObserver<ModalRoute> _observer;
//   PageRoute _myRoute;

//   final GlobalKey _backdropKey = GlobalKey(debugLabel: 'VideoCallLayout');
//   final GlobalKey _frontLayerKey = GlobalKey(debugLabel: 'FrontLayer');
//   VideoTrack _fullscreenVideoTrack;
//   VideoTrack _pipVideoTrack;
//   double _xPosition = _offset;
//   double _yPosition = _offset;

//   @override
//   void initState() {
//     super.initState();
//     _createBloc();
//     _initializeVideoRenderer();
//   }

//   void _createBloc() {
//     _videoTrackBloc = MediaBloc<VideoTrack>();
//     _videoTrackBloc?.add(InitializeMediaTrack(GetUserMedia.video()));
//     _audioTrackBloc = MediaBloc<AudioTrack>();
//     _audioTrackBloc?.add(InitializeMediaTrack(GetUserMedia.audio()));
//     _initCamera();
//     print("initialize video bloc");
//   }

//   void _disposeBloc() {
//     _videoTrackBloc?.close();
//     _videoTrackBloc = null;
//     _audioTrackBloc?.close();
//   }

//   void didChangeDependencies() {
//     _observer = Provider.of<RouteObserver<ModalRoute>>(context);
//     _myRoute = ModalRoute.of(context);
//     _observer?.unsubscribe(this);
//     _observer?.subscribe(this, _myRoute);
//     super.didChangeDependencies();
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

//   _initCamera() {
//     UserMediaState videoState = _videoTrackBloc?.state;
//     if (videoState is MediaTrackUninitialized) {
//       _videoTrackBloc?.add(InitializeMediaTrack(GetUserMedia.video()));
//     }
//     if (videoState is MediaTrackInitialized) {
//       VideoTrack track = (videoState.track as VideoTrack);
//       track?.start();
//     }
//   }

//   Future<void> _handleTrackFailure(MediaException error) async {
//     if (error.code == Constants.CAMERA_PERMISSION_ERROR_CODE) {
//       final message = "Please enable camera access to record.";
//       final SnackBarContent content = SnackBarContent(message: message);
//       BlocProvider.of<SnackbarBloc>(context).add(Show(content));
//     } else {
//       final message = "Camera Error";
//       final SnackBarContent content = SnackBarContent(message: message);
//       BlocProvider.of<SnackbarBloc>(context).add(Show(content));
//     }
//   }

//   void dispose() {
//     _observer?.unsubscribe(this);
//     _videoRenderer?.setTrack(null);
//     _videoRenderer?.dispose();
//     _videoRenderer = null;
//     _disposeBloc();
//     super.dispose();
//   }

//   Future<void> _initializeVideoRenderer() async {
//     try {
//       _videoRenderer?.dispose();
//       _videoRenderer = RTCVideoRenderer();
//       await _videoRenderer.initialize();
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }

//   Size get _frontLayerSize {
//     final RenderBox renderBox =
//         _frontLayerKey.currentContext.findRenderObject();
//     double width = math.max(0.0, renderBox.size.width);
//     double height = math.max(0.0, renderBox.size.height);
//     return Size(width, height);
//   }

//   Size get _backLayerSize {
//     final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
//     double width = math.max(0.0, renderBox.size.width);
//     double height = math.max(0.0, renderBox.size.height);
//     return Size(width, height);
//   }

//   _handlePanUpdate(DragUpdateDetails details) {
//     final frontSize = _frontLayerSize;
//     final backSize = _backLayerSize;
//     double x = _xPosition - details.delta.dx;
//     double y = _yPosition - details.delta.dy;
//     x = x.clamp(_offset, backSize.width - frontSize.width - _offset).toDouble();
//     y = y
//         .clamp(_offset, backSize.height - frontSize.height - _offset)
//         .toDouble();
//     setState(() {
//       _xPosition = x;
//       _yPosition = y;
//     });
//   }

//   _handlePanEnd(DragEndDetails details) {
//     final frontSize = _frontLayerSize;
//     final backSize = _backLayerSize;
//     final topRight =
//         Offset(_offset, backSize.height - frontSize.height - _offset);
//     final bottomRight = Offset(_offset, _offset); //add base height
//     final bottomLeft = Offset(
//         backSize.width - frontSize.width - _offset, _offset); //add base height
//     final topLeft = Offset(backSize.width - frontSize.width - _offset,
//         backSize.height - frontSize.height - _offset);
//     final sizes = [topRight, bottomRight, bottomLeft, topLeft];
//     Offset current = sizes[0];
//     double currentD;
//     for (int i = 0; i < sizes.length; ++i) {
//       final d = math.sqrt(math.pow((sizes[i].dx - _xPosition), 2) +
//           math.pow((sizes[i].dy - _yPosition), 2));
//       if (currentD == null) {
//         currentD = d;
//         current = sizes[i];
//         continue;
//       }
//       if (d < currentD) {
//         currentD = d;
//         current = sizes[i];
//       }
//     }
//     final double velY = details.velocity.pixelsPerSecond.dy / backSize.height;
//     final double velX = details.velocity.pixelsPerSecond.dx / backSize.width;
//     final double flingVelocity = velY + velX;
//     final controller = AnimationController(
//       duration: kThemeAnimationDuration,
//       value: 0.0,
//       vsync: this,
//     );
//     final tween =
//         Tween<Offset>(begin: Offset(_xPosition, _yPosition), end: current)
//             .chain(CurveTween(curve: Curves.fastOutSlowIn));
//     controller.addListener(() {
//       setState(() {
//         Offset val = tween.evaluate(controller);
//         _xPosition = val.dx;
//         _yPosition = val.dy;
//       });
//     });
//     controller
//         .fling(velocity: math.max(2.0, flingVelocity.abs()))
//         .whenCompleteOrCancel(
//           controller.dispose,
//         );
//     print(
//         "Drag ended: should snap to bottomX: ${current.dx}, bottomY: ${current.dy}, flingV: $flingVelocity");
//   }

//   Widget _buildRenderer() {
//     return ValueListenableBuilder(
//       valueListenable: _videoRenderer,
//       builder: (BuildContext context, VideoRendererValue value, Widget _) {
//         if (!value.initialized) return Container();
//         double textureWidth, textureHeight, aspectRatio;
//         if (value.rotation == 90 || value.rotation == 270) {
//           textureWidth = math.min(value.size.width, value.size.height);
//           textureHeight = math.max(value.size.width, value.size.height);
//           aspectRatio = textureWidth / textureHeight;
//         } else {
//           textureWidth = math.max(value.size.width, value.size.height);
//           textureHeight = math.min(value.size.width, value.size.height);
//           aspectRatio = textureWidth / textureHeight;
//         }
//         return AspectRatio(
//           aspectRatio: aspectRatio,
//           child: Texture(textureId: _videoRenderer.textureId),
//         );
//       },
//     );
//   }

//   Widget _buldVideo(UserMediaState state) {
//     if (state is MediaTrackInitialized) {
//       if (_videoRenderer == null) {
//         return Container();
//       } else {
//         _videoRenderer.setTrack(state.track as VideoTrack);
//         if (!state.track.value.running) {
//           VideoTrack track = (state.track as VideoTrack);
//           track?.start();
//         }
//       }
//     } else {
//       return Container();
//     }
//     return Positioned(
//       key: _frontLayerKey,
//       bottom: _yPosition,
//       right: _xPosition,
//       child: GestureDetector(
//         onPanUpdate: _handlePanUpdate,
//         onPanEnd: _handlePanEnd,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(0.0),
//           child: Container(
//             child: _buildRenderer(),
//             width: 72.0,
//             //height: 150.0,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.0),
//               boxShadow: <BoxShadow>[
//                 BoxShadow(
//                   spreadRadius: 2.0,
//                   blurRadius: 10.0,
//                   color: Colors.black26,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<MediaBloc<VideoTrack>>.value(
//       value: _videoTrackBloc,
//       child: BlocListener(
//         bloc: _videoTrackBloc,
//         listener: (BuildContext context, UserMediaState state) {
//           if (state is MediaTrackFailed) {
//             _handleTrackFailure(state.exception);
//           } else if (state is MediaTrackInitialized) {
//             if (!state.track.value.running) {
//               VideoTrack track = (state.track as VideoTrack);
//               track?.start();
//             }
//           }
//         },
//         child: BlocBuilder(
//           bloc: _videoTrackBloc,
//           builder: (BuildContext context, UserMediaState state) {
//             return Stack(
//               key: _backdropKey,
//               children: <Widget>[_buldVideo(state)],
//             );
//           },
//         ),
//       ),
//     );
//     //return Container();
//   }
// }

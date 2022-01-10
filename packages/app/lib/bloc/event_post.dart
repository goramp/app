// import 'dart:async';
// import 'dart:io';
// import 'package:meta/meta.dart';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/widgets.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import '../services/index.dart';
// import '../models/index.dart';
// import '../app_config.dart';

// enum EventPostFailure {
//   upload_failed,
//   update_failed,
// }

// @immutable
// abstract class EventPostAction extends Equatable {
//   EventPostAction();
// }

// class CreateEvent extends EventPostAction {
//   final CallLinkPost eventPost;
//   CreateEvent(this.eventPost);
//   List<Object> get props => [eventPost];
// }

// class UpdateEvent extends EventPostAction {
//   final CallLinkPost eventPost;
//   UpdateEvent(this.eventPost);
//   List<Object> get props => [eventPost];
// }

// class PendingEvent extends EventPostAction {
//   final CallLinkPost eventPost;
//   PendingEvent(this.eventPost);
//   List<Object> get props => [eventPost];
// }

// class ResumeEvent extends EventPostAction {
//   final CallLinkPost eventPost;
//   ResumeEvent(this.eventPost);
//   List<Object> get props => [eventPost];
// }

// class DeleteEvent extends EventPostAction {
//   final CallLinkPost eventPost;
//   DeleteEvent(this.eventPost);
//   List<Object> get props => [eventPost];
// }

// @immutable
// abstract class EventPostState extends Equatable {}

// class EventPostWaiting extends EventPostState {
//   List<Object> get props => [];
// }

// class EventPostUploading extends EventPostState {
//   final Task uploadTask;
//   final CallLinkPost callLinkPost;
//   EventPostUploading(this.callLinkPost, this.uploadTask);
//   List<Object> get props => [callLinkPost];
// }

// class EventPostCreating extends EventPostState {
//   final CallLinkPost eventPost;
//   EventPostCreating(this.eventPost);
//   List<Object> get props => [eventPost];
// }

// class EventPostSuccess extends EventPostState {
//   final CallLinkPost eventPost;
//   EventPostSuccess(this.eventPost);
//   List<Object> get props => [eventPost];
// }

// class EventPostFailed extends EventPostState {
//   final CallLinkPost eventPost;
//   final EventPostFailure failureCode;
//   EventPostFailed(this.eventPost, this.failureCode);
//   List<Object> get props => [eventPost, failureCode];
// }

// class EventPostBloc extends Bloc<EventPostAction, EventPostState> {
//   final AppConfig config;

//   EventPostBloc(this.config) : super(EventPostWaiting());

//   @override
//   Stream<EventPostState> mapEventToState(
//     EventPostAction event,
//   ) async* {
//     if (event is CreateEvent) {
//       yield* _createEvent(event.eventPost);
//     } else if (event is UpdateEvent) {
//       yield* _updateEvent(event.eventPost);
//     } else if (event is ResumeEvent) {
//       yield* _resumeEvent(event.eventPost);
//     } else if (event is PendingEvent) {
//       yield EventPostFailed(event.eventPost, EventPostFailure.update_failed);
//     } else if (event is DeleteEvent) {
//       EventService.removePendingEventPost();
//       await _cleanUp(event.eventPost);
//       yield EventPostWaiting();
//     } else {
//       yield EventPostWaiting();
//     }
//   }

//   Stream<EventPostState> handleCreateResume(CallLinkPost eventPost) async* {
//     EventService eventService = EventService(config);
//     // final videoFile = await eventPost.localVideo.videoFile;
//     // if (!videoFile) {
//     //   EventService.removePendingEventPost();
//     //   print(
//     //       "video file does  not exist: ${eventPost.localVideo.videoFile.path}");
//     //   yield EventPostWaiting();
//     //   return;
//     // }
//     try {
//       if (eventPost.event.createdAt == null) {
//         EventService.createEvent(eventPost);
//       } else {
//         EventService.updateEventPost(eventPost);
//       }
//       Task task = eventService.uploadEvent(eventPost);
//       yield EventPostUploading(eventPost, task);

//       final snapshot = await task;

//       // print("uploadTask.isComplete///${uploadTask.lastSnapshot?.error}");
//       // print("uploadTask.isCanceled///${uploadTask.isCanceled}");
//       // print("uploadTask.isSuccessful///${uploadTask.isSuccessful}");
//       if (snapshot.state == TaskState.canceled ||
//           snapshot.state == TaskState.error) {
//         yield EventPostFailed(eventPost, EventPostFailure.upload_failed);
//         return;
//       } else if (snapshot.state == TaskState.success) {
//         yield EventPostSuccess(eventPost);
//         EventService.removePendingEventPost();
//         await _cleanUp(eventPost);
//         yield EventPostWaiting();
//         return;
//       }
//     } catch (error) {
//       print("error: $error");
//       yield EventPostFailed(eventPost, EventPostFailure.update_failed);
//     }
//   }

//   Future<void> _cleanUp(CallLinkPost eventPost) async {
//     // File videoFile = eventPost.localVideo.videoFile;
//     // if (videoFile != null) {
//     //   bool exist = await videoFile.exists();
//     //   if (exist) {
//     //     await videoFile.delete();
//     //   }
//     // }
//   }

//   Stream<EventPostState> _resumeEvent(CallLinkPost eventPost) async* {
//     yield* handleCreateResume(eventPost);
//   }

//   Stream<EventPostState> _createEvent(CallLinkPost eventPost) async* {
//     await EventService.savePendingEventPost(eventPost);
//     yield* handleCreateResume(eventPost);
//   }

//   Stream<EventPostState> _updateEvent(CallLinkPost eventPost) async* {
//     if (eventPost.localVideo != null) {
//       await EventService.savePendingEventPost(eventPost);
//       yield* handleCreateResume(eventPost);
//       return;
//     }
//     EventService.updateEventPost(eventPost);
//     yield EventPostWaiting();
//   }
// }

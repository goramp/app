import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

abstract class PreviewAction extends Equatable {}

class ShowUserPreview extends PreviewAction {
  List<Object> get props => [];
  @override
  String toString() => 'ShowUserPreview';
}

class ShowRecordPreview extends PreviewAction {
  ShowRecordPreview();
  List<Object> get props => [];
  String toString() => 'ShowRecordPreview';
}

class ShowEventPreview extends PreviewAction {
  final int index;
  ShowEventPreview(this.index);
  List<Object> get props => [index];
  @override
  String toString() => 'ShowEventPreview';
}

class ShowSchedulePreview extends PreviewAction {
  final int index;
  ShowSchedulePreview(this.index);
  List<Object> get props => [index];
  @override
  String toString() => 'ShowSchedulePreview';
}

class RestorePreview extends PreviewAction {
  RestorePreview();
  List<Object> get props => [];
  String toString() => 'RestorePreview';
}

abstract class PreviewState extends Equatable {}

class UserPreviewState extends PreviewState {
  List<Object> get props => [];
  @override
  String toString() => 'UserPreview';
}

class RecordPreviewState extends PreviewState {
  List<Object> get props => [];
  @override
  String toString() => 'RecordPreview';
}

class PageControllerPreviewState extends PreviewState {
  final PageController? controller;
  PageControllerPreviewState(this.controller);
  List<Object?> get props => [controller];
  @override
  String toString() => 'PageControllerPreviewState: controller: $controller';
}

class EventPreviewState extends PageControllerPreviewState {
  EventPreviewState(PageController? controller) : super(controller);
  @override
  String toString() => 'EventPreviewState: controller:$controller, ';
}

class CallPreviewState extends PageControllerPreviewState {
  CallPreviewState(PageController? controller) : super(controller);
  @override
  String toString() => 'CallPreviewState: controller:$controller, ';
}

class PreviewBloc extends Bloc<PreviewAction, PreviewState> {
  PreviewBloc() : super(UserPreviewState());
  PageController? controller;
  ValueNotifier<int?> pageChange = ValueNotifier<int?>(null);

  PreviewState? _previousState;

  @override
  Future<void> close() async {
    controller?.dispose();
    super.close();
  }

  _cleanController() {
    controller?.removeListener(_handlePageChange);
    controller?.dispose();
  }

  PageController? _initController(int initialPage) {
    controller = PageController(initialPage: initialPage);
    return controller;
  }

  _handlePageChange() {
    // if (controller == null || !controller.hasClients) {
    //   return;
    // }
    // SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
    //   if (controller == null || !controller.hasClients) {
    //     return;
    //   }
    //   int currentPage = controller.page.round();
    //   pageChange.value = currentPage;
    // });
  }

  @override
  Stream<PreviewState> mapEventToState(PreviewAction event) async* {
    PreviewState? previewState;
    if (event is ShowUserPreview) {
      previewState = UserPreviewState();
    }
    if (event is ShowRecordPreview) {
      previewState = RecordPreviewState();
    }
    if (event is ShowEventPreview) {
      _cleanController();
      previewState = EventPreviewState(_initController(event.index));
    }
    if (event is ShowSchedulePreview) {
      _cleanController();
      previewState = CallPreviewState(_initController(event.index));
    }
    if (event is RestorePreview) {
      if (_previousState != null) {
        yield _previousState!;
      }
      return;
    }
    if (state is UserPreviewState || state is RecordPreviewState) {
      _previousState = state;
    }
    yield previewState!;
  }
}

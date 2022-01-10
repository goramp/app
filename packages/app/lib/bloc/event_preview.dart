import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import '../models/index.dart';

const int MAX_NUM_EVENTS = 20;

abstract class PreviewAction extends Equatable {
  PreviewAction();
}

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

class ShowCallLinkPreview extends PreviewAction {
  CallLink event;
  ShowCallLinkPreview(this.event);
  List<Object> get props => [event];
  @override
  String toString() => 'ShowCallLinkPreview';
}

abstract class PreviewState extends Equatable {}

class UserPreview extends PreviewState {
  List<Object> get props => [];
  @override
  String toString() => 'UserPreview';
}

class RecordPreview extends PreviewState {
  List<Object> get props => [];
  @override
  String toString() => 'RecordPreview';
}

class CallLinkPreview extends PreviewState {
  final CallLink event;
  CallLinkPreview(this.event);
  List<Object> get props => [event];
  @override
  String toString() => 'CallLinkPreview';
}

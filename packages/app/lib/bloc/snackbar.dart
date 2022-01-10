import 'package:flutter/material.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

class SnackBarContent extends Equatable {
  final String message;
  final Color? backgroundColor;
  final SnackBarAction? action;
  final Duration? duration;
  SnackBarContent(
      {required this.message, this.backgroundColor, this.action, this.duration})
      : assert(message != null);

  List<Object> get props => [message];
}

@immutable
abstract class SnackbarEvent {}

class Show extends SnackbarEvent {
  final SnackBarContent content;
  Show(this.content);
}

class Dismiss extends SnackbarEvent {}

@immutable
abstract class SnackbarState {}

class Showing extends SnackbarState {
  final SnackBarContent content;
  Showing(this.content);
}

class Dismissed extends SnackbarState {}

class SnackbarBloc extends Bloc<SnackbarEvent, SnackbarState> {
  SnackbarBloc(): super(Dismissed());

  @override
  Stream<SnackbarState> mapEventToState(
    SnackbarEvent event,
  ) async* {
    if (event is Show) {
      yield Showing(event.content);
    } else {
      yield Dismissed();
    }
  }
}

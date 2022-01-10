import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart' as Models;
import '../utils/index.dart';
import '../services/index.dart';

abstract class AvailabilityEvent extends Equatable {}

class _RefreshAvailabilities extends AvailabilityEvent {
  final Map<String, List<Models.GTimeInterval>> availabilities;
  _RefreshAvailabilities(this.availabilities);
  List<Object> get props => [availabilities];
  @override
  String toString() => '_RefreshAvailabilities';
}

abstract class AvailabilityState extends Equatable {}

class AvailabilitiesUninitialized extends AvailabilityState {
  List<Object> get props => [];
  @override
  String toString() => 'AvailabilitiesUninitialized';
}

class AvailabilitiesLoadError extends AvailabilityState {
  final Object error;
  AvailabilitiesLoadError(this.error);
  List<Object> get props => [error];
  @override
  String toString() => 'AvailabilitiesLoadError';
}

class AvailabilitiesLoaded extends AvailabilityState {
  final Map<String, List<Models.GTimeInterval>>? availabilities;

  List<Object?> get props => [availabilities];

  AvailabilitiesLoaded({
    this.availabilities,
  });

  AvailabilitiesLoaded copyWith({
    Map<String, List<Models.GTimeInterval>>? availabilities,
  }) {
    return AvailabilitiesLoaded(
      availabilities: availabilities ?? this.availabilities,
    );
  }

  @override
  String toString() =>
      'AvailabilitiesLoaded { availabilities: $availabilities }';
}

class AvailabilitesBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  final String userId;
  final String eventId;
  StreamSubscription<QuerySnapshot>? _subscription;

  AvailabilitesBloc(this.userId, this.eventId)
      : super(AvailabilitiesUninitialized()) {
    subscribeAvailability();
  }

  subscribeAvailability() async {
    _subscription = AvailabilityService.subscribeAvailabilities(eventId, userId,
        (avaialbilities) {
      add(_RefreshAvailabilities(avaialbilities));
    }, onError: (error, StackTrace stackTrace) {
      print("error: $error");
      ErrorHandler.report(error, stackTrace);
    });
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    super.close();
  }

  @override
  Stream<AvailabilityState> mapEventToState(AvailabilityEvent event) async* {
    if (event is _RefreshAvailabilities) {
      yield AvailabilitiesLoaded(availabilities: event.availabilities);
    }
  }
}

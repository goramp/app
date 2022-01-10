import 'dart:async';
import 'package:goramp/bloc/index.dart';

import '../models/index.dart';
import '../services/index.dart';

class PastCallBloc extends BaseFeedBloc<Call> {
  PastCallBloc(AuthenticationBloc authBloc)
      : super(authBloc: authBloc);

  StreamSubscription subscribeItems(
      String? userId, void onData(List<Call> items),
      {void onError(error, StackTrace stackTrace)?, int? limit}) {
    return CallService.getPastCallsSubscription(userId, onData,
        onError: onError, limit: limit!);
  }

  Future<List<Call>> fetchItemsAfter(String? userId, {Call? last, int? limit}) {
    return CallService.fetchPastCalls(userId, last: last, limit: limit);
  }

  Future<List<Call>> fetchItemsBefore(String? userId, {Call? first, int? limit}) {
    return CallService.fetchPastCalls(userId, first: first, limit: limit);
  }
}

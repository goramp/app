import 'dart:async';
import 'package:goramp/bloc/index.dart';

import '../models/index.dart';
import '../services/index.dart';

class UpcomingCallBloc extends BaseFeedBloc<Call> {
  UpcomingCallBloc(AuthenticationBloc authBloc)
      : super(authBloc: authBloc);

  StreamSubscription subscribeItems(
      String? userId, void onData(List<Call> items),
      {void onError(error, StackTrace stackTrace)?, int? limit}) {
    return CallService.getUpcomingCallsSubscription(userId, onData,
        onError: onError, limit: limit!);
  }

  Future<List<Call>> fetchItemsAfter(String? userId, {Call? last, int? limit}) {
    return CallService.fetchUpcomingCalls(userId, last: last, limit: limit);
  }

  Future<List<Call>> fetchItemsBefore(String? userId, {Call? first, int? limit}) {
    return CallService.fetchUpcomingCalls(userId, first: first, limit: limit);
  }
}

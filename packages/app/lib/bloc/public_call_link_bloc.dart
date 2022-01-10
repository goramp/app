import 'dart:async';
import 'package:goramp/bloc/index.dart';
import '../models/index.dart';
import '../services/index.dart';
import 'base_feed.dart';

class PublicCallLinksBloc extends BaseFeedBloc<CallLink> {
  PublicCallLinksBloc({
    String? userId,
    bool useUsername = true,
  }) : super(userId: userId, useUsername: useUsername);

  StreamSubscription subscribeItems(
      String? userId, void onData(List<CallLink> items),
      {void onError(error, StackTrace stackTrace)?, int? limit}) {
    if (useUsername) {
      return CallLinkService.getCallLinksSubscriptionByUserName(userId, onData,
          limit: limit!, onError: onError);
    } else {
      return CallLinkService.getCallLinksSubscriptionByUserId(userId, onData,
          limit: limit!, onError: onError);
    }
  }

  Future<List<CallLink>> fetchItemsAfter(String? userId,
      {CallLink? last, int? limit}) {
    if (useUsername) {
      return CallLinkService.getCallLinksByUserName(userId,
          last: last, limit: limit);
    } else {
      return CallLinkService.getCallLinksByUserId(userId,
          last: last, limit: limit);
    }
  }

  Future<List<CallLink>> fetchItemsBefore(String? userId,
      {CallLink? first, int? limit}) {
    if (useUsername) {
      return CallLinkService.getCallLinksByUserName(userId,
          first: first, limit: limit);
    } else {
      return CallLinkService.getCallLinksByUserId(userId,
          first: first, limit: limit);
    }
  }
}

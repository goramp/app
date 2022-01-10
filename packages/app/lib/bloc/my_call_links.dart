import 'dart:async';
import 'package:goramp/bloc/index.dart';
import '../models/index.dart';
import '../services/index.dart';

enum MyCallLinksFetchFilter { CREATED_EVENTS, LIKED_EVENTS }

class MyCallLinksBloc extends BaseFeedBloc<CallLink> {
  MyCallLinksFetchFilter _fetchFilter;
  String? hostId;
  MyCallLinksBloc({
    String? userId,
    bool useUsername = true,
    MyCallLinksFetchFilter fetchFilter = MyCallLinksFetchFilter.CREATED_EVENTS,
    AuthenticationBloc? authBloc,
    this.hostId,
  })  : _fetchFilter = fetchFilter,
        super(authBloc: authBloc, userId: userId, useUsername: useUsername);

  set fetchFilter(MyCallLinksFetchFilter fetchFilter) {
    if (fetchFilter == _fetchFilter) return;
    _fetchFilter = fetchFilter;
    add(SubscribeToFeed());
  }

  StreamSubscription? subscribeItems(
      String? userId, void onData(List<CallLink> items),
      {void onError(error, StackTrace stackTrace)?, int? limit}) {
    if (MyCallLinksFetchFilter.CREATED_EVENTS == _fetchFilter) {
      if (useUsername) {
        return CallLinkService.getMyCallLinksSubscriptionByUserName(
            userId, onData,
            limit: limit!, onError: onError);
      } else {
        return CallLinkService.getMyCallLinksSubscriptionByUserId(
            userId, onData,
            limit: limit!, onError: onError);
      }
    }
    if (MyCallLinksFetchFilter.LIKED_EVENTS == _fetchFilter) {
      if (useUsername) {
        print('host id: $hostId');
        return CallLinkService.getCallLinksSubscriptionLikedByUsername(
            userId, onData,
            limit: limit!, onError: onError, hostId: hostId);
      } else {
        return CallLinkService.getCallLinksSubscriptionLikedByUserId(
            userId, onData,
            limit: limit!, onError: onError, hostId: hostId);
      }
    }
    return null;
  }

  Future<List<CallLink>>? fetchItemsAfter(String? userId,
      {CallLink? last, int? limit}) {
    if (MyCallLinksFetchFilter.CREATED_EVENTS == _fetchFilter) {
      if (useUsername) {
        return CallLinkService.getCallLinksByUserName(userId,
            last: last, limit: limit);
      } else {
        return CallLinkService.getCallLinksByUserId(userId,
            last: last, limit: limit);
      }
    }
    if (MyCallLinksFetchFilter.LIKED_EVENTS == _fetchFilter) {
      if (useUsername) {
        return CallLinkService.getCallLinksLikedByUsername(userId,
            last: last, limit: limit, hostId: hostId);
      } else {
        return CallLinkService.getCallLinksLikedByUserId(userId,
            last: last, limit: limit, hostId: hostId);
      }
    }
    return null;
  }

  Future<List<CallLink>>? fetchItemsBefore(String? userId,
      {CallLink? first, int? limit}) {
    if (MyCallLinksFetchFilter.CREATED_EVENTS == _fetchFilter) {
      if (useUsername) {
        return CallLinkService.getCallLinksByUserName(userId,
            first: first, limit: limit);
      } else {
        return CallLinkService.getCallLinksByUserId(userId,
            first: first, limit: limit);
      }
    }
    if (MyCallLinksFetchFilter.LIKED_EVENTS == _fetchFilter) {
      if (useUsername) {
        return CallLinkService.getCallLinksLikedByUsername(userId,
            first: first, limit: limit, hostId: hostId);
      } else {
        return CallLinkService.getCallLinksLikedByUserId(userId,
            first: first, limit: limit, hostId: hostId);
      }
    }
    return null;
  }
}

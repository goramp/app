import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/widgets/router/routes/app_route_path.dart';
import 'package:goramp/route_constants.dart';
import 'package:goramp/bloc/index.dart';

abstract class PublicRoutePath extends AppRoutePath {
  PublicRoutePath() : super(secureRoot: false);
}

class CallLinkDetailsPath extends PublicRoutePath {
  String? id;
  final CallLink? callLink;
  final BaseFeedBloc<CallLink>? feedBloc;
  final int? pageIndex;
  final bool isFavorite;
  final bool autoPlayVideo;
  final bool shouldClose;
  final bool? startBooking;
  final VoidCallback? onClose;

  CallLinkDetailsPath(this.id,
      {this.pageIndex,
      this.feedBloc,
      this.callLink,
      this.isFavorite = false,
      this.autoPlayVideo = true,
      this.shouldClose = true,
      this.startBooking = false,
      this.onClose});

  String get location {
    final base = '$CallLinksRoute/$id';
    if (startBooking != null && startBooking!) {
      return "$CallLinksRoute/$id?startBooking=$startBooking";
    }
    return base;
  }

  String get name => "CallLink";

  CallLinkDetailsPath copyWith(
      {String? id,
      CallLink? callLink,
      BaseFeedBloc<CallLink>? feedBloc,
      int? pageIndex,
      bool? isFavorite,
      bool? autoPlayVideo,
      bool? shouldClose}) {
    return CallLinkDetailsPath(
      id ?? this.id,
      callLink: callLink ?? this.callLink,
      feedBloc: feedBloc ?? this.feedBloc,
      pageIndex: pageIndex ?? this.pageIndex,
      isFavorite: isFavorite ?? this.isFavorite,
      autoPlayVideo: autoPlayVideo ?? this.autoPlayVideo,
      shouldClose: shouldClose ?? this.shouldClose,
    );
  }
}

class CallLinkQRPath extends PublicRoutePath {
  String? id;
  final CallLink? callLink;
  final VoidCallback? onClose;
  CallLinkQRPath(this.id, {this.callLink, this.onClose});

  String get location => "$CallLinksRoute/$id/qr";
  String get name => "CallLink";

  CallLinkQRPath copyWith(
      {String? id, CallLink? callLink, VoidCallback? onClose}) {
    return CallLinkQRPath(id ?? this.id,
        callLink: callLink ?? this.callLink, onClose: onClose ?? this.onClose);
  }
}

class CallLinkSchedulePath extends PublicRoutePath {
  String? id;
  final CallLink? callLink;
  final VoidCallback? onClose;
  CallLinkSchedulePath(this.id, {this.callLink, this.onClose});

  String get location => "$CallLinksRoute/$id/schedule";
  String get name => "CallLink";

  CallLinkSchedulePath copyWith(
      {String? id, CallLink? callLink, VoidCallback? onClose}) {
    return CallLinkSchedulePath(id ?? this.id,
        callLink: callLink ?? this.callLink, onClose: onClose ?? this.onClose);
  }
}

class ProfilePath extends PublicRoutePath {
  final String? userName;
  final bool isFavorite;
  final UserProfile? profile;
  final bool shouldPopOnClose;
  ProfilePath(this.userName,
      {this.isFavorite = false, this.profile, this.shouldPopOnClose = false});
  String get location => "/@$userName";
  String get name => "Profile";
}

class CallLinksPagesPath extends PublicRoutePath {
  final String? username;
  final BaseFeedBloc<CallLink>? feedBloc;
  final bool isFavorite;
  final bool autoPlayVideo;
  final bool shouldClose;
  final String? start;
  CallLinksPagesPath(this.username,
      {this.feedBloc,
      this.start,
      this.isFavorite = false,
      this.autoPlayVideo = true,
      this.shouldClose = true});

  String get location {
    String base = "/@$username$CallLinksRoute";
    if (isFavorite) {
      base = '$base?likes=1';
    }
    if (start != null) {
      base = '$base?start=$start';
    }
    return base;
  }

  String get name => "CallLink";
}

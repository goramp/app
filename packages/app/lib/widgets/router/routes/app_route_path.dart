// Routes
import 'package:flutter/material.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/route_constants.dart';

abstract class AppRoutePath {
  String get location;
  String get name;
  final bool secureRoot;
  final VoidCallback? onPop;
  const AppRoutePath({this.secureRoot = true, this.onPop});
}

class SplashPath extends AppRoutePath {
  const SplashPath() : super(secureRoot: false);
  String get name => "Splash";

  String get location => '$SplashRoute';
}

class StripeConnectCallbackPath extends AppRoutePath {
  String get name => "Stripe";

  const StripeConnectCallbackPath();

  String get location => '$StripeConnectCallbackRoute';
}

class UnknownPath extends AppRoutePath {
  UnknownPath() : super(secureRoot: false);
  String get location => "$UnknownRoute";
  String get name => "404";
}

class ClaimsPath extends AppRoutePath {
  ClaimsPath();
  String get location => "$ClaimsRoute";
  String get name => "Claims";
}

class PreviewRoutePath extends AppRoutePath {
  final dynamic source;
  final ValueChanged<VideoAsset>? onDone;

  PreviewRoutePath(this.source, {VoidCallback? onClose, this.onDone})
      : super(onPop: onClose);
  String get location => "$RecordRoute/preview";
  String get name => "Record";
}

class EditCallLinkPath extends AppRoutePath {
  final String? id;
  final CallLink? callLink;
  EditCallLinkPath(
    this.id, {
    this.callLink,
  });
  String get name => "Edit Call Link";

  String get location => "$CallLinksRoute/$id/edit";
}

class EditProfilePath extends AppRoutePath {
  final String? username;
  EditProfilePath(this.username);
  String get location => "/@$username/edit";
  String get name => "Edit Profile";
}


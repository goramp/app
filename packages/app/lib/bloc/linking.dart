import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

abstract class LinkCallLink extends Equatable {}

class LinkException implements Exception {
  LinkException(this.code, this.description);

  String code;
  String description;

  @override
  String toString() => '$runtimeType($code, $description)';
}

class LinkBloc {
  StreamSubscription<String?>? _linkStream;

  LinkBloc() {
    _initUniLinks();
  }

  Future<Null> _initUniLinks() async {
    if (UniversalPlatform.isWeb) {
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Uri? initialUri = await getInitialUri();
      _handleDeepLink(initialUri);
      _linkStream?.cancel();
      // Attach a listener to the stream
      _linkStream = getLinksStream().listen((String? link) {
        final uri = Uri.parse(link!);
        _handleDeepLink(uri);
      }, onError: (err) {
        print('Error:_initUniLinks:$err');
        // Handle exception by warning the user their action did not succeed
      });
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  _handleDeepLink(Uri? link) async {
    if (link == null) {
      return;
    }
    // final route = AppRouteInformationParser.parseRoute(link);
    // if (route != null) {
    //   routePageManager!.navigateTo(route);
    // }
  }

  void dispose() {
    _linkStream?.cancel();
  }
}

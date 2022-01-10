import 'package:goramp/widgets/router/routes/index.dart';

enum MySubPath { call_links, favorites }

class HomeRoutePath extends AppRoutePath {
  String get location => '/';
  String get name => "Home";
  const HomeRoutePath();
}

class MainRoutePath extends HomeRoutePath {
  String get pathLocation {
    switch (path) {
      case 'calls':
        return "/";
      default:
        return "/$path";
    }
  }

  String? get subRouterLocation => subRoutePath?.location;
  String get location => subRouterLocation ?? pathLocation;
  const MainRoutePath({
    this.path = 'calls',
    this.mySubPath = MySubPath.call_links,
    this.subRoutePath,
  });

  String get name => "Main";
  final String path;
  final MySubPath? mySubPath;
  final InAppRoutePath? subRoutePath;

  const MainRoutePath.home()
      : path = 'calls',
        mySubPath = null,
        subRoutePath = null;
  const MainRoutePath.me({this.mySubPath = MySubPath.call_links})
      : path = 'me',
        subRoutePath = null;
  const MainRoutePath.wallet()
      : path = 'wallet',
        mySubPath = null,
        subRoutePath = null;
  const MainRoutePath.payout()
      : path = 'payout',
        mySubPath = null,
        subRoutePath = null;

  bool get isHome => path == 'calls';
  // bool get isNewCallLink => path == PageType.New;
  bool get isMe => path == 'me';

  MainRoutePath copyWith(
      {String? path,
      MySubPath? mySubPath,
      InAppRoutePath? subRoutePath,
      String? username}) {
    return MainRoutePath(
      mySubPath: mySubPath ?? this.mySubPath,
      path: path ?? this.path,
      subRoutePath: subRoutePath ?? this.subRoutePath,
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:goramp/app_config.dart';
import 'package:goramp/bloc/abstract_model.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/utils/index.dart';
import 'package:goramp/widgets/router/routes/main_route_path.dart';

const PageType = ['home', 'savings', 'wallet'];

// extension PageTypeExtension on PageType {
//   int index() {
//     switch (this) {
//       case PageType.Home:
//         return 0;
//       case PageType.New:
//         return 1;
//       case PageType.Me:
//         return 2;
//       default:
//         return null;
//     }
//   }
// }

/// //////////////////////////////////////////////////////
/// APP MODEL - Holds global state/settings for various app components and views.
/// A mix of different values: Current theme, app version, settings, online status, selected sections etc.
/// Some of the values are serialized in app.settings file
class MyAppModel extends AbstractModel {
  static const kCurrentVersion = "1.0.1";

  static bool forceIgnoreGoogleApiCalls = false;

  static bool get enableShadowsOnWeb => true;

  static bool get enableAnimationsOnWeb => true;

  bool _onSearchPage = false;

  MySubPath? _mySubPath;

  StreamSubscription<UserProfile?>? _userProfileSubscription;
  StreamSubscription<UserKYC?>? _userKYCSubscription;
  StreamSubscription<UserSession?>? _userSessionSubscription;

  /// Toggle fpsMeter
  static bool get showFps => false;

  /// Toggle Sketch Design Grid
  static bool get showDesignGrid => false;

  /// Ignore limiting cooldown periods (tweets, git events, git repos, groups), always fetch for each request
  static bool get ignoreCooldowns => false;

  MyAppModel(this._config,
      {User? user,
      UserProfile? profile,
      LinkAuthCredential? pendingAuthCredential}) {
    _currentUser = user;
    _profile = profile;
    _pendingAuthCredential = pendingAuthCredential;
    _currentMainPage = 'calls';
    _countryMap = countryList.fold<Map<String, Country>>({},
        (Map<String, Country> memo, Country currentVal) {
      memo[currentVal.isoCode.toUpperCase()] = currentVal;
      return memo;
    });
  }

  AppConfig _config;

  AppConfig get config => _config;

  String? _callLinkId;

  set selectedConfig(AppConfig value) {
    if (_config == value) return;
    _config = value;
    notifyListeners();
  }

  User? _currentUser;

  set currentUser(User? user) {
    if (_currentUser == user) return;
    _currentUser = user;
    if (_currentUser != null) {
      _subscribeUserProfile(_currentUser!.id);
    } else {
      _userProfileSubscription?.cancel();
      _userKYCSubscription?.cancel();
      _userSessionSubscription?.cancel();
    }
    notifyListeners();
  }

  LinkAuthCredential? _pendingAuthCredential;
  LinkAuthCredential? get pendingAuthCredential => _pendingAuthCredential;
  set pendingAuthCredential(LinkAuthCredential? pendingAuthCredential) {
    if (_pendingAuthCredential == pendingAuthCredential) return;
    _pendingAuthCredential = pendingAuthCredential;
    notifyListeners();
  }

  UserProfile? _profile;
  UserProfile? get profile => _profile;
  UserKYC? _userKYC;
  UserKYC? get userKYC => _userKYC;
  UserSession? _session;
  UserSession? get session => _session;
  late Map<String, Country> _countryMap;
  Map<String, Country> get countries => _countryMap;

  set profile(UserProfile? profile) {
    if (_profile == profile) return;
    _profile = profile;
    notifyListeners();
  }

  set userKYC(UserKYC? userKYC) {
    if (_userKYC == userKYC) return;
    _userKYC = userKYC;
    notifyListeners();
  }

  set session(UserSession? session) {
    if (_session == session) return;
    _session = session;
    notifyListeners();
  }

  List<UserPaymentProvider>? _paymentProviders;
  List<UserPaymentProvider>? get paymentProviders => _paymentProviders;

  set paymentProviders(List<UserPaymentProvider>? paymentProviders) {
    if (listEquals(_paymentProviders, paymentProviders)) return;
    _paymentProviders = paymentProviders;
    notifyListeners();
  }

  _subscribeUserProfile(String? userId) async {
    await _userProfileSubscription?.cancel();
    await _userKYCSubscription?.cancel();
    await _userSessionSubscription?.cancel();
    _userProfileSubscription =
        UserService.getProfileStream(userId).listen((UserProfile? userProfile) {
      profile = userProfile;
    });
    _userKYCSubscription =
        UserService.getKYCStream(userId).listen((UserKYC? kyc) {
      userKYC = kyc;
    });
    _userSessionSubscription =
        UserService.getUserSessionStream(userId).listen((UserSession? session) {
      this.session = session;
    });
  }

  bool get hideMainSideNav => _hideMainSideNav;

  bool _hideMainSideNav = false;

  set hideMainSideNav(bool hideMainSideNav) {
    if (_hideMainSideNav == hideMainSideNav) return;
    _hideMainSideNav = hideMainSideNav;
    notifyListeners();
  }

  User? get currentUser => _currentUser;

  @override
  void dispose() async {
    await _userProfileSubscription?.cancel();
    await _userKYCSubscription?.cancel();
    await _userSessionSubscription?.cancel();
    super.dispose();
  }

  /// //////////////////////////////////////////////////
  /// Version Info (serialized)
  String version = "0.0.0";

  void upgradeToVersion(String value) {
    // Any version specific upgrade checks can go here
    version = value;
  }

  /// //////////////////////////////////////////////////
  /// Selected edit target, controls visibility of the edit panel and selected rows in the various views
  Call? get selectedCall => _selectedCall;
  Call? _selectedCall;

  /// Current selected edit target, controls visibility of the edit panel
  set selectedCall(Call? value) {
    if (_selectedCall == value) return;
    _selectedCall = value;
    _selectedScheduleId = value?.id;
    notifyListeners();
  }

  String? get getSelectedById {
    return _selectedCall?.id ?? _selectedCall as String?;
  }

  /// //////////////////////////////////////////////////
  /// Selected scheduleId
  String? get selectedScheduleId => _selectedScheduleId;
  String? _selectedScheduleId;

  /// Current selected edit target, controls visibility of the edit panel
  set selectedScheduleId(String? value) {
    if (_selectedScheduleId == value) return;
    _selectedScheduleId = value;
    _selectedCall = null;
    notifyListeners();
  }

  /// //////////////////////////////////////////////////
  /// Holds current page type, synchronizes leftMenu with the mainContent
  String? get currentMainPage => _currentMainPage;
  String? _currentMainPage;

  bool get onSearchPage => _onSearchPage;

  set currentMainPage(String? value) {
    if (_currentMainPage == value) return;
    _currentMainPage = value;
    notifyListeners();
  }

  bool _show404 = false;

  /// //////////////////////////////////////////////////
  /// shows 404  if the current page is unknown
  bool get show404 => _show404;

  set show404(bool value) {
    if (_show404 == value) return;
    _show404 = value;
    notifyListeners();
  }

  /// //////////////////////////////////////////
  /// Current connection status
  bool get isOnline => _isOnline;
  bool _isOnline = true;

  MySubPath? get mySubPath => _mySubPath;

  set isOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  set onSearchPage(bool value) {
    if (_onSearchPage == value) return;
    _onSearchPage = value;
    notifyListeners();
  }

  set mySubPath(MySubPath? value) {
    if (_mySubPath == value) return;
    _mySubPath = value;
    notifyListeners();
  }

  String? get callLinkId => _callLinkId;

  set callLinkId(String? value) {
    if (_callLinkId == value) return;
    _callLinkId = value;
    notifyListeners();
  }
}

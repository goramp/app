import 'dart:async';
import 'package:goramp/bloc/index.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../app_config.dart';
import '../models/index.dart';
import '../services/index.dart';

class UserProfileBloc {
  final rxdart.BehaviorSubject<UserProfile?> _user =
      rxdart.BehaviorSubject<UserProfile?>();
  StreamSubscription<UserProfile?>? _userSubscription;
  StreamSubscription<AuthenticationState>? _authListener;
  final AppConfig config;

  UserProfileBloc(Stream<AuthenticationState> authState, this.config) {
    _authListener = authState.listen(this._handleAuth);
  }

  _subscribeUser(String? userId) async {
    await _unsubscribe();
    _userSubscription =
        UserService.getProfileStream(userId).listen(_handleUser);
  }

  void userLogin(UserProfile profile) {
    _user.sink.add(profile);
  }

  _handleUser(UserProfile? user) {
    if (user == null) {
      return;
    }
    _user.sink.add(user);
  }

  _unsubscribe() async {
    await _userSubscription?.cancel();
  }

  _handleAuth(AuthenticationState auth) async {
    if (auth is AuthAuthenticated) {
      await _subscribeUser(auth.user!.id);
    }
    if (auth is AuthUnauthenticated) {
      _user.sink.add(null);
      await _unsubscribe();
    }
  }

  rxdart.ValueStream<UserProfile?> get currentUserStream => _user.stream;

  void dispose() async {
    await _user.close();
    await _unsubscribe();
    await _authListener?.cancel();
  }
}

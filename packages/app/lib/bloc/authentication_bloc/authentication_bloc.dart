import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:goramp/bloc/index.dart';
import 'package:goramp/services/index.dart';
import 'package:goramp/models/index.dart';
import 'package:universal_platform/universal_platform.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final MyAppModel model;
  StreamSubscription<auth.User?>? _authSubscription;
  User? _user;
  UserProfile? _profile;

  AuthenticationBloc(this.model) : super(AuthUnInitialized()) {
    if (model.currentUser != null) {
      _user = model.currentUser;
      _profile = model.profile;
      add(AuthLoggedIn(model.currentUser, model.profile));
    } else {
      add(AuthLoggedOut(pendingAuthCredential: model.pendingAuthCredential));
    }
    _authSubscription =
        auth.FirebaseAuth.instance.userChanges().listen(this._handleAuth);
  }

  Future<void> _checkRedirect() async {
    try {
      final myUser = await LoginService.getRedirectResult();
      if (myUser != null) {
        await _doLogin(myUser);
      } else {
        _doLogout();
      }
    } on AuthException catch (error) {
      if (error.code ==
          AuthExceptionCode.AccountExistWithDifferentCredentials) {
        final preferredProvider =
            await LoginService.preferredProvider(error.email!);
        final pendingAuth = LinkAuthCredential(
            provider: preferredProvider,
            credential: error.credential,
            email: error.email);
        await LoginService.savePendingAuthCredential(pendingAuth);
        _doLogout(pendingAuth: pendingAuth);
      } else {
        _doLogout();
      }
    } catch (error) {
      print("ERROR code ${error}");
      _doLogout();
    }
  }

  _handleAuth(auth.User? user) async {
    if (user == null) {
      if (UniversalPlatform.isWeb) {
        await _checkRedirect();
      } else {
        _doLogout();
      }
    } else {
      final myUser = User.fromFirebaseUser(user);
      await _doLogin(myUser);
    }
  }

  Future<void> linkPendingAuth(String? email) async {
    final pendingAuth = await LoginService.readPendingAuthCredential();
    if (pendingAuth != null) {
      if (pendingAuth.email == email) {
        await LoginService.linkWithCredentials(pendingAuth.credential!);
      }
      await LoginService.deletePendingAuthCredential();
    }
  }

  Future<void> _doLogin(User user) async {
    try {
      if (_user == user) {
        return;
      }
      _user = user;
      add(AuthLoggedIn(_user, _profile));
    } catch (error) {
      print('ERROR: $error');
      _doLogout();
    }
  }

  void _doLogout({LinkAuthCredential? pendingAuth}) {
    _user = null;
    _profile = null;
    add(AuthLoggedOut(pendingAuthCredential: pendingAuth));
  }

  void onEvent(AuthenticationEvent event) {
    super.onEvent(event);
  }

  void onTransition(
      Transition<AuthenticationEvent, AuthenticationState> transition) {
    model.currentUser = transition.nextState.user;
    model.profile = transition.nextState.profile;
    model.pendingAuthCredential = transition.nextState.pendingAuthCredential;
    super.onTransition(transition);
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthLoggedIn) {
      yield* _mapLoggedInToState(event);
    } else if (event is AuthLoggedOut) {
      yield AuthUnauthenticated(
          pendingAuthCredential: event.pendingAuthCredential);
    } else if (event is AppLoggedOut) {
      yield* _mapLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState(AuthLoggedIn event) async* {
    await linkPendingAuth(event.user!.email);
    yield AuthAuthenticated(event.user!, event.profile);
  }

  Stream<AuthenticationState> _mapLoggedOutToState(AppLoggedOut event) async* {
    try {
      yield AuthUnauthenticated();
      await Future.delayed(
          Duration(seconds: 2), () async => await LoginService.logout());
    } catch (error, stack) {
      print('error: $error');
      print('stack: $stack');
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

import 'package:equatable/equatable.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent();
}

class AuthInitialized extends AuthenticationEvent {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'AppStarted';
}

class AuthLoggedIn extends AuthenticationEvent {
  final User? user;
  final UserProfile? profile;
  AuthLoggedIn(this.user, this.profile);
  @override
  List<Object?> get props => [user, profile];
  @override
  String toString() => 'LoggedIn';
}

class AuthLoggedOut extends AuthenticationEvent {
  final LinkAuthCredential? pendingAuthCredential;
  AuthLoggedOut({this.pendingAuthCredential});
  @override
  List<Object?> get props => [pendingAuthCredential];
  @override
  String toString() => 'LoggedOut';
}

class AppLoggedOut extends AuthenticationEvent {
  final String? returnTo;
  AppLoggedOut({this.returnTo});
  @override
  List<Object?> get props => [returnTo];
  @override
  String toString() => 'AppLoggedOut';
}

class AuthError extends AuthenticationEvent {
  final Object? exception;
  final Object? stack;

  AuthError({this.exception, this.stack});
  @override
  List<Object?> get props => [exception, stack];
  @override
  String toString() => 'Auth Error';
}

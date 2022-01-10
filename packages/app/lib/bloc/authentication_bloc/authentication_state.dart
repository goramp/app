import 'package:equatable/equatable.dart';
import 'package:goramp/models/index.dart';
import 'package:goramp/services/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  final User? user;
  final UserProfile? profile;
  final String? userId;
  final LinkAuthCredential? pendingAuthCredential;
  @override
  List<Object?> get props => [user, userId, profile, pendingAuthCredential];
  AuthenticationState(
      {this.user, this.userId, this.profile, this.pendingAuthCredential});
}

class AuthUnInitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class AuthAuthenticated extends AuthenticationState {
  AuthAuthenticated(User user, UserProfile? profile)
      : super(user: user, userId: user.id, profile: profile);

  @override
  String toString() => 'Authenticated { user: $user }';
}

class AuthUnauthenticated extends AuthenticationState {
  final String? returnTo;
  AuthUnauthenticated({LinkAuthCredential? pendingAuthCredential, this.returnTo})
      : super(pendingAuthCredential: pendingAuthCredential);
  @override
  List<Object?> get props => [user, userId, profile, pendingAuthCredential, returnTo];
  @override
  String toString() => 'Unauthenticated';
}

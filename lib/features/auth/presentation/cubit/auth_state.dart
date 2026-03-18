import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserAuth user;

  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthEmailVerificationSent extends AuthState {
  final UserAuth user;

  const AuthEmailVerificationSent(this.user);
}

class AuthFinalizing extends AuthState {
  final UserAuth user;

  const AuthFinalizing(this.user);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

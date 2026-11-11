sealed class Failure {
  final String debugMessage;

  const Failure(this.debugMessage);

  @override
  String toString() => debugMessage;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.debugMessage);
}

class ServerFailure extends Failure {
  const ServerFailure(super.debugMessage);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.debugMessage);
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure(super.debugMessage);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.debugMessage);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.debugMessage);
}

class ValidationFailure extends Failure {
  const ValidationFailure(this.userMessage) : super(userMessage);

  final String userMessage;
}

sealed class AuthFailure extends Failure {
  const AuthFailure(super.debugMessage);
}

class AuthInvalidCredentialsFailure extends AuthFailure {
  const AuthInvalidCredentialsFailure(super.debugMessage);
}

class AuthInvalidEmailFailure extends AuthFailure {
  const AuthInvalidEmailFailure(super.debugMessage);
}

class AuthUserDisabledFailure extends AuthFailure {
  const AuthUserDisabledFailure(super.debugMessage);
}

class AuthEmailAlreadyInUseFailure extends AuthFailure {
  const AuthEmailAlreadyInUseFailure(super.debugMessage);
}

class AuthAccountExistsWithDifferentCredentialFailure extends AuthFailure {
  const AuthAccountExistsWithDifferentCredentialFailure(super.debugMessage);
}

class AuthWeakPasswordFailure extends AuthFailure {
  const AuthWeakPasswordFailure(super.debugMessage);
}

class AuthTooManyRequestsFailure extends AuthFailure {
  const AuthTooManyRequestsFailure(super.debugMessage);
}

class AuthCancelledFailure extends AuthFailure {
  const AuthCancelledFailure(super.debugMessage);
}

class AuthProviderFailure extends AuthFailure {
  const AuthProviderFailure(super.debugMessage);
}

class AuthEmailAlreadyVerifiedFailure extends AuthFailure {
  const AuthEmailAlreadyVerifiedFailure() : super('Email already verified');
}

class AuthEmailNotVerifiedFailure extends AuthFailure {
  const AuthEmailNotVerifiedFailure() : super('Email not verified');
}

class AuthProfileMissingFailure extends AuthFailure {
  const AuthProfileMissingFailure() : super('Profile not finalized');
}

class AuthNoEmailFailure extends AuthFailure {
  const AuthNoEmailFailure() : super('No email for current user');
}

sealed class LocationFailure extends Failure {
  const LocationFailure(super.debugMessage);
}

class LocationServiceDisabledFailure extends LocationFailure {
  const LocationServiceDisabledFailure(super.debugMessage);
}

class LocationPermissionDeniedFailure extends LocationFailure {
  const LocationPermissionDeniedFailure(super.debugMessage);
}

class LocationUnavailableFailure extends LocationFailure {
  const LocationUnavailableFailure(super.debugMessage);
}

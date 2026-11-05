sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class AuthEmailNotVerifiedFailure extends AuthFailure {
  const AuthEmailNotVerifiedFailure() : super("Email non vérifié");
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthProfileMissingFailure extends AuthFailure {
  const AuthProfileMissingFailure() : super("Profil non finalisé");
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

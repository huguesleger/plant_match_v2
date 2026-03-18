/// Classe de base pour toutes les erreurs du domaine
sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Erreur liée à Firebase (réseau, permissions, etc.)
class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message);
}

/// Erreur quand une ressource n'est pas trouvée
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Erreur inattendue ou inconnue
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

/// Erreur spécifique à l'authentification (credentials invalides, email non vérifié, etc.)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

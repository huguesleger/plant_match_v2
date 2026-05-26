import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';

abstract class AuthRepository {
  /// Connexion email/mot de passe
  TaskEither<Failure, UserAuth> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Inscription email/mot de passe
  TaskEither<Failure, UserAuth> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  });

  /// Récupère l'utilisateur courant (None si non connecté)
  TaskEither<Failure, Option<UserAuth>> getCurrentUser();

  /// Connexion avec Google
  TaskEither<Failure, (UserAuth, bool)> signInWithGoogle();

  /// Connexion avec Facebook
  TaskEither<Failure, (UserAuth, bool)> signInWithFacebook();

  /// Envoi d'un email de réinitialisation de mot de passe
  TaskEither<Failure, Unit> sendPasswordResetEmail({required String email});

  /// Déconnexion
  TaskEither<Failure, Unit> logOut();

  /// Envoi de l'email de vérification
  TaskEither<Failure, Unit> sendEmailVerification();

  /// Vérifie si l'email de l'utilisateur courant est validé
  TaskEither<Failure, bool> isEmailVerified();

  /// Finalise l'inscription (crée le doc Firestore).
  /// Retourne true si c'est la première finalisation.
  TaskEither<Failure, bool> finalizeRegistration(User user, String fullName);
}

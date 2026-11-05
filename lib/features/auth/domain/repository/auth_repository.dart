import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';

abstract class AuthRepository {
  TaskEither<Failure, UserAuth> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  TaskEither<Failure, UserAuth> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  TaskEither<Failure, Option<UserAuth>> getCurrentUser();

  TaskEither<Failure, (UserAuth, bool)> signInWithGoogle();

  TaskEither<Failure, (UserAuth, bool)> signInWithFacebook();

  TaskEither<Failure, Unit> sendPasswordResetEmail({required String email});

  TaskEither<Failure, Unit> logOut();

  TaskEither<Failure, Unit> sendEmailVerification();

  TaskEither<Failure, bool> isEmailVerified();

  TaskEither<Failure, bool> finalizeRegistration(User user, String firstName, String lastName);
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/emailing/email_welcome.dart';
import 'package:plant_match_v2/features/user_points/data/firebase_user_points.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final FirebaseUserPoints userPointsRepository;

  UserAuth? _currentUser;
  bool _isCheckingEmail = false;

  AuthCubit({required this.authRepository, required this.userPointsRepository})
      : super(AuthInitial());

  UserAuth? get currentUser => _currentUser;
  String? get userId => _currentUser?.uid;

  // ─── checkCurrentUser ─────────────────────────────────────────────────────

  void checkCurrentUser() {
    authRepository
        .getCurrentUser()
        .map((option) => option.match(
              () => emit(Unauthenticated()),
              (user) {
                _currentUser = user;
                emit(Authenticated(user));
              },
            ))
        .run()
        .then((result) => result.match(
              (failure) => emit(Unauthenticated()),
              (_) => null,
            ));
  }

  // ─── signInWithEmailAndPassword ───────────────────────────────────────────

  void signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    emit(AuthLoading());

    authRepository
        .signInWithEmailAndPassword(email: email, password: password)
        .map((user) {
          _currentUser = user;
          emit(Authenticated(user));
        })
        .run()
        .then((result) => result.match(
              (failure) {
                emit(AuthError(failure.message));
                emit(Unauthenticated());
              },
              (_) => null,
            ));
  }

  // ─── registerWithEmailAndPassword ─────────────────────────────────────────

  void registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) {
    emit(AuthLoading());

    authRepository
        .registerWithEmailAndPassword(
            email: email, password: password, fullName: fullName)
        .flatMap((user) =>
            authRepository.sendEmailVerification().map((_) => user))
        .map((user) {
          _currentUser = user;
          emit(AuthEmailVerificationSent(user));
        })
        .run()
        .then((result) => result.match(
              (failure) => emit(AuthError(failure.message)),
              (_) => null,
            ));
  }

  // ─── resendEmailVerification ──────────────────────────────────────────────

  void resendEmailVerification() {
    authRepository
        .sendEmailVerification()
        .map((_) {
          if (_currentUser != null) {
            emit(AuthEmailVerificationSent(_currentUser!));
          } else {
            emit(Unauthenticated());
          }
        })
        .run()
        .then((result) => result.match(
              (failure) => emit(AuthError(failure.message)),
              (_) => null,
            ));
  }

  // ─── checkEmailVerified ───────────────────────────────────────────────────

  void checkEmailVerified({String? fullName}) {
    if (_isCheckingEmail) return;
    _isCheckingEmail = true;

    authRepository.isEmailVerified().flatMap((verified) {
      if (!verified) {
        return TaskEither.left(const AuthFailure("Email non vérifié"));
      }

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        return TaskEither.left(
            const AuthFailure("Utilisateur introuvable après vérification"));
      }

      final resolvedName = fullName ?? _currentUser?.fullName ?? '';
      
      // On wrap l'émission d'état dans Unit pour rester dans le flux TaskEither
      return TaskEither<Failure, Unit>.tryCatch(
        () async {
          emit(AuthFinalizing(UserAuth(
            uid: firebaseUser.uid,
            email: firebaseUser.email!,
            fullName: resolvedName,
          )));
          return unit;
        },
        (error, _) => UnexpectedFailure(error.toString()),
      ).flatMap((_) => authRepository
          .finalizeRegistration(firebaseUser, resolvedName)
          .flatMap((isFirst) => TaskEither<Failure, Unit>.tryCatch(
                () async {
                  if (isFirst) {
                    try {
                      await welcomeEmail(firebaseUser.email!, resolvedName);
                    } catch (_) {}
                    await userPointsRepository.addPoints(firebaseUser.uid, 25, 1).run();
                  }
                  final authenticatedUser = UserAuth(
                    uid: firebaseUser.uid,
                    email: firebaseUser.email!,
                    fullName: resolvedName,
                  );
                  _currentUser = authenticatedUser;
                  emit(Authenticated(authenticatedUser));
                  return unit;
                },
                (error, _) => UnexpectedFailure(
                    'Erreur lors de la finalisation : $error'),
              )));
    }).run().then((result) {
      _isCheckingEmail = false;
      result.match(
        (failure) {
          if (failure is AuthFailure && failure.message == "Email non vérifié") {
             if (_currentUser != null) {
              emit(AuthEmailVerificationSent(_currentUser!));
            } else {
              emit(Unauthenticated());
            }
          } else {
            emit(AuthError(failure.message));
          }
        },
        (_) => null,
      );
    });
  }

  // ─── signInWithGoogle ─────────────────────────────────────────────────────

  void signInWithGoogle() {
    emit(AuthLoading());

    authRepository
        .signInWithGoogle()
        .map((user) {
          _currentUser = user;
          emit(Authenticated(user));
        })
        .run()
        .then((result) => result.match(
              (failure) {
                emit(AuthError(failure.message));
                emit(Unauthenticated());
              },
              (_) => null,
            ));
  }

  // ─── signInWithFacebook ───────────────────────────────────────────────────

  void signInWithFacebook() {
    emit(AuthLoading());

    authRepository
        .signInWithFacebook()
        .map((user) {
          _currentUser = user;
          emit(Authenticated(user));
        })
        .run()
        .then((result) => result.match(
              (failure) {
                emit(AuthError(failure.message));
                emit(Unauthenticated());
              },
              (_) => null,
            ));
  }

  // ─── logOut ───────────────────────────────────────────────────────────────

  void logOut() {
    authRepository
        .logOut()
        .map((_) => emit(Unauthenticated()))
        .run()
        .then((result) => result.match(
              (failure) => emit(AuthError(failure.message)),
              (_) => null,
            ));
  }

  // ─── sendPasswordResetEmail ───────────────────────────────────────────────

  void sendPasswordResetEmail({required String email}) {
    authRepository
        .sendPasswordResetEmail(email: email)
        .run()
        .then((result) => result.match(
              (failure) => emit(AuthError(failure.message)),
              (_) => null,
            ));
  }

  // ─── deleteUnverifiedUser ─────────────────────────────────────────────────

  void deleteUnverifiedUser() {
    TaskEither<Failure, Unit>.tryCatch(
      () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.delete();
          emit(Unauthenticated());
        }
        return unit;
      },
      (error, _) {
        if (error is FirebaseAuthException && error.code == 'requires-recent-login') {
           return const AuthFailure('Reconnexion requise pour supprimer le compte');
        }
        return UnexpectedFailure('Erreur lors de la suppression du compte : $error');
      },
    ).run().then((result) => result.match(
      (failure) => emit(AuthError(failure.message)),
      (_) => null,
    ));
  }

  // ─── reset ────────────────────────────────────────────────────────────────

  void reset() => emit(Unauthenticated());
}

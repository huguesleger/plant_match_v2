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

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    await authRepository
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

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(AuthLoading());

    await authRepository
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

  Future<void> resendEmailVerification() async {
    await authRepository
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
  // Logique séquentielle : on extrait isEmailVerified d'abord, puis on enchaîne
  // en fp-dart pour la finalisation.

  Future<void> checkEmailVerified({String? fullName}) async {
    if (_isCheckingEmail) return;
    _isCheckingEmail = true;

    try {
      // 1. Vérifier si l'email est validé
      final verifiedResult = await authRepository.isEmailVerified().run();
      final verified = verifiedResult.getOrElse((_) => false);

      if (!verified) {
        if (_currentUser != null) {
          emit(AuthEmailVerificationSent(_currentUser!));
        } else {
          emit(Unauthenticated());
        }
        return;
      }

      // 2. Récupérer l'utilisateur Firebase courant
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        emit(AuthError('Utilisateur introuvable après vérification.'));
        return;
      }

      final resolvedName = fullName ?? _currentUser?.fullName ?? '';
      emit(AuthFinalizing(UserAuth(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        fullName: resolvedName,
      )));

      // 3. Finalisation + email de bienvenue + points initiaux
      await authRepository
          .finalizeRegistration(firebaseUser, resolvedName)
          .flatMap((isFirst) => TaskEither<Failure, Unit>.tryCatch(
                () async {
                  if (isFirst) {
                    try {
                      await welcomeEmail(firebaseUser.email!, resolvedName);
                    } catch (_) {}
                    await _addInitialPoints(firebaseUser.uid);
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
              ))
          .run()
          .then((result) => result.match(
                (failure) => emit(AuthError(failure.message)),
                (_) => null,
              ));
    } finally {
      _isCheckingEmail = false;
    }
  }

  // ─── signInWithGoogle ─────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    await authRepository
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

  Future<void> signInWithFacebook() async {
    emit(AuthLoading());

    await authRepository
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

  Future<void> logOut() async {
    await authRepository
        .logOut()
        .map((_) => emit(Unauthenticated()))
        .run()
        .then((result) => result.match(
              (failure) => emit(AuthError(failure.message)),
              (_) => null,
            ));
  }

  // ─── sendPasswordResetEmail ───────────────────────────────────────────────

  Future<void> sendPasswordResetEmail({required String email}) async {
    await authRepository
        .sendPasswordResetEmail(email: email)
        .run()
        .then((result) => result.match(
              (failure) => emit(AuthError(failure.message)),
              (_) => null,
            ));
  }

  // ─── deleteUnverifiedUser ─────────────────────────────────────────────────

  Future<void> deleteUnverifiedUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.delete();
        emit(Unauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          try {
            await user.reload();
            await user.delete();
            emit(Unauthenticated());
          } catch (e) {
            emit(AuthError('Impossible de supprimer le compte : $e'));
          }
        }
      } else {
        emit(AuthError('Erreur lors de la suppression du compte : ${e.code}'));
      }
    } catch (e) {
      emit(AuthError('Erreur inconnue : $e'));
    }
  }

  // ─── reset ────────────────────────────────────────────────────────────────

  void reset() => emit(Unauthenticated());

  // ─── _addInitialPoints ────────────────────────────────────────────────────

  Future<void> _addInitialPoints(String userId) async {
    await userPointsRepository.addPoints(userId, 25, 1).run();
  }
}

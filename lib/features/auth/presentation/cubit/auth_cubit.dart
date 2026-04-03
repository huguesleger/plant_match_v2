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
      : super(const AuthInitial());

  UserAuth? get currentUser => _currentUser;
  String? get userId => _currentUser?.uid;

  // ─── checkCurrentUser ─────────────────────────────────────────────────────

  void checkCurrentUser() {
    authRepository
        .getCurrentUser()
        .match(
          (failure) => const Unauthenticated(),
          (option) => option.match(
            () => const Unauthenticated(),
            (user) {
              _currentUser = user;
              return Authenticated(user);
            },
          ),
        )
        .map(emit)
        .run();
  }

  // ─── signInWithEmailAndPassword ───────────────────────────────────────────

  void signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    emit(const AuthLoading());

    authRepository
        .signInWithEmailAndPassword(email: email, password: password)
        .match(
          (failure) {
            emit(AuthError(failure.message));
            return const Unauthenticated();
          },
          (user) {
            _currentUser = user;
            return Authenticated(user);
          },
        )
        .map(emit)
        .run();
  }

  // ─── registerWithEmailAndPassword ─────────────────────────────────────────

  void registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) {
    emit(const AuthLoading());

    authRepository
        .registerWithEmailAndPassword(
            email: email, password: password, fullName: fullName)
        .flatMap(
            (user) => authRepository.sendEmailVerification().map((_) => user))
        .match(
          (failure) => AuthError(failure.message),
          (user) {
            _currentUser = user;
            return AuthEmailVerificationSent(user);
          },
        )
        .map(emit)
        .run();
  }

  // ─── resendEmailVerification ──────────────────────────────────────────────

  void resendEmailVerification() {
    authRepository
        .sendEmailVerification()
        .match(
          (failure) => AuthError(failure.message),
          (_) {
            if (_currentUser != null) {
              return AuthEmailVerificationSent(_currentUser!);
            } else {
              return const Unauthenticated();
            }
          },
        )
        .map(emit)
        .run();
  }

  // ─── checkEmailVerified ───────────────────────────────────────────────────

  void checkEmailVerified({String? fullName}) {
    if (_isCheckingEmail) return;
    _isCheckingEmail = true;

    authRepository
        .isEmailVerified()
        .flatMap((verified) {
          if (!verified) {
            return TaskEither.left(const AuthFailure("Email non vérifié"));
          }

          final firebaseUser = FirebaseAuth.instance.currentUser;
          if (firebaseUser == null) {
            return TaskEither.left(
                const AuthFailure("Utilisateur introuvable"));
          }

          final resolvedName = fullName ?? _currentUser?.fullName ?? '';
          final userAuth = UserAuth(
            uid: firebaseUser.uid,
            email: firebaseUser.email!,
            fullName: resolvedName,
          );

          // On émet Finalizing juste avant l'étape longue (Firestore + Email + Points)
          return TaskEither<Failure, Unit>.tryCatch(
            () async {
              emit(AuthFinalizing(userAuth));
              return unit;
            },
            (error, _) => UnexpectedFailure(error.toString()),
          ).flatMap((_) => authRepository
                  .finalizeRegistration(firebaseUser, resolvedName)
                  .flatMap((isFirst) {
                if (isFirst) {
                  return TaskEither<Failure, Unit>.tryCatch(
                    () async {
                      await welcomeEmail(userAuth.email!, resolvedName);
                      return unit;
                    },
                    (error, _) => UnexpectedFailure(
                        'Erreur lors de l’envoi de l’email de bienvenue : $error'),
                  )
                      .alt(() => TaskEither.right(unit))
                      .map((_) => Authenticated(userAuth, isFirstTime: true));
                }
                return TaskEither.right(
                    Authenticated(userAuth, isFirstTime: isFirst));
              }));
        })
        .match<AuthState>(
          (failure) {
            _isCheckingEmail = false;
            if (failure is AuthFailure &&
                failure.message == "Email non vérifié") {
              return _currentUser != null
                  ? AuthEmailVerificationSent(_currentUser!)
                  : const Unauthenticated();
            }
            return AuthError(failure.message);
          },
          (state) {
            _isCheckingEmail = false;
            if (state is Authenticated) {
              _currentUser = state.user;
            }
            return state;
          },
        )
        .map(emit)
        .run();
  }

  // ─── signInWithGoogle ─────────────────────────────────────────────────────

  void signInWithGoogle() {
    emit(const AuthLoading());

    authRepository
        .signInWithGoogle()
        .match(
          (failure) {
            emit(AuthError(failure.message));
            return const Unauthenticated();
          },
          (user) {
            _currentUser = user;
            return Authenticated(user);
          },
        )
        .map(emit)
        .run();
  }

  // ─── signInWithFacebook ───────────────────────────────────────────────────

  void signInWithFacebook() {
    emit(const AuthLoading());

    authRepository
        .signInWithFacebook()
        .match(
          (failure) {
            emit(AuthError(failure.message));
            return const Unauthenticated();
          },
          (user) {
            _currentUser = user;
            return Authenticated(user);
          },
        )
        .map(emit)
        .run();
  }

  // ─── logOut ───────────────────────────────────────────────────────────────

  void logOut() {
    authRepository
        .logOut()
        .match(
          (failure) => AuthError(failure.message),
          (_) {
            _currentUser = null;
            return const Unauthenticated();
          },
        )
        .map(emit)
        .run();
  }

  // ─── sendPasswordResetEmail ───────────────────────────────────────────────

  void sendPasswordResetEmail({required String email}) {
    authRepository
        .sendPasswordResetEmail(email: email)
        .match(
          (failure) => AuthError(failure.message),
          (_) => state, // On garde l'état actuel ou on émet un succès si besoin
        )
        .map(emit)
        .run();
  }

  // ─── deleteUnverifiedUser ─────────────────────────────────────────────────

  void deleteUnverifiedUser() {
    TaskEither<Failure, Unit>.tryCatch(
      () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.delete();
          return unit;
        }
        return unit;
      },
      (error, _) {
        if (error is FirebaseAuthException &&
            error.code == 'requires-recent-login') {
          return const AuthFailure(
              'Reconnexion requise pour supprimer le compte');
        }
        return UnexpectedFailure(
            'Erreur lors de la suppression du compte : $error');
      },
    )
        .match(
          (failure) => AuthError(failure.message),
          (_) {
            _currentUser = null;
            return const Unauthenticated();
          },
        )
        .map(emit)
        .run();
  }

  // ─── reset ────────────────────────────────────────────────────────────────

  void reset() => emit(const Unauthenticated());
}

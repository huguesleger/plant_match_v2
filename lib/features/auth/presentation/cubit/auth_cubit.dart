import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final FirebaseUserPoints userPointsRepository;

  UserAuth? _currentUser;
  bool _isCheckingEmail = false;

  AuthCubit({required this.authRepository, required this.userPointsRepository})
      : super(const AuthInitial());

  UserAuth? get currentUser => _currentUser;
  String? get userId => _currentUser?.uid;

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

  void signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    emit(const AuthLoading());

    authRepository
        .signInWithEmailAndPassword(email: email, password: password)
        .match(
      (failure) => failure is AuthProfileMissingFailure
          ? _resumeRegistration()
          : _fail(failure.message, const Unauthenticated()),
      (user) {
        _currentUser = user;
        emit(Authenticated(user));
      },
    ).run();
  }

  void _resumeRegistration() => Option.fromNullable(
        FirebaseAuth.instance.currentUser,
      ).match(
        () => emit(const Unauthenticated()),
        (firebaseUser) {
          final user = UserAuth(
            uid: firebaseUser.uid,
            email: Option.fromNullable(firebaseUser.email),
            firstName: '',
            lastName: '',
          );
          _currentUser = user;
          emit(AuthEmailVerificationSent(user));
          checkEmailVerified();
        },
      );

  void registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    emit(const AuthLoading());

    authRepository
        .registerWithEmailAndPassword(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName)
        .flatMap(
            (user) => authRepository.sendEmailVerification().map((_) => user))
        .match(
      (failure) => _fail(failure.message, const Unauthenticated()),
      (user) {
        _currentUser = user;
        emit(AuthEmailVerificationSent(user));
      },
    ).run();
  }

  TaskEither<Failure, Unit> resendEmailVerification() =>
      authRepository.sendEmailVerification();

  void checkEmailVerified({String? fullName}) {
    if (_isCheckingEmail) return;
    _isCheckingEmail = true;

    authRepository.isEmailVerified().flatMap((verified) {
      if (!verified) {
        return TaskEither.left(const AuthEmailNotVerifiedFailure());
      }

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        return TaskEither.left(const AuthFailure("Utilisateur introuvable"));
      }

      final resolvedName = fullName ?? _currentUser?.fullName ?? '';
      final userAuth = UserAuth.fromFullName(
        uid: firebaseUser.uid,
        email: Option.fromNullable(firebaseUser.email),
        fullName: resolvedName,
      );

      return TaskEither<Failure, UserAuth>.right(userAuth).flatMap((u) =>
          authRepository
              .finalizeRegistration(firebaseUser, u.firstName, u.lastName)
              .flatMap<Authenticated>((isFirst) {
            // L'email de bienvenue est envoyé par la Cloud Function
            // sendWelcomeEmail à la création du document users/{uid}.
            return TaskEither<Failure, Authenticated>.right(
                Authenticated(u, isFirstTime: isFirst));
          }));
    }).match(
      (failure) {
        _isCheckingEmail = false;
        final pending = _currentUser != null
            ? AuthEmailVerificationSent(_currentUser!)
            : const Unauthenticated();
        failure is AuthEmailNotVerifiedFailure
            ? emit(pending)
            : _fail(failure.message, pending);
      },
      (state) {
        _isCheckingEmail = false;
        _currentUser = state.user;
        emit(state);
      },
    ).run();
  }

  void signInWithGoogle() {
    emit(const AuthLoading());

    authRepository.signInWithGoogle().match(
      (failure) => _fail(failure.message, const Unauthenticated()),
      (result) {
        _currentUser = result.$1;
        emit(Authenticated(result.$1, isFirstTime: result.$2));
      },
    ).run();
  }

  void signInWithFacebook() {
    emit(const AuthLoading());

    authRepository.signInWithFacebook().match(
      (failure) => _fail(failure.message, const Unauthenticated()),
      (result) {
        _currentUser = result.$1;
        emit(Authenticated(result.$1, isFirstTime: result.$2));
      },
    ).run();
  }

  Future<void> logOut() {
    final previous = state;
    return authRepository.logOut().match(
      (failure) => _fail(failure.message, previous),
      (_) {
        _currentUser = null;
        emit(const Unauthenticated());
      },
    ).run();
  }

  TaskEither<Failure, Unit> sendPasswordResetEmail({required String email}) =>
      authRepository.sendPasswordResetEmail(email: email);

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
      (error, _) => (error is FirebaseAuthException &&
              error.code == 'requires-recent-login')
          ? const AuthFailure('Reconnexion requise pour supprimer le compte')
          : UnexpectedFailure(
              'Erreur lors de la suppression du compte : $error'),
    ).match(
      (failure) => _fail(failure.message, const Unauthenticated()),
      (_) {
        _currentUser = null;
        emit(const Unauthenticated());
      },
    ).run();
  }

  void reset() => emit(const Unauthenticated());

  void _fail(String message, AuthState recovery) {
    emit(AuthError(message));
    emit(recovery);
  }
}

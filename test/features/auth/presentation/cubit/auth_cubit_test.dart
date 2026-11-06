import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockFirebaseUserPoints extends Mock implements FirebaseUserPoints {}

void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;
  late MockFirebaseUserPoints mockFirebaseUserPoints;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockFirebaseUserPoints = MockFirebaseUserPoints();
    authCubit = AuthCubit(
      authRepository: mockAuthRepository,
      userPointsRepository: mockFirebaseUserPoints,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  final tUser = UserAuth(
    uid: '123',
    email: const Some('test@example.com'),
    firstName: 'John',
    lastName: 'Doe',
  );

  group('AuthCubit', () {
    test('létat initial devrait être AuthInitial()', () {
      expect(authCubit.state, const AuthInitial());
    });

    group('checkCurrentUser', () {
      blocTest<AuthCubit, AuthState>(
        'doit émettre [Authenticated] quand lutilisateur est récupéré',
        build: () {
          when(() => mockAuthRepository.getCurrentUser())
              .thenReturn(TaskEither.right(Some(tUser)));
          return authCubit;
        },
        act: (cubit) => cubit.checkCurrentUser(),
        expect: () => [
          isA<Authenticated>().having((s) => s.user, 'user', tUser),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.getCurrentUser()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'doit émettre [Unauthenticated] quand aucun utilisateur nest trouvé (None)',
        build: () {
          when(() => mockAuthRepository.getCurrentUser())
              .thenReturn(TaskEither.right(const None()));
          return authCubit;
        },
        act: (cubit) => cubit.checkCurrentUser(),
        expect: () => [
          isA<Unauthenticated>(),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'doit émettre [Unauthenticated] lors dune erreur de récupération',
        build: () {
          when(() => mockAuthRepository.getCurrentUser())
              .thenReturn(TaskEither.left(const UnexpectedFailure('Erreur serveur')));
          return authCubit;
        },
        act: (cubit) => cubit.checkCurrentUser(),
        expect: () => [
          isA<Unauthenticated>(),
        ],
      );
    });

    group('signInWithEmailAndPassword', () {
      const tEmail = 'test@example.com';
      const tPassword = 'password123';

      blocTest<AuthCubit, AuthState>(
        'doit émettre [AuthLoading, Authenticated] en cas de succès',
        build: () {
          when(() => mockAuthRepository.signInWithEmailAndPassword(
                email: tEmail,
                password: tPassword,
              )).thenReturn(TaskEither.right(tUser));
          return authCubit;
        },
        act: (cubit) => cubit.signInWithEmailAndPassword(
            email: tEmail, password: tPassword),
        expect: () => [
          isA<AuthLoading>(),
          isA<Authenticated>().having((s) => s.user, 'user', tUser),
        ],
        verify: (_) {
          expect(authCubit.currentUser, equals(Some(tUser)));
        },
      );

      blocTest<AuthCubit, AuthState>(
        'doit émettre [AuthLoading, AuthError] en cas déchec',
        build: () {
          when(() => mockAuthRepository.signInWithEmailAndPassword(
                email: tEmail,
                password: tPassword,
              )).thenReturn(TaskEither.left(const AuthInvalidCredentialsFailure('invalid-credential')));
          return authCubit;
        },
        act: (cubit) => cubit.signInWithEmailAndPassword(
            email: tEmail, password: tPassword),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.failure,
            'failure',
            isA<AuthInvalidCredentialsFailure>(),
          ),
          isA<Unauthenticated>(),
        ],
      );
    });

    group('signInWithGoogle', () {
      blocTest<AuthCubit, AuthState>(
        'doit émettre [AuthLoading, Authenticated] en cas de succès',
        build: () {
          when(() => mockAuthRepository.signInWithGoogle())
              .thenReturn(TaskEither.right((tUser, false)));
          return authCubit;
        },
        act: (cubit) => cubit.signInWithGoogle(),
        expect: () => [
          isA<AuthLoading>(),
          isA<Authenticated>().having((s) => s.user, 'user', tUser),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'doit émettre [AuthLoading, AuthError] en cas déchec',
        build: () {
          when(() => mockAuthRepository.signInWithGoogle())
              .thenReturn(TaskEither.left(const AuthProviderFailure('Erreur Google')));
          return authCubit;
        },
        act: (cubit) => cubit.signInWithGoogle(),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.failure,
            'failure',
            isA<AuthProviderFailure>(),
          ),
          isA<Unauthenticated>(),
        ],
      );
    });

    group('signInWithGoogle annulé', () {
      blocTest<AuthCubit, AuthState>(
        'doit émettre [AuthLoading, Unauthenticated] sans AuthError',
        build: () {
          when(() => mockAuthRepository.signInWithGoogle()).thenReturn(
              TaskEither.left(const AuthCancelledFailure('cancelled')));
          return authCubit;
        },
        act: (cubit) => cubit.signInWithGoogle(),
        expect: () => [
          isA<AuthLoading>(),
          isA<Unauthenticated>(),
        ],
      );
    });

    group('signInWithFacebook', () {
      blocTest<AuthCubit, AuthState>(
        'doit émettre [AuthLoading, Authenticated] en cas de succès',
        build: () {
          when(() => mockAuthRepository.signInWithFacebook())
              .thenReturn(TaskEither.right((tUser, false)));
          return authCubit;
        },
        act: (cubit) => cubit.signInWithFacebook(),
        expect: () => [
          isA<AuthLoading>(),
          isA<Authenticated>().having((s) => s.user, 'user', tUser),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'doit émettre [AuthLoading, AuthError] en cas déchec',
        build: () {
          when(() => mockAuthRepository.signInWithFacebook())
              .thenReturn(TaskEither.left(const AuthProviderFailure('Erreur Facebook')));
          return authCubit;
        },
        act: (cubit) => cubit.signInWithFacebook(),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.failure,
            'failure',
            isA<AuthProviderFailure>(),
          ),
          isA<Unauthenticated>(),
        ],
      );
    });

    group('logOut', () {
      blocTest<AuthCubit, AuthState>(
        'doit émettre [Unauthenticated] et réinitialiser currentUser',
        build: () {
          when(() => mockAuthRepository.logOut())
              .thenReturn(TaskEither.right(unit));
          return authCubit;
        },
        seed: () => Authenticated(tUser),
        act: (cubit) => cubit.logOut(),
        expect: () => [
          isA<Unauthenticated>(),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.logOut()).called(1);
          expect(authCubit.currentUser, equals(const None()));
        },
      );
    });
  });
}

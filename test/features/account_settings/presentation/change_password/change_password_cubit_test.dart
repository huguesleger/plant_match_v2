import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/cubit/change_password_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/cubit/change_password_state.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() => authRepository = MockAuthRepository());

  ChangePasswordCubit buildCubit() =>
      ChangePasswordCubit(authRepository: authRepository);

  group('changePassword', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'émet [InProgress, Success] quand le mot de passe est modifié',
      build: () {
        when(() => authRepository.changePassword(
              currentPassword: 'old',
              newPassword: 'New1!pass',
            )).thenReturn(TaskEither.right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.changePassword(
          currentPassword: 'old', newPassword: 'New1!pass'),
      expect: () =>
          [isA<ChangePasswordInProgress>(), isA<ChangePasswordSuccess>()],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'émet [InProgress, Failure] quand le mot de passe actuel est faux',
      build: () {
        when(() => authRepository.changePassword(
              currentPassword: any(named: 'currentPassword'),
              newPassword: any(named: 'newPassword'),
            )).thenReturn(TaskEither.left(
          const AuthInvalidCredentialsFailure('wrong-password'),
        ));
        return buildCubit();
      },
      act: (cubit) => cubit.changePassword(
          currentPassword: 'bad', newPassword: 'New1!pass'),
      expect: () => [
        isA<ChangePasswordInProgress>(),
        isA<ChangePasswordFailure>().having(
          (state) => state.failure,
          'failure',
          isA<AuthInvalidCredentialsFailure>(),
        ),
      ],
    );
  });

  group('createPassword', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'émet [InProgress, Success] quand le mot de passe est créé',
      build: () {
        when(() => authRepository.createPassword(password: 'New1!pass'))
            .thenReturn(TaskEither.right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.createPassword(newPassword: 'New1!pass'),
      expect: () =>
          [isA<ChangePasswordInProgress>(), isA<ChangePasswordSuccess>()],
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      "émet [InProgress, Failure] quand la reconnexion est annulée",
      build: () {
        when(() =>
                authRepository.createPassword(password: any(named: 'password')))
            .thenReturn(TaskEither.left(const AuthCancelledFailure('cancel')));
        return buildCubit();
      },
      act: (cubit) => cubit.createPassword(newPassword: 'New1!pass'),
      expect: () =>
          [isA<ChangePasswordInProgress>(), isA<ChangePasswordFailure>()],
    );
  });
}

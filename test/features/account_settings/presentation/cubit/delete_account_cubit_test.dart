import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/delete_account_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/delete_account_state.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() => authRepository = MockAuthRepository());

  test("l'état initial est DeleteAccountIdle", () {
    expect(
      DeleteAccountCubit(authRepository: authRepository).state,
      isA<DeleteAccountIdle>(),
    );
  });

  blocTest<DeleteAccountCubit, DeleteAccountState>(
    'émet [InProgress, Success] quand la suppression réussit',
    build: () {
      when(() => authRepository.deleteAccount())
          .thenReturn(TaskEither.right(unit));
      return DeleteAccountCubit(authRepository: authRepository);
    },
    act: (cubit) => cubit.deleteAccount(),
    expect: () => [isA<DeleteAccountInProgress>(), isA<DeleteAccountSuccess>()],
  );

  blocTest<DeleteAccountCubit, DeleteAccountState>(
    'émet [InProgress, Failure] quand la suppression échoue',
    build: () {
      when(() => authRepository.deleteAccount())
          .thenReturn(TaskEither.left(const NetworkFailure('offline')));
      return DeleteAccountCubit(authRepository: authRepository);
    },
    act: (cubit) => cubit.deleteAccount(),
    expect: () => [
      isA<DeleteAccountInProgress>(),
      isA<DeleteAccountFailure>().having(
        (state) => state.failure,
        'failure',
        isA<NetworkFailure>(),
      ),
    ],
  );
}

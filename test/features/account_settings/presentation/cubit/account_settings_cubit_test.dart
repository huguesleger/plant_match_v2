import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:plant_match_v2/features/auth/domain/entities/password_status.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() => authRepository = MockAuthRepository());

  test("l'état initial est le statut du mot de passe du compte", () {
    when(() => authRepository.passwordStatus())
        .thenReturn(const PasswordMissing('a@b.c'));
    expect(
      AccountSettingsCubit(authRepository: authRepository).state,
      isA<PasswordMissing>(),
    );
  });

  blocTest<AccountSettingsCubit, PasswordStatus>(
    'refresh émet PasswordSet une fois le mot de passe créé',
    setUp: () => when(() => authRepository.passwordStatus())
        .thenReturn(const PasswordMissing('a@b.c')),
    build: () => AccountSettingsCubit(authRepository: authRepository),
    act: (cubit) {
      when(() => authRepository.passwordStatus())
          .thenReturn(const PasswordSet());
      cubit.refresh();
    },
    expect: () => [isA<PasswordSet>()],
  );
}

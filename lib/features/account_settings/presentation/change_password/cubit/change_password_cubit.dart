import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/cubit/change_password_state.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class ChangePasswordCubit extends SafeCubit<ChangePasswordState> {
  ChangePasswordCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const ChangePasswordIdle());

  final AuthRepository _authRepository;

  void changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    emit(const ChangePasswordInProgress());
    _authRepository
        .changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        )
        .match<ChangePasswordState>(
          ChangePasswordFailure.new,
          (_) => const ChangePasswordSuccess(),
        )
        .map(emit)
        .run();
  }

  void createPassword({required String newPassword}) {
    emit(const ChangePasswordInProgress());
    _authRepository
        .createPassword(password: newPassword)
        .match<ChangePasswordState>(
          ChangePasswordFailure.new,
          (_) => const ChangePasswordSuccess(),
        )
        .map(emit)
        .run();
  }
}

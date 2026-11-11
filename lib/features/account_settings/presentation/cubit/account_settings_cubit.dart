import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/auth/domain/entities/password_status.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class AccountSettingsCubit extends SafeCubit<PasswordStatus> {
  AccountSettingsCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(authRepository.passwordStatus());

  final AuthRepository _authRepository;

  void refresh() => emit(_authRepository.passwordStatus());
}

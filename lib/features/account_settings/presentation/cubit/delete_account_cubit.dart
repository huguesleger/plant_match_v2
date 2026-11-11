import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/delete_account_state.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class DeleteAccountCubit extends SafeCubit<DeleteAccountState> {
  DeleteAccountCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const DeleteAccountIdle());

  final AuthRepository _authRepository;

  void deleteAccount() {
    emit(const DeleteAccountInProgress());
    _authRepository
        .deleteAccount()
        .match<DeleteAccountState>(
          DeleteAccountFailure.new,
          (_) => const DeleteAccountSuccess(),
        )
        .map(emit)
        .run();
  }
}

import 'package:plant_match_v2/core/failures/failure.dart';

sealed class DeleteAccountState {
  const DeleteAccountState();
}

class DeleteAccountIdle extends DeleteAccountState {
  const DeleteAccountIdle();
}

class DeleteAccountInProgress extends DeleteAccountState {
  const DeleteAccountInProgress();
}

class DeleteAccountSuccess extends DeleteAccountState {
  const DeleteAccountSuccess();
}

class DeleteAccountFailure extends DeleteAccountState {
  const DeleteAccountFailure(this.failure);

  final Failure failure;
}

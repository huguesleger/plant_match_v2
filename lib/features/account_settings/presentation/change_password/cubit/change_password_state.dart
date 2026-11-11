import 'package:plant_match_v2/core/failures/failure.dart';

sealed class ChangePasswordState {
  const ChangePasswordState();
}

class ChangePasswordIdle extends ChangePasswordState {
  const ChangePasswordIdle();
}

class ChangePasswordInProgress extends ChangePasswordState {
  const ChangePasswordInProgress();
}

class ChangePasswordSuccess extends ChangePasswordState {
  const ChangePasswordSuccess();
}

class ChangePasswordFailure extends ChangePasswordState {
  const ChangePasswordFailure(this.failure);

  final Failure failure;
}

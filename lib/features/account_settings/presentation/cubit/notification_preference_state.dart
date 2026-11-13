import 'package:plant_match_v2/core/failures/failure.dart';

sealed class NotificationPreferenceState {
  const NotificationPreferenceState(this.enabled);

  final bool enabled;
}

class NotificationPreferenceLoading extends NotificationPreferenceState {
  const NotificationPreferenceLoading() : super(false);
}

class NotificationPreferenceLoaded extends NotificationPreferenceState {
  const NotificationPreferenceLoaded(super.enabled);
}

class NotificationPreferenceUpdating extends NotificationPreferenceState {
  const NotificationPreferenceUpdating(super.enabled);
}

class NotificationPreferencePermissionDenied
    extends NotificationPreferenceState {
  const NotificationPreferencePermissionDenied() : super(false);
}

class NotificationPreferenceFailure extends NotificationPreferenceState {
  const NotificationPreferenceFailure(this.failure, super.enabled);

  final Failure failure;
}

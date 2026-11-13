import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/task_either_minimal_delay/task_either_minimal_delay.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/core/widgets/dots_loader/dots_loader.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/notification_preference_state.dart';
import 'package:plant_match_v2/features/notifications/domain/repositories/notification_repository.dart';

class NotificationPreferenceCubit
    extends SafeCubit<NotificationPreferenceState> {
  NotificationPreferenceCubit({
    required NotificationRepository notificationRepository,
    required Option<String> userId,
  })  : _notificationRepository = notificationRepository,
        _userId = userId,
        super(const NotificationPreferenceLoading()) {
    _lifecycleListener = AppLifecycleListener(onResume: _onResume);
  }

  final NotificationRepository _notificationRepository;
  final Option<String> _userId;
  late final AppLifecycleListener _lifecycleListener;

  TaskEither<Failure, String> get _currentUserId => TaskEither.fromOption(
        _userId,
        () => const SessionExpiredFailure('No authenticated user'),
      );

  void load() {
    _currentUserId
        .flatMap(_loadPreference)
        .match<NotificationPreferenceState>(
          (failure) => NotificationPreferenceFailure(failure, false),
          identity,
        )
        .map(emit)
        .run();
  }

  TaskEither<Failure, NotificationPreferenceState> _loadPreference(
    String userId,
  ) =>
      _notificationRepository.isPermissionGranted().flatMap(
            (granted) => granted
                ? _notificationRepository
                    .areNotificationsEnabled(userId)
                    .map(NotificationPreferenceLoaded.new)
                : TaskEither.right(
                    const NotificationPreferencePermissionDenied(),
                  ),
          );

  void toggle() => setEnabled(!state.enabled);

  void openSettings() =>
      _notificationRepository.openNotificationSettings().run();

  void _onResume() => switch (state) {
        NotificationPreferencePermissionDenied() =>
          _enableIfPermissionGranted(),
        NotificationPreferenceLoaded() => load(),
        NotificationPreferenceLoading() ||
        NotificationPreferenceUpdating() ||
        NotificationPreferenceFailure() =>
          null,
      };

  void _enableIfPermissionGranted() => _notificationRepository
      .isPermissionGranted()
      .match(
        (_) => unit,
        (granted) => granted ? _enableAfterSettings() : unit,
      )
      .run();

  Unit _enableAfterSettings() {
    setEnabled(true);
    return unit;
  }

  void setEnabled(bool enabled) {
    final previous = state.enabled;
    emit(NotificationPreferenceUpdating(enabled));
    _currentUserId
        .flatMap((userId) => enabled ? _enable(userId) : _disable(userId))
        .withMinimalDelay(DotsLoader.minDuration)
        .match<NotificationPreferenceState>(
          (failure) => NotificationPreferenceFailure(failure, previous),
          identity,
        )
        .map(emit)
        .run();
  }

  TaskEither<Failure, NotificationPreferenceState> _enable(String userId) =>
      _notificationRepository.requestPermission().flatMap(
            (granted) => granted
                ? _notificationRepository
                    .enableNotifications(userId)
                    .map((_) => const NotificationPreferenceLoaded(true))
                : TaskEither.right(
                    const NotificationPreferencePermissionDenied(),
                  ),
          );

  TaskEither<Failure, NotificationPreferenceState> _disable(String userId) =>
      _notificationRepository
          .setNotificationsEnabled(userId, false)
          .map((_) => const NotificationPreferenceLoaded(false));

  @override
  Future<void> close() {
    _lifecycleListener.dispose();
    return super.close();
  }
}

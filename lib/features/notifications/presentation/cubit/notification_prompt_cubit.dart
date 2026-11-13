import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/notifications/domain/repositories/notification_repository.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_prompt_state.dart';

class NotificationPromptCubit extends SafeCubit<NotificationPromptState> {
  NotificationPromptCubit({
    required NotificationRepository notificationRepository,
    required String userId,
  })  : _notificationRepository = notificationRepository,
        _userId = userId,
        super(const NotificationPromptIdle()) {
    _lifecycleListener = AppLifecycleListener(onResume: _onResume);
  }

  final NotificationRepository _notificationRepository;
  final String _userId;
  late final AppLifecycleListener _lifecycleListener;

  void maybePrompt() => state is NotificationPromptIdle ? _check() : null;

  void _check() {
    emit(const NotificationPromptChecking());
    _shouldPrompt()
        .flatMap(
          (should) => should
              ? _notificationRepository
                  .markPromptShown()
                  .map<NotificationPromptState>(
                    (_) => const NotificationPromptVisible(),
                  )
              : TaskEither.right(const NotificationPromptDone()),
        )
        .match((_) => const NotificationPromptDone(), identity)
        .map(emit)
        .run();
  }

  TaskEither<Failure, bool> _shouldPrompt() =>
      _notificationRepository.hasPromptBeenShown().flatMap(
            (shown) => shown
                ? TaskEither.right(false)
                : _notificationRepository.isPermissionGranted().flatMap(
                      (granted) => granted
                          ? TaskEither.right(false)
                          : _notificationRepository
                              .areNotificationsEnabled(_userId),
                    ),
          );

  void accept() => _notificationRepository
      .requestPermission()
      .flatMap(
        (granted) => granted
            ? _notificationRepository
                .enableNotifications(_userId)
                .map<NotificationPromptState>(
                  (_) => const NotificationPromptDone(),
                )
            : _notificationRepository
                .openNotificationSettings()
                .map((_) => const NotificationPromptAwaitingSettings()),
      )
      .match((_) => const NotificationPromptDone(), identity)
      .map(emit)
      .run();

  void decline() => emit(const NotificationPromptDone());

  void _onResume() =>
      state is NotificationPromptAwaitingSettings ? _enableIfGranted() : null;

  void _enableIfGranted() => _notificationRepository
      .isPermissionGranted()
      .flatMap(
        (granted) => granted
            ? _notificationRepository.enableNotifications(_userId)
            : TaskEither.right(unit),
      )
      .match(
        (_) => const NotificationPromptDone(),
        (_) => const NotificationPromptDone(),
      )
      .map(emit)
      .run();

  @override
  Future<void> close() {
    _lifecycleListener.dispose();
    return super.close();
  }
}

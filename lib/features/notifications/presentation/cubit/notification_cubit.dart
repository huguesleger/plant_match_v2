import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/notifications/domain/entities/app_notification.dart';
import 'package:plant_match_v2/features/notifications/domain/repositories/notification_repository.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_state.dart';

class NotificationCubit extends SafeCubit<NotificationState> {
  final NotificationRepository _notificationRepository;
  Option<StreamSubscription<AppNotification>> _notificationSubscription =
      const None();
  Option<StreamSubscription<String>> _tokenRefreshSubscription = const None();

  NotificationCubit({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const NotificationInitial());

  void initialize() {
    _notificationRepository
        .initializeLocalNotifications()
        .map((_) => _listenNotifications())
        .match(
          (failure) => Option.of(NotificationError(failure)),
          (_) => const None(),
        )
        .map((error) => error.map(emit))
        .run();
  }

  Unit _listenNotifications() {
    _cancelNotificationSubscription();
    _notificationSubscription = Some(
      _notificationRepository.onNotificationReceived.listen(
        (notification) {},
      ),
    );
    return unit;
  }

  void requestPermissionAndSaveToken(String userId) {
    _notificationRepository
        .requestPermission()
        .flatMap((granted) {
          if (!granted) {
            return TaskEither<Failure, NotificationState>.right(
                const NotificationPermissionDenied());
          }
          return _notificationRepository.getFCMToken().flatMap((optionToken) {
            return optionToken.match(
              () => TaskEither<Failure, NotificationState>.right(
                  const NotificationPermissionDenied()),
              (token) => _notificationRepository
                  .saveTokenToUser(userId, token)
                  .map((_) => _watchTokenRefresh(userId))
                  .map((_) => NotificationPermissionGranted(token)),
            );
          });
        })
        .match(
          (failure) => NotificationError(failure),
          (state) => state,
        )
        .map(emit)
        .run();
  }

  void _watchTokenRefresh(String userId) {
    _cancelTokenRefresh();
    _tokenRefreshSubscription = Some(
      _notificationRepository.onTokenRefresh.listen(
        (token) => _notificationRepository.saveTokenToUser(userId, token).run(),
      ),
    );
  }

  void stopTokenRefresh() => _cancelTokenRefresh();

  void _cancelNotificationSubscription() {
    _notificationSubscription.map((subscription) => subscription.cancel());
    _notificationSubscription = const None();
  }

  void _cancelTokenRefresh() {
    _tokenRefreshSubscription.map((subscription) => subscription.cancel());
    _tokenRefreshSubscription = const None();
  }

  Future<void> removeTokenAndLogout(String userId) {
    _cancelTokenRefresh();
    return _notificationRepository
        .getFCMToken()
        .flatMap((optionToken) => optionToken.match(
              () => TaskEither<Failure, Unit>.right(unit),
              (token) =>
                  _notificationRepository.deleteTokenFromUser(userId, token),
            ))
        .match(
          (failure) => NotificationError(failure),
          (_) => const NotificationInitial(),
        )
        .map(emit)
        .run();
  }

  @override
  Future<void> close() {
    _cancelNotificationSubscription();
    _cancelTokenRefresh();
    return super.close();
  }
}

extension NotificationStateMatch on NotificationState {
  T match<T>({
    required T Function(NotificationInitial initial) initial,
    required T Function(NotificationPermissionGranted granted) granted,
    required T Function(NotificationPermissionDenied denied) denied,
    required T Function(NotificationError error) error,
  }) {
    final state = this;
    return switch (state) {
      NotificationInitial() => initial(state),
      NotificationPermissionGranted() => granted(state),
      NotificationPermissionDenied() => denied(state),
      NotificationError() => error(state),
    };
  }
}

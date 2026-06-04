import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/notifications/domain/entities/app_notification.dart';
import 'package:plant_match_v2/features/notifications/domain/repositories/notification_repository.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_state.dart';

class NotificationCubit extends SafeCubit<NotificationState> {
  final NotificationRepository _notificationRepository;
  StreamSubscription<AppNotification>? _notificationSubscription;

  NotificationCubit({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const NotificationInitial());

  /// Initialise la configuration des notifications locales et commence l'écoute.
  void initialize() {
    _notificationRepository.initializeLocalNotifications().match(
      (failure) => emit(NotificationError(failure.message)),
      (_) {
        _notificationSubscription?.cancel();
        _notificationSubscription = _notificationRepository.onNotificationReceived.listen(
          (notification) {
            // Optionnel : Gérer des actions spécifiques dans l'app lors de la réception
          },
        );
      },
    ).run();
  }

  /// Demande la permission de notification et sauvegarde le jeton FCM de l'utilisateur.
  void requestPermissionAndSaveToken(String userId) {
    _notificationRepository.requestPermission().flatMap((granted) {
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
              .map((_) => NotificationPermissionGranted(token)),
        );
      });
    }).match(
      (failure) => NotificationError(failure.message),
      (state) => state,
    ).map(emit).run();
  }

  /// Supprime le jeton FCM de l'utilisateur (lors de la déconnexion).
  void removeTokenAndLogout(String userId) {
    state.match(
      initial: (initial) => TaskEither<Failure, Unit>.right(unit),
      granted: (granted) => _notificationRepository.deleteTokenFromUser(userId, granted.token),
      denied: (denied) => TaskEither<Failure, Unit>.right(unit),
      error: (error) => TaskEither<Failure, Unit>.right(unit),
    ).match(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(const NotificationInitial()),
    ).run();
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}

/// Extension sur [NotificationState] pour faciliter le pattern matching exhaustif
/// selon les règles du projet (pas de switch par défaut, utilisation de expressions de type match).
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

import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/notifications/domain/entities/app_notification.dart';

abstract class NotificationRepository {
  TaskEither<Failure, bool> requestPermission();

  TaskEither<Failure, bool> isPermissionGranted();

  TaskEither<Failure, Unit> openNotificationSettings();

  TaskEither<Failure, Option<String>> getFCMToken();

  TaskEither<Failure, Unit> saveTokenToUser(String userId, String token);

  TaskEither<Failure, Unit> deleteTokenFromUser(String userId, String token);

  TaskEither<Failure, bool> areNotificationsEnabled(String userId);

  TaskEither<Failure, Unit> setNotificationsEnabled(
    String userId,
    bool enabled,
  );

  TaskEither<Failure, Unit> enableNotifications(String userId);

  TaskEither<Failure, bool> hasPromptBeenShown();

  TaskEither<Failure, Unit> markPromptShown();

  TaskEither<Failure, Unit> initializeLocalNotifications();

  Stream<AppNotification> get onNotificationReceived;

  Stream<String> get onTokenRefresh;
}

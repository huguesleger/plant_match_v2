import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/notifications/domain/entities/app_notification.dart';

abstract class NotificationRepository {
  TaskEither<Failure, bool> requestPermission();

  TaskEither<Failure, Option<String>> getFCMToken();

  TaskEither<Failure, Unit> saveTokenToUser(String userId, String token);

  TaskEither<Failure, Unit> deleteTokenFromUser(String userId, String token);

  TaskEither<Failure, Unit> initializeLocalNotifications();

  Stream<AppNotification> get onNotificationReceived;

  Stream<String> get onTokenRefresh;
}

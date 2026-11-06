import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/features/notifications/data/datasources/fcm_remote_datasource.dart';
import 'package:plant_match_v2/features/notifications/domain/entities/app_notification.dart';
import 'package:plant_match_v2/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FcmRemoteDataSource _remoteDataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  NotificationRepositoryImpl({required FcmRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  TaskEither<Failure, bool> requestPermission() {
    return TaskEither.tryCatch(
      () async {
        final settings = await _remoteDataSource.requestPermission();
        return settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Option<String>> getFCMToken() {
    return TaskEither.tryCatch(
      () => _remoteDataSource.getToken(),
      (error, _) => mapError(error),
    );
  }

  DocumentReference<Map<String, dynamic>> _messagingDoc(String userId) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('private')
          .doc('messaging');

  @override
  TaskEither<Failure, Unit> saveTokenToUser(String userId, String token) {
    return TaskEither.tryCatch(
      () async {
        await _messagingDoc(userId).set({
          'fcmTokens': FieldValue.arrayUnion([token]),
        }, SetOptions(merge: true));
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> deleteTokenFromUser(String userId, String token) {
    return TaskEither.tryCatch(
      () async {
        await _messagingDoc(userId).set({
          'fcmTokens': FieldValue.arrayRemove([token]),
        }, SetOptions(merge: true));
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> initializeLocalNotifications() {
    return TaskEither.tryCatch(
      () async {
        await _remoteDataSource.initializeLocalNotifications();
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  Stream<String> get onTokenRefresh => _remoteDataSource.onTokenRefresh;

  @override
  Stream<AppNotification> get onNotificationReceived {
    return _remoteDataSource.onMessage.map(_mapRemoteMessage);
  }

  AppNotification _mapRemoteMessage(RemoteMessage message) {
    return AppNotification(
      id: Option.fromNullable(message.messageId).getOrElse(() => _uuid.v4()),
      title: Option.fromNullable(message.notification)
          .flatMap((notification) => Option.fromNullable(notification.title))
          .getOrElse(() => ''),
      body: Option.fromNullable(message.notification)
          .flatMap((notification) => Option.fromNullable(notification.body)),
      payload: message.data,
    );
  }
}

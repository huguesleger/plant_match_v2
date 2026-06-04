import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
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
      (error, stackTrace) => FirebaseFailure(
          'Erreur lors de la demande d’autorisation de notification : $error'),
    );
  }

  @override
  TaskEither<Failure, Option<String>> getFCMToken() {
    return TaskEither.tryCatch(
      () async {
        final token = await _remoteDataSource.getToken();
        return Option.fromNullable(token);
      },
      (error, stackTrace) => FirebaseFailure(
          'Erreur lors de la récupération du token FCM : $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> saveTokenToUser(String userId, String token) {
    return TaskEither.tryCatch(
      () async {
        await _firestore.collection('users').doc(userId).set({
          'fcmTokens': FieldValue.arrayUnion([token]),
        }, SetOptions(merge: true));
        return unit;
      },
      (error, stackTrace) => FirebaseFailure(
          'Erreur lors de l’enregistrement du token dans Firestore : $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> deleteTokenFromUser(String userId, String token) {
    return TaskEither.tryCatch(
      () async {
        await _firestore.collection('users').doc(userId).update({
          'fcmTokens': FieldValue.arrayRemove([token]),
        });
        return unit;
      },
      (error, stackTrace) => FirebaseFailure(
          'Erreur lors de la suppression du token de Firestore : $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> initializeLocalNotifications() {
    return TaskEither.tryCatch(
      () async {
        await _remoteDataSource.initializeLocalNotifications();
        return unit;
      },
      (error, stackTrace) => UnexpectedFailure(
          'Erreur lors de l’initialisation des notifications locales : $error'),
    );
  }

  @override
  Stream<AppNotification> get onNotificationReceived {
    return _remoteDataSource.onMessage.map(_mapRemoteMessage);
  }

  AppNotification _mapRemoteMessage(RemoteMessage message) {
    return AppNotification(
      id: message.messageId ?? _uuid.v4(),
      title: message.notification?.title ?? '',
      body: Option.fromNullable(message.notification?.body),
      payload: message.data,
    );
  }
}

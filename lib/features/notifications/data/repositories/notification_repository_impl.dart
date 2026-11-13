import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  static const String _enabledField = 'notificationsEnabled';
  static const String _promptShownKey = 'notifications_prompt_shown';

  NotificationRepositoryImpl({required FcmRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  TaskEither<Failure, bool> requestPermission() {
    return TaskEither.tryCatch(
      () => _remoteDataSource.requestPermission().then(_isAuthorized),
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, bool> isPermissionGranted() {
    return TaskEither.tryCatch(
      () => _remoteDataSource.getNotificationSettings().then(_isAuthorized),
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> openNotificationSettings() {
    return TaskEither.tryCatch(
      () => _remoteDataSource.openAppSettings().then((_) => unit),
      (error, _) => mapError(error),
    );
  }

  bool _isAuthorized(NotificationSettings settings) =>
      settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;

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
  TaskEither<Failure, bool> areNotificationsEnabled(String userId) {
    return TaskEither.tryCatch(
      () async {
        final snapshot = await _messagingDoc(userId).get();
        return Option.fromNullable(snapshot.data())
            .flatMap((data) => Option.fromNullable(data[_enabledField]))
            .flatMap<bool>(
              (value) => value is bool ? Some(value) : const None(),
            )
            .getOrElse(() => true);
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> setNotificationsEnabled(
    String userId,
    bool enabled,
  ) {
    return TaskEither.tryCatch(
      () async {
        await _messagingDoc(userId).set({
          _enabledField: enabled,
        }, SetOptions(merge: true));
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> enableNotifications(String userId) =>
      setNotificationsEnabled(userId, true)
          .flatMap((_) => _saveCurrentToken(userId))
          .map((_) => unit);

  TaskEither<Failure, Unit> _saveCurrentToken(String userId) => getFCMToken()
      .flatMap(
        (token) => token.match(
          () => TaskEither<Failure, Unit>.right(unit),
          (token) => saveTokenToUser(userId, token),
        ),
      )
      .orElse((_) => TaskEither.right(unit));

  @override
  TaskEither<Failure, bool> hasPromptBeenShown() {
    return TaskEither.tryCatch(
      () => SharedPreferences.getInstance().then(
        (prefs) => Option.fromNullable(prefs.getBool(_promptShownKey))
            .getOrElse(() => false),
      ),
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> markPromptShown() {
    return TaskEither.tryCatch(
      () => SharedPreferences.getInstance()
          .then((prefs) => prefs.setBool(_promptShownKey, true))
          .then((_) => unit),
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

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class FcmRemoteDataSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  /// Demande l'autorisation de recevoir des notifications.
  Future<NotificationSettings> requestPermission() async {
    return await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  /// Récupère le jeton FCM de l'appareil.
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Flux de notifications reçues lorsque l'app est au premier plan (FCM direct).
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Flux de clics de notifications lorsque l'app est ouverte en tâche de fond.
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// Initialise les notifications locales.
  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: false,
      defaultPresentBadge: false,
      defaultPresentSound: false,
      defaultPresentBanner: false,
      defaultPresentList: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    await _localNotifications.initialize(
      initializationSettings,
    );

    final androidPlatform = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlatform != null) {
      await androidPlatform.createNotificationChannel(_channel);
    }
  }

  /// Affiche une notification locale à partir d'un message FCM.
  Future<void> showLocalNotification(RemoteMessage message) async {
    print('FCM: Received message in foreground: ${message.messageId}');
    print('FCM: Data: ${message.data}');
    print('FCM: Notification: ${message.notification?.title} - ${message.notification?.body}');

    String? chatId;
    if (message.data['chatId'] != null) {
      chatId = message.data['chatId'] as String?;
    } else if (message.data['data'] is Map) {
      chatId = (message.data['data'] as Map)['chatId'] as String?;
    } else if (message.data['data'] is String) {
      try {
        final nestedData = jsonDecode(message.data['data'] as String);
        if (nestedData is Map) {
          chatId = nestedData['chatId'] as String?;
        }
      } catch (_) {}
    }

    print('FCM: Extracted chatId: $chatId');



    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    if (isIOS && message.notification != null) {
      print('FCM: iOS native banner already shown by OS. Skipping local notification to avoid duplicates.');
      return;
    }

    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      try {
        print('FCM: Attempting to show local notification...');
        await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: android?.smallIcon ?? '@mipmap/launcher_icon',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              presentBanner: true,
              presentList: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
        print('FCM: Local notification displayed successfully');
      } catch (e, stackTrace) {
        print('FCM: Error showing local notification: $e');
        print('FCM: StackTrace: $stackTrace');
      }
    } else {
      print('FCM: Notification object is null, cannot show banner');
    }
  }
}


import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/notifications/domain/entities/app_notification.dart';

/// Contrat du Repository pour la gestion des notifications.
abstract class NotificationRepository {
  /// Demande l'autorisation de notification à l'utilisateur.
  /// Retourne [true] si la permission est accordée, [false] sinon.
  TaskEither<Failure, bool> requestPermission();

  /// Récupère le jeton FCM de cet appareil.
  TaskEither<Failure, Option<String>> getFCMToken();

  /// Enregistre le jeton FCM d'un utilisateur connecté dans Firestore.
  TaskEither<Failure, Unit> saveTokenToUser(String userId, String token);

  /// Supprime le jeton FCM de Firestore (utilisé lors de la déconnexion).
  TaskEither<Failure, Unit> deleteTokenFromUser(String userId, String token);

  /// Initialise la configuration des notifications locales (requis pour le premier plan).
  TaskEither<Failure, Unit> initializeLocalNotifications();

  /// Retourne un flux (Stream) de notifications reçues lorsque l'application est active.
  Stream<AppNotification> get onNotificationReceived;
}

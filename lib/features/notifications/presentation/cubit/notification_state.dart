import 'package:equatable/equatable.dart';

/// États possibles pour le cycle de vie des notifications push.
sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

/// État initial.
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

/// Permission accordée avec le token FCM récupéré.
class NotificationPermissionGranted extends NotificationState {
  final String token;

  const NotificationPermissionGranted(this.token);

  @override
  List<Object?> get props => [token];
}

/// Permission de notification refusée par l'utilisateur.
class NotificationPermissionDenied extends NotificationState {
  const NotificationPermissionDenied();
}

/// Erreur survenue lors des opérations liées aux notifications.
class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

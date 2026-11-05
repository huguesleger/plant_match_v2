import 'package:equatable/equatable.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationPermissionGranted extends NotificationState {
  final String token;

  const NotificationPermissionGranted(this.token);

  @override
  List<Object> get props => [token];
}

class NotificationPermissionDenied extends NotificationState {
  const NotificationPermissionDenied();
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

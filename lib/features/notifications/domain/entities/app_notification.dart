import 'package:fpdart/fpdart.dart';

/// Représente une notification reçue par l'application.
class AppNotification {
  final String id;
  final String title;
  final Option<String> body;
  final Map<String, dynamic> payload;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  @override
  String toString() {
    return 'AppNotification(id: $id, title: $title, body: ${body.getOrElse(() => "")}, payload: $payload)';
  }
}

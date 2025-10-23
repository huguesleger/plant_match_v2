import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> welcomeEmail(String email, String fullName) async {
  final apiKey = dotenv.env['BREVO_API_KEY'];
  final senderEmail = dotenv.env['BREVO_SENDER_EMAIL'];
  final senderName = dotenv.env['BREVO_SENDER_NAME'];
  final templateId = dotenv.env['BREVO_WELCOME_TEMPLATE_ID'];

  if (apiKey == null) {
    throw Exception('Clé API Brevo manquante. Vérifie ton fichier .env');
  }

  if (templateId == null || templateId.isEmpty) {
    throw Exception("Template ID Brevo manquant. Vérifie ton fichier .env");
  }

  final url = Uri.parse('https://api.brevo.com/v3/smtp/email');

  final body = jsonEncode({
    "sender": {"name": senderName, "email": senderEmail},
    "to": [
      {"email": email, "name": fullName}
    ],
    "templateId": int.parse(templateId),
    "params": {
      "fullName": fullName,
      "senderName": senderName,
      "year": DateTime.now().year.toString()
    },
  });

  final response = await http.post(
    url,
    headers: {
      'accept': 'application/json',
      'api-key': apiKey,
      'content-type': 'application/json',
    },
    body: body,
  );

  print("📩 Brevo Response Code: ${response.statusCode}");
  print("📩 Brevo Body: ${response.body}");

  if (response.statusCode != 201) {
    throw Exception(
        'Erreur lors de l\'envoi du mail de bienvenue : ${response.body}');
  }
}

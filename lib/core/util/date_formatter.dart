import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String format(BuildContext context, DateTime date,
      {bool isHeader = false}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDay = DateTime(date.year, date.month, date.day);

    if (messageDay == today) {
      return isHeader
          ? "Aujourd'hui"
          : TimeOfDay.fromDateTime(date).format(context);
    }

    if (messageDay == yesterday) {
      return 'Hier';
    }

    if (now.difference(date).inDays < 7) {
      const days = [
        'Lundi',
        'Mardi',
        'Mercredi',
        'Jeudi',
        'Vendredi',
        'Samedi',
        'Dimanche'
      ];
      return days[date.weekday - 1];
    }

    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatTime(BuildContext context, DateTime date) {
    return TimeOfDay.fromDateTime(date).format(context);
  }
}

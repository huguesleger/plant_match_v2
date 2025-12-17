import 'package:flutter/material.dart';

String messageFormatDate(BuildContext context, DateTime date) {
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final messageDay = DateTime(date.year, date.month, date.day);

  if (messageDay == today) {
    return TimeOfDay.fromDateTime(date).format(context);
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

  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

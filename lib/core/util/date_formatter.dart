import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
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
          ? t.widgets.date.today
          : TimeOfDay.fromDateTime(date).format(context);
    }

    if (messageDay == yesterday) {
      return t.widgets.date.yesterday;
    }

    if (now.difference(date).inDays < 7) {
      return switch (date.weekday) {
        DateTime.monday => t.widgets.date.days.monday,
        DateTime.tuesday => t.widgets.date.days.tuesday,
        DateTime.wednesday => t.widgets.date.days.wednesday,
        DateTime.thursday => t.widgets.date.days.thursday,
        DateTime.friday => t.widgets.date.days.friday,
        DateTime.saturday => t.widgets.date.days.saturday,
        DateTime.sunday => t.widgets.date.days.sunday,
        _ => '',
      };
    }

    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatTime(BuildContext context, DateTime date) {
    return TimeOfDay.fromDateTime(date).format(context);
  }
}

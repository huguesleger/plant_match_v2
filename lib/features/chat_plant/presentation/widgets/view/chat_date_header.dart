import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/util/date_formatter.dart';

class ChatDateHeader extends StatelessWidget {
  const ChatDateHeader({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            DateFormatter.format(context, date, isHeader: true),
            style: const TextStyle(
              color: AppColors.greyMedium,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class ChatPlantInfoBarTemplate extends StatelessWidget {
  const ChatPlantInfoBarTemplate({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: color.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: AppTypo.textXs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

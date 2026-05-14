import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

class ValidationCodeDisplay extends StatelessWidget {
  const ValidationCodeDisplay({
    super.key,
    required this.onGenerate,
    this.code,
  });

  final VoidCallback onGenerate;
  final String? code;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenMedium.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greenMedium.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          if (code == null) ...[
            Text(
              t.chatPlant.display_code.ready_title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              t.chatPlant.display_code.ready_subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.greyDark),
            ),
            const SizedBox(height: 12),
            ButtonRounded(
              text: t.chatPlant.display_code.generate_btn,
              onPressed: onGenerate,
              bgColor: AppColors.greenDark,
              textColor: AppColors.white,
            ),
          ] else ...[
            Text(
              t.chatPlant.display_code.code_title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: code!
                  .split('')
                  .map((digit) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.greenMedium),
                        ),
                        child: Text(
                          digit,
                          style: const TextStyle(
                            fontSize: AppTypo.textM,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenDark,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text(
              t.chatPlant.display_code.code_subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.grey),
            ),
          ],
        ],
      ),
    );
  }
}

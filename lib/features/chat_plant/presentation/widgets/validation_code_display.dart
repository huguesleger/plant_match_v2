import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenMedium.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greenMedium.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          if (code == null) ...[
            const Text(
              'L\'échange est prêt !',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Générez le code une fois que vous êtes avec la personne.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onGenerate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Générer le code de remise'),
            ),
          ] else ...[
            const Text(
              'Code de confirmation',
              style: TextStyle(fontWeight: FontWeight.bold),
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
            const Text(
              'Montrez ce code au receveur pour finaliser l\'échange.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.grey),
            ),
          ],
        ],
      ),
    );
  }
}

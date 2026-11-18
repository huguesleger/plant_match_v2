import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class PetToxicityBadge extends StatelessWidget {
  const PetToxicityBadge({super.key, required this.toxicity});

  final PetToxicity toxicity;

  @override
  Widget build(BuildContext context) => switch (toxicity) {
        PetSafe() => _Badge(
            icon: LucideIcons.shield_check,
            text: t.catalog.detail.pet_safe,
            color: AppColors.greenDark,
          ),
        PetToxic() => _Badge(
            icon: LucideIcons.triangle_alert,
            text: t.catalog.detail.pet_toxic,
            color: AppColors.error,
          ),
        PetToxicityUnknown() => const SizedBox.shrink(),
      };
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppTypo.text),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: AppTypo.textXs,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
}

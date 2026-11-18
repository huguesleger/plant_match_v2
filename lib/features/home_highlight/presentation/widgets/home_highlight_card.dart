import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/widgets/highlight_content.dart';

class HomeHighlightCard extends StatelessWidget {
  const HomeHighlightCard({
    super.key,
    required this.content,
    required this.onPressed,
  });

  final HighlightContent content;
  final VoidCallback onPressed;

  bool get _isUrgent => switch (content.tone) {
        UrgentTone() => true,
        GentleTone() => false,
      };

  Color get _background =>
      _isUrgent ? AppColors.greenDark : AppColors.green.withValues(alpha: 0.08);

  Color get _titleColor => _isUrgent ? AppColors.white : AppColors.black;

  Color get _subtitleColor => _isUrgent
      ? AppColors.white.withValues(alpha: 0.9)
      : AppColors.greyDark.withValues(alpha: 0.8);

  @override
  Widget build(BuildContext context) => Material(
        color: _background,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _isUrgent ? AppColors.white : AppColors.greenDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    content.icon,
                    color: _isUrgent ? AppColors.greenDark : AppColors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: TextStyle(
                          fontSize: AppTypo.text,
                          fontWeight: FontWeight.bold,
                          color: _titleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content.subtitle,
                        style: TextStyle(
                          fontSize: AppTypo.textXs,
                          color: _subtitleColor,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        content.cta,
                        style: TextStyle(
                          fontSize: AppTypo.textXs,
                          fontWeight: FontWeight.w600,
                          color:
                              _isUrgent ? AppColors.white : AppColors.blueGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevron_right, color: _titleColor, size: 18),
              ],
            ),
          ),
        ),
      );
}

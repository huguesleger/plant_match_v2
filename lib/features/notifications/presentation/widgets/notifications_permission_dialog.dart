import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

class NotificationsPermissionDialog extends StatelessWidget {
  const NotificationsPermissionDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.confirmLabel,
  });

  final IconData icon;
  final String title;
  final String content;
  final String confirmLabel;

  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required String confirmLabel,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (_) => NotificationsPermissionDialog(
          icon: icon,
          title: title,
          content: content,
          confirmLabel: confirmLabel,
        ),
      ).then((open) => Option.fromNullable(open).getOrElse(() => false));

  static const double iconBoxSize = 72;
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 16);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconBoxSize,
              height: iconBoxSize,
              decoration: BoxDecoration(
                color: AppColors.greenLight.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppTypo.textXl,
                color: AppColors.blueGreen,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppTypo.textL,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.chillax,
                color: AppColors.blueGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.greyMedium),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ButtonOutlinedRounded(
                    onPressed: () => Navigator.of(context).pop(false),
                    text: t.widgets.notifications.later,
                    borderColor: AppColors.greyLight,
                    textColor: AppColors.greyMedium,
                    padding: buttonPadding,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ButtonRounded(
                    onPressed: Some(() => Navigator.of(context).pop(true)),
                    text: confirmLabel,
                    bgColor: AppColors.greenLight,
                    textColor: AppColors.blueGreen,
                    padding: buttonPadding,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

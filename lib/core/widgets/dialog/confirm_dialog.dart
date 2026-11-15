import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required String confirmLabel,
  bool destructive = false,
}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        destructive: destructive,
      ),
    ).then(
        (confirmed) => Option.fromNullable(confirmed).getOrElse(() => false));

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.destructive,
  });

  final String title;
  final Widget content;
  final String confirmLabel;
  final bool destructive;

  static const _buttonPadding = EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 16,
  );

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              DefaultTextStyle.merge(
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.greyMedium),
                child: content,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ButtonOutlinedRounded(
                      onPressed: () => Navigator.pop(context, false),
                      text: t.widgets.common.cancel,
                      borderColor: AppColors.greyLight,
                      textColor: AppColors.greyMedium,
                      padding: _buttonPadding,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonRounded(
                      onPressed: Some(() => Navigator.pop(context, true)),
                      text: confirmLabel,
                      bgColor:
                          destructive ? AppColors.error : AppColors.greenLight,
                      textColor:
                          destructive ? AppColors.white : AppColors.blueGreen,
                      padding: _buttonPadding,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

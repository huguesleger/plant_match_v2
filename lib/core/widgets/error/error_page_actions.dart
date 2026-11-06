import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

class ErrorPageActions extends StatelessWidget {
  const ErrorPageActions({
    super.key,
    required this.onBack,
    required this.primary,
  });

  final Option<VoidCallback> onBack;
  final Option<(String, VoidCallback)> primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...onBack.match(
          () => const <Widget>[],
          (back) => [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.greyLight),
                ),
                onPressed: back,
                icon: const Icon(
                  LucideIcons.arrow_left,
                  color: AppColors.blueGreen,
                ),
                label: Text(
                  t.widgets.error.back,
                  style: const TextStyle(color: AppColors.blueGreen),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        ...primary.match(
          () => const <Widget>[],
          (action) => [
            SizedBox(
              width: double.infinity,
              child: ButtonRounded(
                text: action.$1,
                bgColor: AppColors.blueGreen,
                textColor: AppColors.white,
                onPressed: Some(action.$2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

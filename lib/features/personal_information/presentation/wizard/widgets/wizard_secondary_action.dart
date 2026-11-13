import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class WizardSecondaryAction extends StatelessWidget {
  const WizardSecondaryAction({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  final String text;
  final bool isLoading;
  final Option<VoidCallback> onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed.toNullable(),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.blueGreen,
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.blueGreen),
              ),
      );
}

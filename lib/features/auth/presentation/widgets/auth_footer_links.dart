import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AuthFooterLinks extends StatelessWidget {
  const AuthFooterLinks({
    super.key,
    required this.mainText,
    required this.actionText,
    required this.onActionTap,
    this.forgotPasswordText,
    this.onForgotPasswordTap,
  });

  final String mainText;
  final String actionText;
  final VoidCallback onActionTap;
  final String? forgotPasswordText;
  final VoidCallback? onForgotPasswordTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (forgotPasswordText != null && onForgotPasswordTap != null) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onForgotPasswordTap,
            child: Center(
              child: Text(
                forgotPasswordText!,
                style: const TextStyle(
                  color: AppColors.blueGreen,
                  decoration: TextDecoration.underline,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 10),
        Center(
          child: GestureDetector(
            onTap: onActionTap,
            child: RichText(
              text: TextSpan(
                text: '$mainText ',
                style: const TextStyle(color: AppColors.greyDark, fontSize: 11),
                children: [
                  TextSpan(
                    text: actionText,
                    style: const TextStyle(
                      color: AppColors.blueGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

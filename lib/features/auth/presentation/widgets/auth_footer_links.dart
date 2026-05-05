import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:fpdart/fpdart.dart';

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
        Option.fromNullable(forgotPasswordText).match(
          () => const SizedBox.shrink(),
          (text) => onForgotPasswordTap != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: onForgotPasswordTap,
                    child: Center(
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: AppColors.blueGreen,
                          decoration: TextDecoration.underline,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
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

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:fpdart/fpdart.dart';

class AuthFooterLinks extends StatelessWidget {
  const AuthFooterLinks({
    super.key,
    required this.mainText,
    required this.actionText,
    required this.onActionTap,
    this.forgotPasswordText = const None(),
    this.onForgotPasswordTap = const None(),
  });

  final String mainText;
  final String actionText;
  final VoidCallback onActionTap;
  final Option<String> forgotPasswordText;
  final Option<VoidCallback> onForgotPasswordTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        forgotPasswordText.map2(onForgotPasswordTap, (text, onTap) => (text, onTap)).match(
          () => const SizedBox.shrink(),
          (link) => Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: link.$2,
              child: Center(
                child: Text(
                  link.$1,
                  style: const TextStyle(
                    color: AppColors.blueGreen,
                    decoration: TextDecoration.underline,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
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

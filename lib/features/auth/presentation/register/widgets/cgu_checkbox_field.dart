import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class CguCheckboxField extends StatelessWidget {
  const CguCheckboxField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: (value) {
              onChanged(value ?? false);
            },
          ),
          Expanded(
            child: RichText(
              strutStyle: const StrutStyle(height: 1.5),
              text: TextSpan(
                text: t.auth.register.cgu.accept,
                style: const TextStyle(color: AppColors.greyDark, fontSize: 14),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    text: t.auth.register.cgu.terms,
                    style: const TextStyle(
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: t.auth.register.cgu.and,
                    style: const TextStyle(
                      color: AppColors.greyDark,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //TODO page privacy policy
                      },
                    text: t.auth.register.cgu.privacy,
                    style: const TextStyle(
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: t.auth.register.cgu.of,
                    style: const TextStyle(
                      color: AppColors.greyDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

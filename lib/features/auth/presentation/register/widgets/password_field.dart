import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.obscureText,
    required this.onPressed,
    required this.controller,
    this.showErrors = false,
  });

  final bool obscureText;
  final VoidCallback onPressed;
  final TextEditingController controller;
  final bool showErrors;

  @override
  Widget build(BuildContext context) {
    return FancyPasswordField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return showErrors ? t.auth.common.password.required : null;
        }
        final rules = {
          MinCharactersValidationRule(8),
          DigitValidationRule(),
          UppercaseValidationRule(),
          SpecialCharacterValidationRule(),
        };
        final isAllValid = rules.every((rule) => rule.validate(value));
        if (!isAllValid) {
          return showErrors ? t.auth.register.passwordRules.error_rules : null;
        }
        return null;
      },
      validationRules: {
        MinCharactersValidationRule(8,
            customText: t.auth.register.passwordRules.minChars),
        DigitValidationRule(
          customText: t.auth.register.passwordRules.oneNumber,
        ),
        UppercaseValidationRule(
          customText: t.auth.register.passwordRules.oneUpper,
        ),
        SpecialCharacterValidationRule(
          customText: t.auth.register.passwordRules.oneSpecial,
        ),
      },
      validationRuleBuilder: (rules, value) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              children: rules.map(
                (rule) {
                  final ruleValidated = rule.validate(value);
                  final isRed = showErrors && !ruleValidated;
                  return Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: ruleValidated
                          ? const Color(0xFF0A9471)
                          : isRed
                              ? AppColors.error
                              : const Color(0xFF9A9FAF),
                    ),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rule.name,
                          style: TextStyle(
                            color: ruleValidated
                                ? const Color(0xFF0A9471)
                                : isRed
                                    ? AppColors.error
                                    : const Color(0xFF9A9FAF),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: ruleValidated
                        ? const Color(0xFFD0F7ED)
                        : isRed
                            ? const Color(0xFFFFEBEE)
                            : const Color(0xFFF4F5F6),
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
      obscureText: obscureText,
      hasStrengthIndicator: false,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: AppColors.error,
        ),
        isDense: true,
        labelText: t.auth.common.password.label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? LucideIcons.eye : LucideIcons.eye_off,
            color: AppColors.greyDark,
          ),
          onPressed: () {
            onPressed();
          },
        ),
      ),
    );
  }
}

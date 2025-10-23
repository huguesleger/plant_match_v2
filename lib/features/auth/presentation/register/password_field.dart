import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.obscureText,
    required this.onPressed,
    required this.controller,
  });

  final bool obscureText;
  final VoidCallback onPressed;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FancyPasswordField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
      validationRules: {
        MinCharactersValidationRule(8, customText: 'Au moins 8 caractères'),
        DigitValidationRule(
          customText: 'Un 1 chiffre',
        ),
        UppercaseValidationRule(
          customText: 'Une majuscule',
        ),
        SpecialCharacterValidationRule(
          customText: 'Un caractère spécial',
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
                  return Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: ruleValidated
                          ? const Color(0xFF0A9471)
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
                                : const Color(0xFF9A9FAF),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: ruleValidated
                        ? const Color(0xFFD0F7ED)
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
        isDense: true,
        labelText: 'Mot de passe',
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

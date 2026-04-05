import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/auth/presentation/register/widgets/cgu_checkbox_field.dart';

class AuthCguCheckbox extends StatelessWidget {
  const AuthCguCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: 'acceptTerms',
      initialValue: isChecked,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        (value) {
          if (value == null || value == false) {
            return 'Ce champ est requis';
          }
          return null;
        },
      ]),
      builder: (FormFieldState<bool?> field) {
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InputDecorator(
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorText: field.errorText,
              errorStyle: const TextStyle(
                color: AppColors.error,
              ),
            ),
            child: Transform(
              transform: Matrix4.translationValues(-30, 0.0, 0.0),
              child: CguCheckboxField(
                value: isChecked,
                onChanged: (val) {
                  field.didChange(val);
                  onChanged(val);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

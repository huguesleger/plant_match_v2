import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/cubit/change_password_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/change_password_submit_button.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/confirm_password_field.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/current_password_field.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/password_section_label.dart';
import 'package:plant_match_v2/features/auth/presentation/register/widgets/password_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({
    super.key,
    required this.withCurrentPassword,
  });

  final bool withCurrentPassword;

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = true;
  bool _showPasswordErrors = false;

  ChangePasswordCubit get _cubit => context.read<ChangePasswordCubit>();

  void _onSubmit() {
    setState(() => _showPasswordErrors = true);
    Option.fromNullable(_formKey.currentState)
        .filter((form) => form.saveAndValidate())
        .match(
          () => null,
          (_) => widget.withCurrentPassword
              ? _cubit.changePassword(
                  currentPassword: _currentPasswordController.text,
                  newPassword: _newPasswordController.text,
                )
              : _cubit.createPassword(newPassword: _newPasswordController.text),
        );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          if (widget.withCurrentPassword)
            CurrentPasswordField(controller: _currentPasswordController),
          PasswordSectionLabel(
            text: t.accountSettings.change_password.new_password_section,
          ),
          PasswordField(
            controller: _newPasswordController,
            labelText:
                Some(t.accountSettings.change_password.new_password_label),
            obscureText: _isPasswordVisible,
            showErrors: _showPasswordErrors,
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          const SizedBox(height: 20),
          ConfirmPasswordField(
            controller: _confirmPasswordController,
            passwordController: _newPasswordController,
          ),
          const SizedBox(height: 30),
          ChangePasswordSubmitButton(onPressed: _onSubmit),
        ],
      ),
    );
  }
}

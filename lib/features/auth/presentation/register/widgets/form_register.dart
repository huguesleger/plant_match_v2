import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/register/widgets/password_field.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in_or_register.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_email_field.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_full_name_field.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_cgu_checkbox.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_footer_links.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isPasswordVisible = true;
  bool _isChecked = false;

  void _onPressedRegister() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      context.read<AuthCubit>().registerWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
            fullName: _fullNameController.text,
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: Column(
          children: [
            AuthEmailField(controller: _emailController),
            const SizedBox(height: 20),
            AuthFullNameField(controller: _fullNameController),
            const SizedBox(height: 20),
            PasswordField(
              controller: _passwordController,
              obscureText: _isPasswordVisible,
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            const SizedBox(height: 20),
            AuthPasswordField(
              controller: _confirmPasswordController,
              labelText: t.auth.register.confirmPassword.label,
              hintText: t.auth.register.confirmPassword.hint,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: t.auth.common.password.required),
                (val) => val != _passwordController.text
                    ? t.auth.register.confirmPassword.mismatch
                    : null,
              ]),
            ),
            const SizedBox(height: 20),
            AuthCguCheckbox(
              isChecked: _isChecked,
              onChanged: (val) => setState(() => _isChecked = val ?? false),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onPressedRegister,
                child: Text(t.auth.register.title),
              ),
            ),
            AuthFooterLinks(
              mainText: t.auth.register.alreadyHaveAccount,
              actionText: t.auth.common.confirm,
              onActionTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignInOrRegister()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

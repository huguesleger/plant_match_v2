import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/forgot_password/forgot_password_page_route.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in/widgets/sign_in_with_social.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_email_field.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_footer_links.dart';

class FormSignIn extends StatefulWidget {
  const FormSignIn({super.key, required this.toggleSignInOrRegister});

  final void Function() toggleSignInOrRegister;

  @override
  State<FormSignIn> createState() => _FormSignInState();
}

class _FormSignInState extends State<FormSignIn> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onPressedSignIn() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      context.read<AuthCubit>().signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          AuthEmailField(controller: _emailController),
          const SizedBox(height: 20),
          AuthPasswordField(controller: _passwordController),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _onPressedSignIn,
              child: Text(t.auth.signIn.login),
            ),
          ),
          AuthFooterLinks(
            forgotPasswordText: t.auth.signIn.forgotPassword,
            onForgotPasswordTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ForgotPasswordPageRoute(),
              ),
            ),
            mainText: t.auth.signIn.noAccount,
            actionText: t.auth.signIn.createAccount,
            onActionTap: widget.toggleSignInOrRegister,
          ),
          const SignInWithSocial(),
        ],
      ),
    );
  }
}

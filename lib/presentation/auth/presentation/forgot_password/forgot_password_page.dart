import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/presentation/auth/presentation/email_verification/email_verification_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/forgot_password/forgot_password_screen.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return switch (state) {
        AuthInitial() || AuthLoading() => const Scaffold(
            body: SizedBox(
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        Authenticated() => const TemplatePage(),
        AuthError() => ErrorPage(errorMessage: state.message),
        Unauthenticated() => const ForgotPasswordScreen(),
        AuthEmailVerificationSent() => EmailVerificationPage(user: state.user),
      };
    });
  }
}

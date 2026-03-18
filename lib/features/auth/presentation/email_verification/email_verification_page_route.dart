import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_screen.dart';
import 'package:plant_match_v2/features/auth/presentation/register/register_screen.dart';

class EmailVerificationPageRoute extends StatelessWidget {
  final UserAuth user;

  const EmailVerificationPageRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return switch (state) {
          AuthInitial() || AuthLoading() => const Scaffold(
              body: SizedBox(
                height: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          Authenticated() => const TemplatePage(),
          AuthError() => ErrorPage(
              errorMessage: state.message,
              onPressed: () {
                context.read<AuthCubit>().reset();
              },
              onRetry: () {
                context.read<AuthCubit>().checkCurrentUser();
              },
            ),
          Unauthenticated() => const RegisterScreen(),
          AuthEmailVerificationSent() => EmailVerificationScreen(user: user),
          AuthFinalizing() => const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Finalisation de votre inscription...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        };
      },
    );
  }
}

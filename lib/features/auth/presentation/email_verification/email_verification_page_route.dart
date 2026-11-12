import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_screen.dart';
import 'package:plant_match_v2/features/auth/presentation/register/register_screen.dart';
import 'package:plant_match_v2/core/widgets/dots_loader/dots_loader.dart';

class EmailVerificationPageRoute extends StatelessWidget {
  final UserAuth user;

  const EmailVerificationPageRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is! AuthError,
      builder: (context, state) {
        return switch (state) {
          Unauthenticated() => const RegisterScreen(),
          AuthInitial() ||
          AuthLoading() ||
          Authenticated() ||
          AuthEmailVerificationSent() ||
          AuthError() =>
            EmailVerificationScreen(user: user),
          AuthFinalizing() => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const DotsLoader(),
                    const SizedBox(height: 20),
                    Text(
                      t.auth.emailVerification.finalizing,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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

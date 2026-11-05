import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_page_route.dart';
import 'package:plant_match_v2/features/auth/presentation/register/register_screen.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_error_listener.dart';

class RegisterPageRoute extends StatelessWidget {
  const RegisterPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthErrorListener(
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => current is! AuthError,
        builder: (context, state) {
          return switch (state) {
            AuthInitial() || AuthLoading() => const Scaffold(
                body: SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            Authenticated() => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            Unauthenticated() || AuthError() => const RegisterScreen(),
            AuthEmailVerificationSent(user: var u) ||
            AuthFinalizing(user: var u) =>
              EmailVerificationPageRoute(user: u),
          };
        },
      ),
    );
  }
}

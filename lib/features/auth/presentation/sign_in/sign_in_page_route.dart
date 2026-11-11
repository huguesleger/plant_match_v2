import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_page_route.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_error_listener.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_page.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_gate.dart';

class SignInPageRoute extends StatelessWidget {
  const SignInPageRoute({super.key, required this.toggleSignInOrRegister});

  final void Function() toggleSignInOrRegister;

  @override
  Widget build(BuildContext context) {
    return AuthErrorListener(
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => current is! AuthError,
        builder: (context, state) {
          return AppLoaderGate(
            isLoading: state is AuthInitial || state is AuthLoading || state is Authenticated,
            child: switch (state) {
              AuthInitial() || AuthLoading() => const Scaffold(
                  body: AppLoaderPage(),
                ),
              Authenticated() => const Scaffold(
                body: AppLoaderPage(),
              ),
              Unauthenticated() || AuthError() => SignInScreen(
                  toggleSignInOrRegister: toggleSignInOrRegister,
                ),
              AuthEmailVerificationSent(user: var u) ||
              AuthFinalizing(user: var u) =>
                EmailVerificationPageRoute(user: u),
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/dialog/app_dialog.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_page_route.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in/sign_in_screen.dart';

class SignInPageRoute extends StatelessWidget {
  const SignInPageRoute({super.key, required this.toggleSignInOrRegister});

  final void Function() toggleSignInOrRegister;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showDialog(
            context: context,
            builder: (dialogContext) => AppDialog(
              title: t.auth.common.error_title,
              textAlign: TextAlign.left,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(state.message),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonRounded(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: t.auth.common.ok,
                        bgColor: AppColors.greenLight,
                        textColor: AppColors.blueGreen,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          AuthInitial() || AuthLoading() => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          Authenticated() => const TemplatePage(),
          Unauthenticated() => SignInScreen(
              toggleSignInOrRegister: toggleSignInOrRegister,
            ),
          AuthError() => ErrorPage(
              errorMessage: state.message,
              onPressed: () => context.read<AuthCubit>().reset(),
              onRetry: () {
                context.read<AuthCubit>().checkCurrentUser();
              },
            ),
          AuthEmailVerificationSent(user: var u) ||
          AuthFinalizing(user: var u) =>
            EmailVerificationPageRoute(user: u),
        };
      },
    );
  }
}

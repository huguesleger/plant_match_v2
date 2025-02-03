import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/presentation/auth/presentation/sign_in/presentation/sign_in_screen.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.toggleSignInOrRegister});

  final void Function() toggleSignInOrRegister;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
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
          Authenticated() => const TemplatePage(),
          Unauthenticated() => SignInScreen(
              toggleSignInOrRegister: toggleSignInOrRegister,
            ),
          AuthError() => ErrorPage(errorMessage: state.message),
        };
      },
    );
  }
}

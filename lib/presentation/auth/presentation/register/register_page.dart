import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/presentation/auth/presentation/register/register_screen.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
          AuthError() => ErrorPage(errorMessage: state.message),
          Unauthenticated() => const RegisterScreen(),
        };
      },
    );
  }
}

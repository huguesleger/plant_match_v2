import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/forgot_password/forgot_password_screen.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ForgotPasswordScreen(
                initialEmail: context
                    .read<AuthCubit>()
                    .currentUser
                    .flatMap((user) => user.email),
              ),
            ),
          ),
          child: Text(
            t.auth.signIn.forgotPassword,
            style: const TextStyle(
              color: AppColors.blueGreen,
              decoration: TextDecoration.underline,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

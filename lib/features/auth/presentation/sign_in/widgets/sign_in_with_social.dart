import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class SignInWithSocial extends StatelessWidget {
  const SignInWithSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            const Expanded(
              child: Divider(
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                t.auth.signIn.social.title,
              ),
            ),
            const Expanded(
              child: Divider(
                thickness: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              side: WidgetStateProperty.all(
                const BorderSide(
                  color: AppColors.blueGreen,
                ),
              ),
            ),
            onPressed: () {
              context.read<AuthCubit>().signInWithGoogle();
            },
            icon: Assets.res.logo.googleLogo.svg(),
            label: Text(
              t.auth.signIn.social.google,
              style: const TextStyle(
                color: AppColors.blueGreen,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              side: WidgetStateProperty.all(
                const BorderSide(
                  color: AppColors.blueGreen,
                ),
              ),
            ),
            onPressed: () {
              context.read<AuthCubit>().signInWithFacebook();
            },
            icon: Assets.res.logo.facebookLogo.svg(),
            label: Text(
              t.auth.signIn.social.facebook,
              style: const TextStyle(
                color: AppColors.blueGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

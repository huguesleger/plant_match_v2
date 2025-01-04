import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';

class SignInWithSocial extends StatelessWidget {
  const SignInWithSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Ou s’identifier avec',
              ),
            ),
            Expanded(
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
            icon: SvgPicture.asset('assets/logo/google_logo.svg'),
            label: const Text(
              'S\'identifier avec Google',
              style: TextStyle(
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
            icon: SvgPicture.asset('assets/logo/facebook_logo.svg'),
            label: const Text(
              'S\'identifier avec Facebook',
              style: TextStyle(
                color: AppColors.blueGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/dialog/app_dialog.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';

class AuthErrorListener extends StatelessWidget {
  const AuthErrorListener({super.key, required this.child});

  final Widget child;

  bool _isCurrentRoute(BuildContext context) =>
      Option.fromNullable(ModalRoute.of(context))
          .match(() => true, (route) => route.isCurrent);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
          current is AuthError && _isCurrentRoute(context),
      listener: (context, state) => switch (state) {
        AuthError(message: final message) => showDialog<void>(
            context: context,
            builder: (dialogContext) => _AuthErrorDialog(message: message),
          ),
        AuthInitial() ||
        AuthLoading() ||
        Authenticated() ||
        Unauthenticated() ||
        AuthEmailVerificationSent() ||
        AuthFinalizing() =>
          Future<void>.value(),
      },
      child: child,
    );
  }
}

class _AuthErrorDialog extends StatelessWidget {
  const _AuthErrorDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: t.auth.common.error_title,
      textAlign: TextAlign.left,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(message),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ButtonRounded(
                onPressed: Some(() => Navigator.of(context).pop()),
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
    );
  }
}

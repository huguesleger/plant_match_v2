import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/core/widgets/loading_overlay/loading_overlay.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/cubit/change_password_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/cubit/change_password_state.dart';

class ChangePasswordListener extends StatelessWidget {
  const ChangePasswordListener({
    super.key,
    required this.loadingMessage,
    required this.successMessage,
    required this.child,
  });

  final String loadingMessage;
  final String successMessage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) => switch (state) {
        ChangePasswordInProgress() =>
          LoadingOverlay.show(context, message: loadingMessage),
        ChangePasswordSuccess() => _onSuccess(context),
        ChangePasswordFailure(:final failure) => _onFailure(context, failure),
        ChangePasswordIdle() => null,
      },
      child: child,
    );
  }

  String _messageOf(Failure failure) => failure is AuthInvalidCredentialsFailure
      ? t.accountSettings.change_password.wrong_current_password
      : failure.errorContent.message;

  Future<void> _onSuccess(BuildContext context) =>
      LoadingOverlay.hide(context).then((_) {
        if (!context.mounted) return;
        _showMessage(context, successMessage);
        Navigator.pop(context);
      });

  Future<void> _onFailure(BuildContext context, Failure failure) =>
      LoadingOverlay.hide(context).then((_) {
        if (!context.mounted) return;
        _showMessage(context, _messageOf(failure));
      });

  void _showMessage(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
}

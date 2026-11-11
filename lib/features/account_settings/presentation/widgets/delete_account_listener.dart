import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/loading_overlay/loading_overlay.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/delete_account_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/delete_account_state.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/delete_account_error_dialog.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_cubit.dart';

class DeleteAccountListener extends StatelessWidget {
  const DeleteAccountListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) => switch (state) {
        DeleteAccountInProgress() => LoadingOverlay.show(
            context,
            message: t.accountSettings.delete_account.loading,
          ),
        DeleteAccountSuccess() => _leaveSession(context),
        DeleteAccountFailure(:final failure) => _onFailure(context, failure),
        DeleteAccountIdle() => null,
      },
      child: child,
    );
  }

  Future<void> _onFailure(BuildContext context, Failure failure) =>
      LoadingOverlay.hide(context).then((_) {
        if (!context.mounted) return;
        showDialog<void>(
          context: context,
          builder: (_) => DeleteAccountErrorDialog(failure: failure),
        );
      });

  Future<void> _leaveSession(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final navigator = Navigator.of(context, rootNavigator: true);
    context.read<NotificationCubit>().stopTokenRefresh();
    return LoadingOverlay.waitMinDuration().then((_) {
      navigator.popUntil((route) => route.isFirst);
      authCubit.accountDeleted();
    });
  }
}

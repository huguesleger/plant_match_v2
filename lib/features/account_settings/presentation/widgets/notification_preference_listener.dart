import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/core/widgets/loading_overlay/loading_overlay.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/notification_preference_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/notification_preference_state.dart';
import 'package:plant_match_v2/features/notifications/presentation/widgets/notifications_permission_dialog.dart';

class NotificationPreferenceListener extends StatelessWidget {
  const NotificationPreferenceListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationPreferenceCubit,
        NotificationPreferenceState>(
      listenWhen: (previous, current) =>
          previous is NotificationPreferenceUpdating ||
          current is NotificationPreferenceUpdating,
      listener: (context, state) => switch (state) {
        NotificationPreferenceUpdating(:final enabled) => LoadingOverlay.show(
            context,
            message: enabled
                ? t.accountSettings.notifications.enabling
                : t.accountSettings.notifications.disabling,
          ),
        NotificationPreferenceLoaded() => LoadingOverlay.hide(context),
        NotificationPreferencePermissionDenied() =>
          _askToOpenSettings(context),
        NotificationPreferenceFailure(:final failure) =>
          _hideWithMessage(context, failure.errorContent.message),
        NotificationPreferenceLoading() => null,
      },
      child: child,
    );
  }

  Future<void> _askToOpenSettings(BuildContext context) {
    final cubit = context.read<NotificationPreferenceCubit>();
    return LoadingOverlay.hide(context)
        .then((_) => context.mounted
            ? NotificationsPermissionDialog.show(
                context,
                icon: LucideIcons.bell_off,
                title: t.accountSettings.notifications.permission_dialog.title,
                content:
                    t.accountSettings.notifications.permission_dialog.content,
                confirmLabel:
                    t.accountSettings.notifications.permission_dialog.open_settings,
              )
            : Future.value(false))
        .then((open) => open ? cubit.openSettings() : null);
  }

  Future<void> _hideWithMessage(BuildContext context, String message) =>
      LoadingOverlay.hide(context).then((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      });
}

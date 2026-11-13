import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_prompt_cubit.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_prompt_state.dart';
import 'package:plant_match_v2/features/notifications/presentation/widgets/notifications_permission_dialog.dart';

class NotificationPromptListener extends StatelessWidget {
  const NotificationPromptListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationPromptCubit, NotificationPromptState>(
      listenWhen: (_, current) => current is NotificationPromptVisible,
      listener: (context, _) => _showPrompt(context),
      child: child,
    );
  }

  Future<void> _showPrompt(BuildContext context) {
    final cubit = context.read<NotificationPromptCubit>();
    return NotificationsPermissionDialog.show(
      context,
      icon: LucideIcons.bell_ring,
      title: t.widgets.notifications.prompt.title,
      content: t.widgets.notifications.prompt.content,
      confirmLabel: t.widgets.notifications.prompt.confirm,
    ).then((accepted) => accepted ? cubit.accept() : cubit.decline());
  }
}

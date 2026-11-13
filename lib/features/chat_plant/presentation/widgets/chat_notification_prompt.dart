import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_prompt_cubit.dart';
import 'package:plant_match_v2/features/notifications/presentation/widgets/notification_prompt_listener.dart';

class ChatNotificationPrompt extends StatelessWidget {
  const ChatNotificationPrompt({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatPlantCubit, ChatPlantState>(
      listenWhen: (_, current) =>
          current is ChatPlantLoaded && current.messages.isNotEmpty,
      listener: (context, _) =>
          context.read<NotificationPromptCubit>().maybePrompt(),
      child: NotificationPromptListener(child: child),
    );
  }
}

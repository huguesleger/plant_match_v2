import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/message_cubit.dart';
import 'package:plant_match_v2/features/message/presentation/message_screen.dart';
import 'package:plant_match_v2/features/message/presentation/state/message_state.dart';
import 'package:plant_match_v2/features/user/data/firebase_user.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';

class MessagesPage extends StatelessWidget {
  MessagesPage({super.key});

  final ChatPlantRepository chatPlantRepository = FirebaseChatPlant();
  final UserRepository userRepository = FirebaseUser();
  final ExchangeRepository exchangeRepository = FirebaseExchange();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return BlocProvider(
      create: (_) => MessagesCubit(
        chatPlantRepository: chatPlantRepository,
        userRepository: userRepository,
        exchangeRepository: exchangeRepository,
      )..load(currentUser.uid),
      child: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) {
          return switch (state) {
            MessagesInitial() || MessagesLoading() => const Scaffold(
                backgroundColor: AppColors.white,
                body: Center(child: CircularProgressIndicator()),
              ),
            MessagesError() => ErrorPage(errorMessage: state.message),
            MessagesLoaded() => MessagesScreen(chats: state.chats),
          };
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/message_cubit.dart';
import 'package:plant_match_v2/features/message/presentation/message_screen.dart';
import 'package:plant_match_v2/features/user/data/firebase_user.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class MessagesPageRoute extends StatelessWidget {
  MessagesPageRoute({super.key});

  final ChatPlantRepository chatPlantRepository = FirebaseChatPlant();
  final UserRepository userRepository = FirebaseUser();
  final ExchangeRepository exchangeRepository = FirebaseExchange();

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return BlocProvider(
      create: (_) => MessagesCubit(
        chatPlantRepository: chatPlantRepository,
        userRepository: userRepository,
        exchangeRepository: exchangeRepository,
      )..load(userId),
      child: const MessagesScreen(),
    );
  }
}

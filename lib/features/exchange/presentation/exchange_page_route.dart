import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_proposal_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/exchange_screen.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_success_listener.dart';

class ExchangePageRoute extends StatelessWidget {
  const ExchangePageRoute({
    required this.chatId,
    required this.targetPlantId,
    required this.targetOwnerId,
    super.key,
  });

  final String chatId;
  final String targetPlantId;
  final String targetOwnerId;

  @override
  Widget build(BuildContext context) => context.read<AuthCubit>().userId.match(
        () => Scaffold(body: Center(child: Text(t.common.notConnected))),
        (userId) => BlocProvider(
          create: (_) => ExchangeProposalCubit(
            catalogRepository: FirebaseCatalogRepository(),
            exchangeRepository: FirebaseExchange(),
            chatRepository: FirebaseChatPlant(),
            userId: userId,
            targetPlantId: targetPlantId,
            chatId: chatId,
          )..load(),
          child: ExchangeSuccessListener(
            child: ExchangeScreen(userId: userId),
          ),
        ),
      );
}

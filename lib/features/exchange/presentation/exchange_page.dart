import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/catolog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/presentation/exchange_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';

class ExchangePage extends StatelessWidget {
  ExchangePage({
    required this.chatId,
    required this.targetPlantId,
    required this.targetOwnerId,
    super.key,
  });

  final String chatId;
  final String targetPlantId;
  final String targetOwnerId;

  final catalogRepo = FirebaseCatalogRepository();
  final exchangeRepo = FirebaseExchange();
  final chatRepo = FirebaseChatPlant();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir une plante à échanger"),
      ),
      body: FutureBuilder<List<Catalog>>(
        future: catalogRepo.getCatalogsByUserId(user!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final plants = snapshot.data!
              .where((p) => p.offerType == OfferType.exchange)
              .toList();

          if (plants.isEmpty) {
            return const Center(
              child: Text("Tu n'as pas encore de plantes à échanger"),
            );
          }

            return BlocProvider(
              create: (context) => ExchangeCubit(
                repository: exchangeRepo,
                chatRepository: chatRepo,
              ),
              child: ListView.builder(
                itemCount: plants.length,
                itemBuilder: (context, i) {
                  final plant = plants[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: plant.images.isNotEmpty
                          ? NetworkImage(plant.images.first)
                          : null,
                    ),
                    title: Text(plant.name),
                    subtitle: Text(plant.description),
                    onTap: () async {
                      final confirmed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExchangeScreen(
                            chatId: chatId,
                            targetPlantId: targetPlantId,
                            targetOwnerId: targetOwnerId,
                            offeredPlant: plant,
                          ),
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        Navigator.pop(context, plant);
                      }
                    },
                  );
                },
              ),
            );
        },
      ),
    );
  }
}

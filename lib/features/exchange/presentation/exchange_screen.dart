import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({
    required this.chatId,
    required this.targetPlantId,
    required this.targetOwnerId,
    required this.offeredPlant,
    super.key,
  });

  final String chatId;
  final String targetPlantId;
  final String targetOwnerId;

  final Catalog offeredPlant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmer l'échange")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Tu proposes cette plante",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 40,
              backgroundImage: offeredPlant.images.isNotEmpty
                  ? NetworkImage(offeredPlant.images.first)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(offeredPlant.name),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser!;

                final exchange = Exchange(
                  chatId: chatId,
                  requestedBy: user.uid,
                  ownerId: targetOwnerId,
                  targetPlantId: targetPlantId,
                  offeredPlantId: offeredPlant.catalogId!,
                  offeredPlantName: offeredPlant.name,
                  offeredPlantImage: offeredPlant.images.isNotEmpty
                      ? offeredPlant.images.first
                      : '',
                  status: ExchangeStatus.pending,
                  createdAt: DateTime.now(),
                  seenByOwner: false,
                  seenByRequester: true,
                );

                await context.read<ExchangeCubit>().propose(exchange);

                if (!context.mounted) return;

                Navigator.pop(context, true);
              },
              child: const Text("Confirmer l’échange"),
            ),
          ],
        ),
      ),
    );
  }
}

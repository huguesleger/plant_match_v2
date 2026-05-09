import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_preview.dart';

class ExchangeConfirmation extends StatelessWidget {
  const ExchangeConfirmation({
    required this.targetPlant,
    required this.offeredPlant,
    super.key,
  });

  final Catalog targetPlant;
  final Catalog offeredPlant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            t.exchange.confirmation.offered_plant_title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ExchangePlantPreview(plant: offeredPlant),
          const SizedBox(height: 20),
          const Icon(Icons.swap_vert, size: 40, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            t.exchange.confirmation.target_plant_title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ExchangePlantPreview(plant: targetPlant),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final authCubit = context.read<AuthCubit>();
              final exchangeCubit = context.read<ExchangeCubit>();
              final userId = authCubit.userId;
              final state = exchangeCubit.state;

              if (userId != null && state is ExchangeConfirming) {
                final exchange = Exchange(
                  chatId: state.chatId,
                  requestedBy: userId,
                  ownerId: targetPlant.userId,
                  targetPlantId: targetPlant.catalogId.getOrElse(() => ''),
                  targetPlantName: targetPlant.name,
                  targetPlantImage:
                      targetPlant.images.isNotEmpty ? targetPlant.images.first : '',
                  offeredPlantId: offeredPlant.catalogId.getOrElse(() => ''),
                  offeredPlantName: offeredPlant.name,
                  offeredPlantImage:
                      offeredPlant.images.isNotEmpty ? offeredPlant.images.first : '',
                  status: ExchangeStatus.pending,
                  createdAt: DateTime.now(),
                  seenByOwner: false,
                  seenByRequester: true,
                  completedAt: const None(),
                  completedBy: const None(),
                  validationCode: const None(),
                );

                exchangeCubit.propose(exchange);
              }
            },
            child: Text(t.exchange.confirmation.confirm_btn),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              context.read<ExchangeCubit>().cancelSelection();
            },
            child: Text(t.exchange.confirmation.change_plant_btn),
          ),
        ],
      ),
    );
  }
}

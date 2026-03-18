import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({
    this.userPlants,
    this.targetPlant,
    this.offeredPlant,
    super.key,
  });

  final List<Catalog>? userPlants;
  final Catalog? targetPlant;
  final Catalog? offeredPlant;

  @override
  Widget build(BuildContext context) {
    if (userPlants != null) {
      return _buildPlantPicker(context, userPlants!);
    }

    if (targetPlant != null && offeredPlant != null) {
      return _buildConfirmation(context, targetPlant!, offeredPlant!);
    }

    return const SizedBox.shrink();
  }

  Widget _buildPlantPicker(BuildContext context, List<Catalog> plants) {
    if (plants.isEmpty) {
      return const Center(
        child: Text("Tu n'as pas encore de plantes à échanger"),
      );
    }

    return ListView.builder(
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
          onTap: () {
            final state = context.read<ExchangeCubit>().state;
            if (state is ExchangePickingPlant) {
              context.read<ExchangeCubit>().selectPlant(
                    offeredPlant: plant,
                    targetPlantId: state.targetPlantId,
                    chatId: state.chatId,
                  );
            }
          },
        );
      },
    );
  }

  Widget _buildConfirmation(
    BuildContext context,
    Catalog target,
    Catalog offered,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Tu proposes cette plante",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildPlantPreview(offered),
          const SizedBox(height: 20),
          const Icon(Icons.swap_vert, size: 40, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "Contre sa plante",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildPlantPreview(target),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final userId = context.read<AuthCubit>().userId!;
              final state = context.read<ExchangeCubit>().state;

              if (state is ExchangeConfirming) {
                final exchange = Exchange(
                  chatId: state.chatId,
                  requestedBy: userId,
                  ownerId: target.userId,
                  targetPlantId: target.catalogId ?? '',
                  targetPlantName: target.name,
                  targetPlantImage:
                      target.images.isNotEmpty ? target.images.first : '',
                  offeredPlantId: offered.catalogId!,
                  offeredPlantName: offered.name,
                  offeredPlantImage:
                      offered.images.isNotEmpty ? offered.images.first : '',
                  status: ExchangeStatus.pending,
                  createdAt: DateTime.now(),
                  seenByOwner: false,
                  seenByRequester: true,
                );

                context.read<ExchangeCubit>().propose(exchange);
              }
            },
            child: const Text("Confirmer l'échange"),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              context.read<ExchangeCubit>().cancelSelection();
            },
            child: const Text("Choisir une autre plante"),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantPreview(Catalog plant) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: plant.images.isNotEmpty
              ? NetworkImage(plant.images.first)
              : null,
        ),
        const SizedBox(height: 10),
        Text(
          plant.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

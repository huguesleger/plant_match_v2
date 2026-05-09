import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ExchangePlantPicker extends StatelessWidget {
  const ExchangePlantPicker({
    required this.plants,
    super.key,
  });

  final List<Catalog> plants;

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return Center(
        child: Text(t.exchange.picker.no_plants),
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
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_empty_plants.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_list.dart';

class ExchangePlantPicker extends StatelessWidget {
  const ExchangePlantPicker({
    super.key,
    required this.plants,
    required this.userId,
  });

  final List<Catalog> plants;
  final String userId;

  @override
  Widget build(BuildContext context) => plants.isEmpty
      ? ExchangeEmptyPlants(userId: userId)
      : ExchangePlantList(plants: plants);
}

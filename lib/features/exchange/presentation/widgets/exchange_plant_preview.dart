import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class ExchangePlantPreview extends StatelessWidget {
  const ExchangePlantPreview({
    required this.plant,
    super.key,
  });

  final Catalog plant;

  @override
  Widget build(BuildContext context) {
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

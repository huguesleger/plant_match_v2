import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/around_me/home_card_plant.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';

class HomeAroundMeList extends StatelessWidget {
  const HomeAroundMeList({super.key, required this.plants});

  final List<(Catalog, ProfilUser, double)> plants;

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.only(bottom: 10),
        scrollDirection: Axis.horizontal,
        itemCount: plants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final (catalog, owner, distance) = plants[index];
          return HomeCardPlant(
            catalog: catalog,
            owner: owner,
            distance: Some(distance),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPlant(
                  catalog: catalog,
                  owner: Some(owner),
                ),
              ),
            ),
          );
        },
      );
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/user/domain/entities/user.dart';
import 'package:plant_match_v2/features/user/domain/extension/user_extension.dart';
import 'package:plant_match_v2/features/user/presentation/recent_plants/recent_plants.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/items_count/items_count.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/user_bio.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/user_catalog_filter_section.dart';

class UserProfileBody extends StatelessWidget {
  const UserProfileBody({super.key, required this.data});

  final User data;

  @override
  Widget build(BuildContext context) {
    final uid = data.user.uid;
    final recentCatalogs = data.recentCatalogs(uid);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserBio(bio: data.user.bio),
        const SizedBox(height: 30),
        ItemsCount(
          catalog: data.publishedCatalogs(uid),
          level: data.level,
          exchangeCount: data.exchangeCount,
        ),
        if (recentCatalogs.isNotEmpty) RecentPlants(catalogs: recentCatalogs),
        const SizedBox(height: 30),
        UserCatalogFilterSection(
          selectedFilter: data.selectedFilter,
          filteredCatalogs: data.filteredCatalogs(uid),
        ),
      ],
    );
  }
}

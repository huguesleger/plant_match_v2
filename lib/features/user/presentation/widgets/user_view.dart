import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/user/domain/entities/user.dart';
import 'package:plant_match_v2/features/user/domain/extension/user_extension.dart';
import 'package:plant_match_v2/features/user/presentation/header/user_header_with_content.dart';
import 'package:plant_match_v2/features/user/presentation/items_count/items_count.dart';
import 'package:plant_match_v2/features/user/presentation/recent_plants/recent_plants.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/user_bio.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/user_catalog_filter_section.dart';

class UserView extends StatelessWidget {
  const UserView({super.key, required this.data});

  final User data;

  @override
  Widget build(BuildContext context) {
    final user = data.user;
    final published = data.publishedCatalogs(user.uid);
    final recent = data.recentCatalogs(user.uid);
    final filtered = data.filteredCatalogs(user.uid);

    return UserHeaderWithContent(
      user: user,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserBio(bio: user.bio.match(() => null, (b) => b)),
          const SizedBox(height: 30),
          ItemsCount(
            catalog: published,
            level: data.level,
            exchangeCount: data.exchangeCount,
          ),
          if (recent.isNotEmpty) ...[
            RecentPlants(catalogs: recent),
          ],
          const SizedBox(height: 30),
          UserCatalogFilterSection(
            selectedFilter: data.selectedFilter,
            filteredCatalogs: filtered,
          ),
        ],
      ),
    );
  }
}

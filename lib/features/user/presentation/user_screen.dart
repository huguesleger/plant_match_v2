import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/user/domain/entities/user.dart';
import 'package:plant_match_v2/features/user/domain/extension/user_extension.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/filters/catalog_filter_bar.dart';
import 'package:plant_match_v2/features/user/presentation/header/user_header_with_content.dart';
import 'package:plant_match_v2/features/user/presentation/items_count/items_count.dart';
import 'package:plant_match_v2/features/user/presentation/list_plants/catalog_list.dart';
import 'package:plant_match_v2/features/user/presentation/recent_plants/recent_plants.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key, required this.data});

  final User data;

  @override
  Widget build(BuildContext context) {
    final user = data.user;
    final published = data.publishedCatalogs(user.uid);
    final recent = data.recentCatalogs(user.uid);
    final filtered = data.filteredCatalogs(user.uid);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: UserHeaderWithContent(
        user: user,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: Text(
                  (user.bio != null && user.bio!.isNotEmpty)
                      ? user.bio!
                      : 'Pas encore de description...',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ItemsCount(
              catalog: published,
              level: data.level,
              exchangeCount: data.exchangeCount,
            ),
            if (recent.isNotEmpty) ...[
              RecentPlants(
                catalogs: recent,
              ),
            ],
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CatalogFiltersBar(
                  selected: data.selectedFilter,
                  onChanged: (filter) =>
                      context.read<UserCubit>().updateFilter(filter),
                ),
                const SizedBox(height: 16),
                CatalogList(catalogs: filtered),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

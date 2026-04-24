import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_state.dart';
import 'package:plant_match_v2/features/user/domain/extension/user_extension.dart';
import 'package:plant_match_v2/features/user/presentation/header/user_header_with_content.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/items_count/items_count.dart';
import 'package:plant_match_v2/features/user/presentation/recent_plants/recent_plants.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/user_bio.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/user_catalog_filter_section.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) => switch (state) {
          UserInitial() || UserLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          UserError(:final message) => ErrorPage(
              errorMessage: message,
              onRetry: () => context.read<UserCubit>().fetchUser(uid),
            ),
          UserLoaded(:final data) => UserHeaderWithContent(
              user: data.user,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserBio(bio: data.user.bio.match(() => null, (b) => b)),
                  const SizedBox(height: 30),
                  ItemsCount(
                    catalog: data.publishedCatalogs(data.user.uid),
                    level: data.level,
                    exchangeCount: data.exchangeCount,
                  ),
                  if (data.recentCatalogs(data.user.uid).isNotEmpty) ...[
                    RecentPlants(catalogs: data.recentCatalogs(data.user.uid)),
                  ],
                  const SizedBox(height: 30),
                  UserCatalogFilterSection(
                    selectedFilter: data.selectedFilter,
                    filteredCatalogs: data.filteredCatalogs(data.user.uid),
                  ),
                ],
              ),
            ),
        },
      ),
    );
  }
}

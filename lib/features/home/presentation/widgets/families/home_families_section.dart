import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/family_explorer_page_route.dart';
import 'package:plant_match_v2/features/home/domain/entities/family_overview.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/families/home_family_tile.dart';

class HomeFamiliesSection extends StatelessWidget {
  const HomeFamiliesSection({super.key, required this.families});

  final List<FamilyOverview> families;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              t.home.families.title,
              style: const TextStyle(
                fontSize: AppTypo.textM,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: HomeFamilyTile.height,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: families.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => HomeFamilyTile(
                overview: families[index],
                onPressed: () => _openFamily(context, families[index].family),
              ),
            ),
          ),
        ],
      );

  Future<void> _openFamily(BuildContext context, Family family) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FamilyExplorerPageRoute(
            family: family,
            aroundMeCubit: context.read<AroundMeCubit>(),
          ),
        ),
      );
}

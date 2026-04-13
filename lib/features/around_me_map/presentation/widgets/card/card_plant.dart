import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/card/card_plant_content.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/card/card_plant_header.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class CardPlant extends StatelessWidget {
  const CardPlant({
    super.key,
    required this.catalog,
    required this.onPressed,
  });

  final Catalog catalog;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().userId;
    return Material(
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 155,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardPlantHeader(catalog: catalog, currentUserId: currentUserId ?? ''),
              CardPlantContent(catalog: catalog),
            ],
          ),
        ),
      ),
    );
  }
}

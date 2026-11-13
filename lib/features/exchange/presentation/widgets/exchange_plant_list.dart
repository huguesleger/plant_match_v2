import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_proposal_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_card.dart';

class ExchangePlantList extends StatelessWidget {
  const ExchangePlantList({super.key, required this.plants});

  final List<Catalog> plants;

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.paddingAll,
        itemCount: plants.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => index == 0
            ? Text(
                t.exchange.picker.subtitle,
                style: InterTextStyle.inter(
                  AppTypo.textS,
                  color: AppColors.greyMedium,
                ),
              )
            : ExchangePlantCard(
                plant: plants[index - 1],
                onTap: Some(
                  () => context
                      .read<ExchangeProposalCubit>()
                      .selectPlant(plants[index - 1]),
                ),
              ),
      );
}

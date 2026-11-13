import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_proposal_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';

class ExchangeConfirmationActions extends StatelessWidget {
  const ExchangeConfirmationActions({
    super.key,
    required this.targetPlant,
    required this.offeredPlant,
  });

  final Catalog targetPlant;
  final Catalog offeredPlant;

  @override
  Widget build(BuildContext context) => Padding(
        padding: AppSpacing.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ButtonRoundedWithIcon(
              text: t.exchange.confirmation.confirm_btn,
              onPressed: () => _propose(context),
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
              icon: const Icon(
                LucideIcons.arrow_left_right,
                color: AppColors.blueGreen,
              ),
              iconAlignment: IconAlignment.start,
            ),
            const SizedBox(height: 12),
            ButtonOutlinedRounded(
              text: t.exchange.confirmation.change_plant_btn,
              onPressed: context.read<ExchangeProposalCubit>().cancelSelection,
              borderColor: AppColors.greyLight,
              textColor: AppColors.greyDark,
            ),
          ],
        ),
      );

  Future<void> _propose(BuildContext context) {
    final profilCubit = context.read<ProfilCubit>();
    final proposalCubit = context.read<ExchangeProposalCubit>();
    return proposalCubit
        .propose(targetPlant: targetPlant, offeredPlant: offeredPlant)
        .then((_) => profilCubit.refreshLeaves(proposalCubit.userId));
  }
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_confirmation_actions.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_card.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_section_title.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_swap_divider.dart';

class ExchangeConfirmation extends StatelessWidget {
  const ExchangeConfirmation({
    required this.targetPlant,
    required this.offeredPlant,
    super.key,
  });

  final Catalog targetPlant;
  final Catalog offeredPlant;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExchangeSectionTitle(
                    title: t.exchange.confirmation.offered_plant_title,
                  ),
                  const SizedBox(height: 12),
                  ExchangePlantCard(plant: offeredPlant),
                  const ExchangeSwapDivider(),
                  ExchangeSectionTitle(
                    title: t.exchange.confirmation.target_plant_title,
                  ),
                  const SizedBox(height: 12),
                  ExchangePlantCard(plant: targetPlant),
                ],
              ),
            ),
          ),
          ExchangeConfirmationActions(
            targetPlant: targetPlant,
            offeredPlant: offeredPlant,
          ),
        ],
      );
}

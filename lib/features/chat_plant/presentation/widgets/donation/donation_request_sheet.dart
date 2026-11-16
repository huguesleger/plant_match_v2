import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/donation/donation_request_actions.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/donation/donation_request_cost.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_card.dart';

Future<bool> showDonationRequestSheet(
  BuildContext context, {
  required Catalog plant,
  required Option<int> leaves,
}) =>
    AppBottomSheet.showBottomSheet<bool>(
      context,
      DonationRequestSheet(plant: plant, leaves: leaves),
    ).then(
        (confirmed) => Option.fromNullable(confirmed).getOrElse(() => false));

class DonationRequestSheet extends StatelessWidget {
  const DonationRequestSheet({
    super.key,
    required this.plant,
    required this.leaves,
  });

  final Catalog plant;
  final Option<int> leaves;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.greyLight)),
            ),
            child: Center(
              child: TitlePage(
                title: t.chatPlant.donation_request.title,
                fontSize: AppTypo.textL,
              ),
            ),
          ),
          Padding(
            padding: AppSpacing.paddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExchangePlantCard(plant: plant),
                const SizedBox(height: 16),
                DonationRequestCost(leaves: leaves),
                const SizedBox(height: 20),
                const DonationRequestActions(),
              ],
            ),
          ),
        ],
      );
}

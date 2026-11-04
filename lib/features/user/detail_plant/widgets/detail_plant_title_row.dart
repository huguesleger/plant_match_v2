import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/badge_offer_type.dart';

class DetailPlantTitleRow extends StatelessWidget {
  const DetailPlantTitleRow({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TitlePage(
              title: catalog.name.toCapitalize(),
              fontSize: AppTypo.textXl,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          BadgeOfferType(offerType: catalog.offerType),
        ],
      );
}

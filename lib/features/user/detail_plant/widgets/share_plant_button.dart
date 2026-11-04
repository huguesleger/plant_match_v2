import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:share_plus/share_plus.dart';

class SharePlantButton extends StatelessWidget {
  const SharePlantButton({super.key, required this.catalog});

  final Catalog catalog;

  String get _shareText => t.user.detail_plant.share.text(
        type: catalog.offerType == OfferType.donation
            ? t.user.detail_plant.share.donation
            : t.user.detail_plant.share.exchange,
        name: catalog.name.toUpperCase(),
        description: catalog.description,
      );

  Future<ShareResult> _share(BuildContext context) => Share.share(
        _shareText,
        sharePositionOrigin: Option.fromNullable(context.findRenderObject())
            .filter((box) => box is RenderBox)
            .map((box) => box as RenderBox)
            .map((box) => box.localToGlobal(Offset.zero) & box.size)
            .toNullable(),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: AppColors.greyLight)),
      ),
      padding: const EdgeInsets.all(2),
      child: Builder(
        builder: (buttonContext) => IconButton(
          icon: const Icon(
            LucideIcons.share_2,
            color: AppColors.greyDark,
            size: 20,
          ),
          onPressed: () => _share(buttonContext),
        ),
      ),
    );
  }
}

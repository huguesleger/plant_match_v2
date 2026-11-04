import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/utils/plant_contact.dart';

class ContactOwnerButton extends StatelessWidget {
  const ContactOwnerButton({
    super.key,
    required this.catalog,
    required this.owner,
  });

  final Catalog catalog;
  final Option<ProfilUser> owner;

  @override
  Widget build(BuildContext context) => BottomBar(
        child: SizedBox(
          width: double.infinity,
          child: ButtonRoundedWithIcon(
            text: t.user.detail_plant.send_message,
            bgColor: AppColors.greenDark,
            textColor: AppColors.white,
            icon: const Icon(
              LucideIcons.message_square_text,
              color: AppColors.white,
              size: AppTypo.text,
            ),
            onPressed: () => PlantContact.start(
              context,
              catalog: catalog,
              owner: owner,
            ),
          ),
        ),
      );
}

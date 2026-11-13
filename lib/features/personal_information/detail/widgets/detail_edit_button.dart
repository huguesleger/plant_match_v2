import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/personal_information/detail/open_detail_wizard.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class DetailEditButton extends StatelessWidget {
  const DetailEditButton({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ButtonRounded(
          text: t.personalInformation.detail.edit_button,
          onPressed: Some(
            () => openDetailWizard(context, profilUser: profilUser),
          ),
          bgColor: AppColors.greenLight,
          textColor: AppColors.blueGreen,
        ),
      );
}

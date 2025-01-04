import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

class ProfilPersonalNameAndEmail extends StatelessWidget {
  const ProfilPersonalNameAndEmail({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          TitlePage(
            title: profilUser.fullName,
            fontSize: AppTypo.textL,
            color: AppColors.greyDark,
            textAlign: TextAlign.center,
          ),
          Text(
            profilUser.email ?? '',
            style: const TextStyle(
              fontSize: AppTypo.textXs,
              color: AppColors.greyDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

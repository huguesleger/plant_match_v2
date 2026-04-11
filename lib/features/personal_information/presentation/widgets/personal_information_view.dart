import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/personal_information/detail/detail_screen.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class PersonalInformationView extends StatelessWidget {
  const PersonalInformationView({
    super.key,
    required this.profilUser,
  });

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: AppSpacing.paddingHorizontal,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: DetailScreen(
                profilUser: profilUser,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

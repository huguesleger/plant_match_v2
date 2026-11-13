import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/personal_information/detail/widgets/detail_view.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class PersonalInformationView extends StatelessWidget {
  const PersonalInformationView({
    super.key,
    required this.profilUser,
    required this.isLoading,
  });

  final ProfilUser profilUser;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: AppSpacing.paddingHorizontal,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: AppSkeletonizer(
                  enabled: isLoading,
                  child: DetailView(profilUser: profilUser),
                ),
              ),
            ),
          ),
        ),
      );
}

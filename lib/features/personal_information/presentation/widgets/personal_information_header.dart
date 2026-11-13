import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/personal_information/presentation/name_and_email/name_and_email.dart';
import 'package:plant_match_v2/features/personal_information/presentation/upload_avatar/upload_avatar.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class PersonalInformationHeader extends StatelessWidget {
  const PersonalInformationHeader({
    super.key,
    required this.profilUser,
    required this.isLoading,
    this.isAvatarLoading = false,
  });

  final ProfilUser profilUser;
  final bool isLoading;
  final bool isAvatarLoading;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              AppSkeletonizer(
                enabled: isLoading || isAvatarLoading,
                child: UploadAvatar(profilUser: profilUser),
              ),
              AppSkeletonizer(
                enabled: isLoading,
                child: NameAndEmail(profilUser: profilUser),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
}

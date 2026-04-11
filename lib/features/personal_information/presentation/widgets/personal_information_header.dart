import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/personal_information/presentation/name_and_email/name_and_email.dart';
import 'package:plant_match_v2/features/personal_information/presentation/upload_avatar/upload_avatar.dart';

class PersonalInformationHeader extends StatelessWidget {
  const PersonalInformationHeader({
    super.key,
    required this.state,
    required this.profilUser,
  });

  final ProfilState state;
  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            switch (state) {
              ProfilInitial() || ProfilLoading() || ProfilError() => Column(
                  children: [
                    UploadAvatar(profilUser: profilUser),
                    NameAndEmail(profilUser: profilUser),
                    const SizedBox(height: 30),
                  ],
                ),
              ProfilImageUploading() => Column(
                  children: [
                    const Skeletonizer(
                      enabled: true,
                      child: Bone.circle(size: 120),
                    ),
                    NameAndEmail(profilUser: profilUser),
                    const SizedBox(height: 30),
                  ],
                ),
              ProfilLoaded s => Column(
                  children: [
                    UploadAvatar(profilUser: s.profilUser),
                    NameAndEmail(profilUser: s.profilUser),
                    const SizedBox(height: 30),
                  ],
                ),
            },
          ],
        ),
      ),
    );
  }
}

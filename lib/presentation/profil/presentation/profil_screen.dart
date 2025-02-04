import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_card/profil_card.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_header/profil_header.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_navigation/profil_navigation.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({
    super.key,
    required this.profilUser,
    required this.userId,
  });

  final ProfilUser profilUser;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProfilHeader(profilUser: profilUser),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 216,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProfilCard(userId: userId),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.greyUltraLight,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: ProfilNavigation(profilUser: profilUser),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

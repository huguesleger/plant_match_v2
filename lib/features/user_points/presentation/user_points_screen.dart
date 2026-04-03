import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_badge/presentation/profil_badge_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/user_points/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/user_points/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/user_points/domain/entities/user_points.dart';
import 'package:plant_match_v2/features/user_points/presentation/cubit/user_points_state.dart';

class UserPointsScreen extends StatelessWidget {
  const UserPointsScreen({
    super.key,
    required this.userId,
    required this.userPoints,
    this.isFromRegistration = false,
  });

  final String userId;
  final UserPoints userPoints;
  final bool isFromRegistration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenLight,
      appBar: AppBarTemplate(
        backgroundColor: Colors.transparent,
        surfaceTintColor: AppColors.white,
        leading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x, color: AppColors.greyDark),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => UserPointsCubit(repository: FirebaseUserPoints())
          ..fetchUserPoints(userId),
        child: BlocBuilder<UserPointsCubit, UserPointsState>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/visu_level_badge.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: AppSpacing.paddingHorizontal,
                  child: Column(
                    children: [
                      TitlePage(
                        title: isFromRegistration
                            ? 'Bienvenue !'
                            : 'Félicitations !',
                        fontSize: AppTypo.textXl,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueGreen,
                      ),
                      const SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          text: isFromRegistration
                              ? 'Nous sommes ravis de vous accueillir sur PlantMatch, vous avez remporté'
                              : 'Votre aventure PlantMatch progresse, vous avez remporté',
                          children: [
                            TextSpan(
                              text: state is UserPointsLoaded
                                  ? ' ${state.currentPoints} points'
                                  : ' ${userPoints.currentPoints} points',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      SafeArea(
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ButtonRounded(
                                text: 'Voir ma progression',
                                onPressed: () {
                                  if (state is UserPointsLoaded) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilBadgePage(),
                                      ),
                                    );
                                  }
                                },
                                bgColor: AppColors.white,
                                textColor: AppColors.blueGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

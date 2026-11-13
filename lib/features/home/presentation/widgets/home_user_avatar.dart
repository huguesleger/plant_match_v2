import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class HomeUserAvatar extends StatelessWidget {
  const HomeUserAvatar({
    super.key,
    required this.user,
    this.radius = 22,
  });

  final ProfilUser user;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(color: AppColors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Avatar(
          profilUser: Some(user),
          radius: radius,
          imgSizeAvatar: radius * 2,
        ),
      );
}

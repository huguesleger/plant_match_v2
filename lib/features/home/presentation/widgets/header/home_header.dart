import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_user_avatar.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/header/home_leaves_badge.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.user,
    required this.leaves,
  });

  final ProfilUser user;
  final int leaves;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitlePage(
                  title: t.home.header.greeting(
                    name: user.userName
                        .getOrElse(() => user.firstName)
                        .toCapitalizeWords(),
                  ),
                  fontSize: AppTypo.textXl,
                ),
                Text(
                  t.home.header.subtitle,
                  style: const TextStyle(
                    fontSize: AppTypo.textS,
                    color: AppColors.greyMedium,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              HomeLeavesBadge(leaves: leaves),
              const SizedBox(width: 12),
              HomeUserAvatar(user: user),
            ],
          ),
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/extension/first_word_before_space/first_word_after_space.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    super.key,
    required this.user,
    this.distance,
  });

  final ProfilUser user;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(
          profilUser: user,
          radius: 35,
          imgSizeAvatar: 70,
        ),
        const SizedBox(width: 10),
        _buildUserInfo(),
        const Spacer(),
        if (distance != null) _buildDistanceInfo(),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.userName.match(
            () => user.fullName.getFirstWordBeforeSpace().toCapitalize(),
            (userName) => userName.toCapitalize(),
          ),
          style: InterTextStyle.inter(
            AppTypo.textM,
            color: AppColors.greyDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        _OnlineStatusBadge(isOnline: user.isOnline),
      ],
    );
  }

  Widget _buildDistanceInfo() {
    return Column(
      children: [
        const Icon(LucideIcons.map_pin, color: AppColors.greenLight, size: 25),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            t.aroundMeMap.distance(value: distance.toString()),
            style: InterTextStyle.inter(
              AppTypo.textS,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnlineStatusBadge extends StatelessWidget {
  const _OnlineStatusBadge({required this.isOnline});
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? AppColors.blueGreen : AppColors.greyLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOnline) ...[
            const Icon(Icons.circle, color: AppColors.greenLight, size: 6),
            const SizedBox(width: 2),
          ],
          Text(
            isOnline
                ? t.aroundMeMap.status.online
                : t.aroundMeMap.status.offline,
            style: TextStyle(
              color: isOnline ? AppColors.white : AppColors.greyDark,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/presentation/user_page_route.dart';

class OwnerProfileSection extends StatelessWidget {
  const OwnerProfileSection({super.key, required this.owner});

  final ProfilUser owner;

  @override
  Widget build(BuildContext context) {
    final displayName = owner.userName.getOrElse(() => owner.firstName);
    final date = DateFormat('MMMM y', 'fr_FR');

    return Material(
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.greyUltraLight,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserPageRoute(uid: owner.uid),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Avatar(
                profilUser: owner,
                radius: 20,
                imgSizeAvatar: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: AppTypo.textS,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Membre depuis ${date.format(owner.createdAt)}",
                      style: InterTextStyle.inter(
                        AppTypo.textXs,
                        color: AppColors.greyMedium,
                      ),
                    ),
                    const Text(
                      "Voir le profil",
                      style: TextStyle(
                        fontSize: AppTypo.textXxs,
                        color: AppColors.greyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevron_right,
                color: AppColors.greyMedium,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

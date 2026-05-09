import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded_with_icon.dart';
import 'package:plant_match_v2/features/user/presentation/user_page_route.dart';

class BottomSheetAction extends StatelessWidget {
  const BottomSheetAction({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingAll,
      child: ButtonOutlinedRoundedWithIcon(
        text: t.aroundMeMap.bottomSheet.viewProfile,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserPageRoute(uid: userId)),
          );
        },
        borderColor: AppColors.blueGreen,
        textColor: AppColors.blueGreen,
        iconAlignment: IconAlignment.start,
        icon: const Icon(LucideIcons.user_round, color: AppColors.blueGreen),
      ),
    );
  }
}
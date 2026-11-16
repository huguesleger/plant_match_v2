import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';

class DonationRequestActions extends StatelessWidget {
  const DonationRequestActions({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ButtonRoundedWithIcon(
            text: t.chatPlant.donation_request.send,
            onPressed: () => Navigator.pop(context, true),
            bgColor: AppColors.greenLight,
            textColor: AppColors.blueGreen,
            icon: const Icon(
              LucideIcons.hand_heart,
              color: AppColors.blueGreen,
            ),
            iconAlignment: IconAlignment.start,
          ),
          const SizedBox(height: 12),
          ButtonOutlinedRounded(
            text: t.widgets.common.cancel,
            onPressed: () => Navigator.pop(context, false),
            borderColor: AppColors.greyLight,
            textColor: AppColors.greyDark,
          ),
        ],
      );
}

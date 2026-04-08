import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/empty_tchat.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.4),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.message_square,
                    color: AppColors.greenMedium,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune conversation',
                  style: InterTextStyle.inter(
                    AppTypo.textM,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greyDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Commencez à discuter avec vos futurs partenaires d\'échange !',
                  style: InterTextStyle.inter(
                    AppTypo.textXs,
                    color: AppColors.greyDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class MessageEmpty extends StatelessWidget {
  const MessageEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Assets.res.images.emptyTchat.image(
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.7),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.greyUltraLight,
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
                  t.message.empty.title,
                  style: InterTextStyle.inter(
                    AppTypo.textM,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greyDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  t.message.empty.subtitle,
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

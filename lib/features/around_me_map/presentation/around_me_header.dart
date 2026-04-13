import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

class AroundMeHeader extends StatelessWidget {
  const AroundMeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: AppSpacing.paddingHorizontal,
          child: TitlePage(
            title: 'A proximité',
            fontSize: AppTypo.textXl,
          ),
        ),
        Padding(
          padding: AppSpacing.paddingHorizontal +
              const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
              'Trouvez des utilisateurs autour de vous pour partager, échanger ...'),
        ),
      ],
    );
  }
}
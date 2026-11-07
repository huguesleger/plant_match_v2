import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/legal_information/presentation/widgets/legal_information_item.dart';

class LegalInformationList extends StatelessWidget {
  const LegalInformationList({super.key});

  static const double spacing = 32;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(top: 32),
      child: ListView(
        padding: AppSpacing.paddingAll,
        children: [
          LegalInformationItem(
            title: t.legalInformation.items.privacy_policy,
            icon: LucideIcons.shield_check,
            // TODO: naviguer vers la politique de confidentialité
            onTap: () {},
          ),
          const SizedBox(height: spacing),
          LegalInformationItem(
            title: t.legalInformation.items.terms,
            icon: LucideIcons.file_text,
            // TODO: naviguer vers les conditions générales
            onTap: () {},
          ),
          const SizedBox(height: spacing),
          LegalInformationItem(
            title: t.legalInformation.items.legal_notice,
            icon: LucideIcons.scale,
            // TODO: naviguer vers les mentions légales
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

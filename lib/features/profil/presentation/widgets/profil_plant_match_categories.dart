import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/list_tile_group/list_tile_group.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_item_sub_category.dart';

class ProfilPlantMatchCategories extends StatelessWidget {
  const ProfilPlantMatchCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return AppListTileGroup(
      margin: AppSpacing.paddingHorizontal,
      children: [
        ProfilItemSubCategory(
          title: t.profil.navigation.help,
          icon: LucideIcons.message_circle_question,
          onTap: () {},
        ),
        ProfilItemSubCategory(
          title: t.profil.navigation.about,
          icon: LucideIcons.info,
          onTap: () {},
        ),
        ProfilItemSubCategory(
          title: t.profil.navigation.legal,
          icon: LucideIcons.file_text,
          onTap: () {},
        ),
      ],
    );
  }
}

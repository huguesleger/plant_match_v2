import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/list_tile_group/list_tile_group.dart';
import 'package:plant_match_v2/features/history/presentation/history_page_route.dart';
import 'package:plant_match_v2/features/personal_information/presentation/personal_information_screen.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_item_sub_category.dart';

class ProfilPersonalizationCategories extends StatelessWidget {
  const ProfilPersonalizationCategories({
    super.key,
    required this.profilUser,
  });

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return AppListTileGroup(
      margin: AppSpacing.paddingHorizontal,
      children: [
        ProfilItemSubCategory(
          title: t.profil.navigation.personal_info,
          icon: LucideIcons.user,
          onTap: () {
            final profilCubit = context.read<ProfilCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (contextRoute) => BlocProvider.value(
                  value: profilCubit,
                  child: PersonalInformationScreen(
                    profilUser: profilUser,
                    userId: profilUser.uid,
                  ),
                ),
              ),
            );
          },
        ),
        ProfilItemSubCategory(
          title: t.profil.navigation.history,
          icon: LucideIcons.history,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryPageRoute(),
              ),
            );
          },
        ),
        ProfilItemSubCategory(
          title: t.profil.navigation.settings,
          icon: LucideIcons.settings,
          onTap: () {},
        ),
      ],
    );
  }
}

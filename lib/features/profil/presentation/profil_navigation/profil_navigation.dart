import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/get_started/presentation/get_started_page_route.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/history/presentation/history_page_route.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_navigation/profil_navigation_item.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/personal_information_screen.dart';

class ProfilNavigation extends StatelessWidget {
  const ProfilNavigation({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProfilNavigationItem(
          title: t.profil.navigation.personal_info,
          icon: LucideIcons.user_cog,
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
        const SizedBox(height: 20),
        ProfilNavigationItem(
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
        const SizedBox(height: 20),
        ProfilNavigationItem(
          title: t.profil.navigation.settings,
          icon: LucideIcons.settings,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfilNavigationItem(
          title: t.profil.navigation.help,
          icon: LucideIcons.message_circle_question,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfilNavigationItem(
          title: t.profil.navigation.legal,
          icon: LucideIcons.file_text,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfilNavigationItem(
          title: t.profil.navigation.about,
          icon: LucideIcons.info,
          onTap: () {},
        ),
        const SizedBox(height: 30),
        ButtonRoundedWithIcon(
          text: t.profil.navigation.logout,
          onPressed: () {
            context.read<AuthCubit>().logOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GetStartedPageRoute(),
              ),
            );
          },
          bgColor: AppColors.greenLight.withValues(alpha: 0.3),
          textColor: AppColors.blueGreen,
          icon: const Icon(LucideIcons.log_out, color: AppColors.blueGreen),
          iconAlignment: IconAlignment.start,
        ),
      ],
    );
  }
}

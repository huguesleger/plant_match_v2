import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/wizard_item.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class WizardLocationForm extends StatelessWidget {
  const WizardLocationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<DetailWizardCubit, ProfilUser>(
      (cubit) => cubit.state.draft,
    );
    final isTallScreen = MediaQuery.sizeOf(context).height > 700;

    return DetailWizardItem(
      title: t.personalInformation.wizard.location.title,
      description: t.personalInformation.wizard.location.description,
      child: Column(
        children: [
          SizedBox(height: isTallScreen ? 45 : 25),
          user.localisation.isEmpty
              ? SizedBox(
                  height: isTallScreen ? 300 : 200,
                  child: Assets.res.images.illuLocation.image(),
                )
              : _CurrentLocation(user: user),
        ],
      ),
    );
  }
}

class _CurrentLocation extends StatelessWidget {
  const _CurrentLocation({required this.user});

  final ProfilUser user;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              color: AppColors.greenLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(LucideIcons.map_pin, color: AppColors.blueGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '${user.localisation} ${user.zipCode} - ${user.country}',
              style: const TextStyle(
                fontSize: AppTypo.text,
                color: AppColors.greyDark,
              ),
            ),
          ),
        ],
      );
}

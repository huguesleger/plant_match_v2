import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class AroundMeEmpty extends StatelessWidget {
  const AroundMeEmpty({
    super.key,
    required this.profilUser,
  });

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          TitlePage(
            title: t.aroundMeMap.empty.title,
            fontSize: AppTypo.textXl,
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              t.aroundMeMap.empty.description,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height > 700 ? 45 : 25),
          SizedBox(
            height: MediaQuery.of(context).size.height > 700 ? 373 : 280,
            child: Assets.res.images.illuLocation.image(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height > 700 ? 45 : 25),
          SizedBox(
            width: double.infinity,
            child: ButtonRounded(
              onPressed: () => _updateLocationAndSave(context, profilUser),
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
              text: t.aroundMeMap.empty.button,
            ),
          ),
        ],
      ),
    );
  }

  void _updateLocationAndSave(BuildContext context, ProfilUser profilUser) {
    context.read<AroundMeCubit>().updateUserLocation(profilUser);
  }
}

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';

class AroundMeEmpty extends StatelessWidget {
  const AroundMeEmpty({
    super.key,
    required this.state,
  });

  final AroundMeLoaded state;

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
          ...state.locationError.match(
            () => const <Widget>[],
            (failure) => [
              Text(
                failure.errorContent.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error),
              ),
              const SizedBox(height: 12),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: state.locating
                ? const Center(child: CircularProgressIndicator())
                : ButtonRounded(
                    onPressed: Some(() => _locate(context)),
                    bgColor: AppColors.greenLight,
                    textColor: AppColors.blueGreen,
                    text: t.aroundMeMap.empty.button,
                  ),
          ),
        ],
      ),
    );
  }

  void _locate(BuildContext context) {
    final profilCubit = context.read<ProfilCubit>();
    context
        .read<AroundMeCubit>()
        .updateUserLocation(state.currentUser)
        .then((_) => profilCubit.refreshLeaves(state.currentUser.uid));
  }
}

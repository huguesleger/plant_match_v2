import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/wizard_screen.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';

class DetailEditButton extends StatelessWidget {
  const DetailEditButton({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ButtonRounded(
          text: t.personalInformation.detail.edit_button,
          onPressed: Some(() async {
            final profilCubit = context.read<ProfilCubit>();
            profilCubit.getProfilUser(profilUser.uid);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (contextRoute) => BlocProvider.value(
                  value: profilCubit,
                  child: DetailWizardScreen(profilUser: profilUser),
                ),
              ),
            );
          }),
          bgColor: AppColors.greenLight,
          textColor: AppColors.blueGreen,
        ),
      );
}

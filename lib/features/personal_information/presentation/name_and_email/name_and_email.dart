import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class NameAndEmail extends StatelessWidget {
  const NameAndEmail({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          TitlePage(
            title: profilUser.userName.match(
              () => profilUser.fullName.toCapitalizeWords(),
              (userName) => userName.toCapitalizeWords(),
            ),
            fontSize: AppTypo.textL,
            color: AppColors.white,
            textAlign: TextAlign.center,
          ),
          Text(
            Option.fromNullable(context.read<AuthCubit>().currentUser)
                .flatMap((user) => user.email)
                .getOrElse(() => ''),
            style: const TextStyle(
              fontSize: AppTypo.textXs,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

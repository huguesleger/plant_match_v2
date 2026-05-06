import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image_with_content.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/personal_information/presentation/widgets/personal_information_header.dart';
import 'package:plant_match_v2/features/personal_information/presentation/widgets/personal_information_view.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({
    super.key,
    required this.userId,
    required this.profilUser,
  });

  final String userId;
  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilCubit, ProfilState>(
      builder: (context, state) {
        final profilUserState = switch (state) {
          ProfilInitial() || ProfilLoading() || ProfilError() => profilUser,
          ProfilLoaded s => s.profilUser,
          ProfilImageUploading() => profilUser,
        };

        return Scaffold(
          appBar: AppBarHeaderImageWithContent(
            headerHeight: 350,
            title: 'Informations personnelles',
            titleColor: AppColors.white,
            image: Assets.res.images.bgHeaderProfil.image(),
            onPressed: () => Navigator.pop(context),
            styleIconButton: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: AppColors.white,
            ),
            child: PersonalInformationHeader(
              state: state,
              profilUser: profilUserState,
            ),
          ),
          body: switch (state) {
            ProfilInitial() ||
            ProfilLoading() ||
            ProfilImageUploading() ||
            ProfilLoaded() =>
              PersonalInformationView(profilUser: profilUserState),
            ProfilError s => ErrorPage(
                errorMessage: s.message,
                onRetry: () =>
                    context.read<ProfilCubit>().getProfilUser(userId),
              ),
          },
        );
      },
    );
  }
}

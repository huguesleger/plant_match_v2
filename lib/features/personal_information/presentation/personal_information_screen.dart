import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image_with_content.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/personal_information/presentation/widgets/personal_information_header.dart';
import 'package:plant_match_v2/features/personal_information/presentation/widgets/personal_information_view.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) => BlocBuilder<ProfilCubit, ProfilState>(
        builder: (context, state) => switch (state) {
          ProfilError(:final failure) => ErrorPage(
              failure: failure,
              onRetry: () => context.read<ProfilCubit>().getProfilUser(userId),
            ),
          ProfilLoaded(:final profilUser) =>
            _page(context, profilUser, isLoading: false),
          ProfilImageUploading(:final profilUser, :final boneMock) =>
            profilUser.match(
              () => _page(context, boneMock, isLoading: true),
              (user) => _page(
                context,
                user,
                isLoading: false,
                isAvatarLoading: true,
              ),
            ),
          ProfilInitial(:final boneMock) ||
          ProfilLoading(:final boneMock) =>
            _page(context, boneMock, isLoading: true),
        },
      );

  Widget _page(
    BuildContext context,
    ProfilUser profilUser, {
    required bool isLoading,
    bool isAvatarLoading = false,
  }) =>
      Scaffold(
        appBar: AppBarHeaderImageWithContent(
          headerHeight: 350,
          title: Some(t.personalInformation.screen.title),
          titleColor: AppColors.white,
          image: Assets.res.images.bgHeaderProfil.image(),
          onPressed: () => Navigator.pop(context),
          styleIconButton: Some(IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.white,
          )),
          child: PersonalInformationHeader(
            profilUser: profilUser,
            isLoading: isLoading,
            isAvatarLoading: isAvatarLoading,
          ),
        ),
        body: PersonalInformationView(
          profilUser: profilUser,
          isLoading: isLoading,
        ),
      );
}

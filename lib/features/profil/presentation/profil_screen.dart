import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_app_bar.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_content.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) => BlocBuilder<ProfilCubit, ProfilState>(
        builder: (context, state) => switch (state) {
          ProfilError(:final failure) => Scaffold(
              backgroundColor: AppColors.greyUltraLight,
              body: ErrorPage(
                failure: failure,
                onRetry: () =>
                    context.read<ProfilCubit>().getProfilUser(userId),
              ),
            ),
          ProfilLoaded(:final profilUser) =>
            _page(profilUser, isLoading: false),
          ProfilImageUploading(:final profilUser, :final boneMock) =>
            profilUser.match(
              () => _page(boneMock, isLoading: true),
              (user) => _page(user, isLoading: false, isAvatarLoading: true),
            ),
          ProfilInitial(:final boneMock) ||
          ProfilLoading(:final boneMock) =>
            _page(boneMock, isLoading: true),
        },
      );

  Widget _page(
    ProfilUser profilUser, {
    required bool isLoading,
    bool isAvatarLoading = false,
  }) =>
      Scaffold(
        backgroundColor: AppColors.greyUltraLight,
        appBar: ProfilAppBar(
          profilUser: profilUser,
          isLoading: isLoading,
          isAvatarLoading: isAvatarLoading,
        ),
        body: ProfilContent(
          profilUser: profilUser,
          userId: userId,
          isLoading: isLoading,
        ),
      );
}

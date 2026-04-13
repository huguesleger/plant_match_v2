import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_card.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_header.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_navigation/profil_navigation.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfilCubit, ProfilState>(
        builder: (context, state) => switch (state) {
          ProfilInitial() || ProfilLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          ProfilError(:final message) => ErrorPage(
              errorMessage: message,
              onRetry: () => context.read<ProfilCubit>().getProfilUser(userId),
            ),
          ProfilLoaded(:final profilUser) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: AppSpacing.paddingHorizontal,
                    child: ProfilHeader(profilUser: profilUser),
                  ),
                  const SizedBox(height: 50),
                  const SizedBox(
                    height: 216,
                    child: ProfilCard(),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.greyUltraLight,
                      ),
                      child: Padding(
                        padding: AppSpacing.paddingHorizontal +
                            const EdgeInsets.symmetric(vertical: 30),
                        child: ProfilNavigation(profilUser: profilUser),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ProfilImageUploading() => const SizedBox.shrink(),
        },
      ),
    );
  }
}

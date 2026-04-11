import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_view.dart';

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
          ProfilError s => ErrorPage(
              errorMessage: s.message,
              onRetry: () => context.read<ProfilCubit>().getProfilUser(userId),
            ),
          ProfilLoaded s => ProfilView(profilUser: s.profilUser),
          ProfilImageUploading() => const SizedBox.shrink(),
        },
      ),
    );
  }
}

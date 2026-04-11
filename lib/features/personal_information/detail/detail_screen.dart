import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/personal_information/detail/widgets/detail_view.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilCubit, ProfilState>(
      builder: (context, state) => switch (state) {
        ProfilInitial() || ProfilLoading() || ProfilImageUploading() =>
          DetailView(profilUser: profilUser),
        ProfilLoaded s => DetailView(profilUser: s.profilUser),
        ProfilError s => ErrorPage(
            errorMessage: s.message,
            onRetry: () =>
                context.read<ProfilCubit>().getProfilUser(profilUser.uid),
          ),
      },
    );
  }
}

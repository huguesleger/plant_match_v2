import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/presentation/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_screen.dart';
import 'package:plant_match_v2/presentation/storage/data/firebase_storage_repository.dart';

class ProfilPage extends StatelessWidget {
  ProfilPage({super.key, required this.uid});

  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilCubit(
          profilRepository: profilRepository,
          storageRepository: storageRepository)
        ..getProfilUser(uid),
      child: BlocBuilder<ProfilCubit, ProfilState>(
        builder: (context, state) {
          return Scaffold(
              body: switch (state) {
            ProfilInitial() || ProfilLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProfilLoaded() => ProfilScreen(
                profilUser: state.profilUser,
                userId: uid,
              ),
            ProfilError() => ErrorPage(errorMessage: state.message),
          });
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/presentation/around_me_map/data/firebase_around_me.dart';
import 'package:plant_match_v2/presentation/around_me_map/presentation/around_me_map_screen.dart';
import 'package:plant_match_v2/presentation/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/presentation/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/presentation/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/presentation/storage/data/firebase_storage_repository.dart';

class AroundMePage extends StatelessWidget {
  AroundMePage({super.key, required this.uid});

  final aroundMeRepository = FirebaseAroundMe();
  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AroundMeCubit(
        aroundMeRepository: aroundMeRepository,
        profilRepository: profilRepository,
      )..fetchAllUsers(uid),
      child: BlocBuilder<AroundMeCubit, AroundMeState>(
        builder: (context, state) {
          if (state is AroundMeLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is AroundMeError) {
            return ErrorPage(errorMessage: state.message);
          } else if (state is AroundMeLoaded) {
            return AroundMeMapScreen(
              profilUser: state.profilUser, // Passer profilUser en paramètre
              users: state.users, // Passer les autres utilisateurs en paramètre
            );
          }

          return const Scaffold(
            body: Center(child: Text("Aucune donnée disponible")),
          );
        },
      ),
    );
  }
}

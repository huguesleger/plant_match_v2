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
  final String uid;
  final aroundMeRepository = FirebaseAroundMe();
  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();

  AroundMePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AroundMeCubit(
        aroundMeRepository: aroundMeRepository,
        profilRepository: profilRepository,
      )..getAllUserProfiles(uid),
      child: BlocBuilder<AroundMeCubit, AroundMeState>(
        builder: (context, state) {
          return switch (state) {
            AroundMeInitial() || AroundMeLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            AroundMeLoaded() => const AroundMeMapScreen(),
            AroundMeError() => ErrorPage(errorMessage: state.message),
          };
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_screen.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';
import 'package:plant_match_v2/core/services/location/location_service.dart';

class ProfilPageRoute extends StatelessWidget {
  ProfilPageRoute({super.key, required this.uid});

  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();
  final locationService = LocationServiceImpl();
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilCubit(
          profilRepository: profilRepository,
          storageRepository: storageRepository,
          locationService: locationService)
        ..getProfilUser(uid),
      child: ProfilScreen(userId: uid),
    );
  }
}

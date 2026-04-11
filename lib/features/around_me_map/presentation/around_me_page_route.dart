import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/around_me_map/data/firebase_around_me_repository.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/around_me_screen.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/core/services/location/location_service.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';

class AroundMePageRoute extends StatelessWidget {
  final String uid;
  final aroundMeRepository = FirebaseAroundMeRepository();
  final profilRepository = FirebaseProfilRepo();
  final catalogRepository = FirebaseCatalogRepository();
  final storageRepository = FirebaseStorageRepository();
  final locationService = LocationServiceImpl();

  AroundMePageRoute({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AroundMeCubit(
        aroundMeRepository: aroundMeRepository,
        profilRepository: profilRepository,
        catalogRepository: catalogRepository,
        locationService: locationService,
      )..getAllUserProfiles(uid),
      child: AroundMeScreen(uid: uid),
    );
  }
}

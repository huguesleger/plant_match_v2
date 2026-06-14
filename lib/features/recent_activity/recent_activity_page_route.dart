import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/around_me_map/data/firebase_around_me_repository.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/core/services/location/location_service.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/recent_activity/recent_activity_screen.dart';

class RecentActivityPageRoute extends StatelessWidget {
  const RecentActivityPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;
    final uid = user?.uid ?? '';

    return BlocProvider(
      create: (context) => AroundMeCubit(
        aroundMeRepository: FirebaseAroundMeRepository(),
        profilRepository: FirebaseProfilRepo(),
        catalogRepository: FirebaseCatalogRepository(),
        locationService: LocationServiceImpl(),
      )..getAllUserProfiles(uid),
      child: const RecentActivityScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/presentation/catalog_screen.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';

class CatalogPageRoute extends StatelessWidget {
  CatalogPageRoute({super.key});

  final catalogRepository = FirebaseCatalogRepository();
  final storageRepository = FirebaseStorageRepository();

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    if (userId == null) {
      return Scaffold(
        body: Center(child: Text(t.common.notConnected)),
      );
    }

    return BlocProvider(
      create: (context) => CatalogCubit(
        catalogRepository: catalogRepository,
        storageRepository: storageRepository,
      )..getCatalogsByUserId(userId),
      child: const CatalogScreen(),
    );
  }
}

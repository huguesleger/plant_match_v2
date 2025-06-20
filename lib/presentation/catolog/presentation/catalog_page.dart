import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/presentation/catolog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/catalog_screen.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/presentation/storage/data/firebase_storage_repository.dart';

class CatalogPage extends StatelessWidget {
  final String userId;

  CatalogPage({
    super.key,
    required this.userId,
  });

  final catalogRepository = FirebaseCatalogRepository();
  final storageRepository = FirebaseStorageRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatalogCubit(
        catalogRepository: catalogRepository,
        storageRepository: storageRepository,
      )..getCatalogsByUserId(userId),
      child: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          return Scaffold(
            body: switch (state) {
              CatalogInitial() || CatalogLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CatalogLoaded(:final catalogs, :final catalog) => CatalogScreen(
                  userId: userId,
                  catalogs: catalogs,
                  catalog: catalog,
                ),
              CatalogError(:final message) => ErrorPage(errorMessage: message),
            },
          );
        },
      ),
    );
  }
}

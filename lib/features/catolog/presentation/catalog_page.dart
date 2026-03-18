import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catolog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catolog/presentation/catalog_screen.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';

class CatalogPage extends StatelessWidget {
  CatalogPage({super.key});

  final catalogRepository = FirebaseCatalogRepository();
  final storageRepository = FirebaseStorageRepository();

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté")),
      );
    }

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
                  catalogs: catalogs,
                  catalog: catalog,
                ),
              CatalogError(:final message) => ErrorPage(
                  errorMessage: message,
                  onRetry: () {
                    context.read<CatalogCubit>().getCatalogsByUserId(userId);
                  },
                ),
            },
          );
        },
      ),
    );
  }
}

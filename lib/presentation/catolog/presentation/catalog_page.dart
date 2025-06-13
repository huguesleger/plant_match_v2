import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/presentation/catolog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/catalog_screen.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/presentation/storage/data/firebase_storage_repository.dart';

class CatalogPage extends StatelessWidget {
  CatalogPage({
    super.key,
    required this.uid,
  });

  final catalogRepository = FirebaseCatalogRepository();
  final storageRepository = FirebaseStorageRepository();
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatalogCubit(
        catalogRepository: catalogRepository,
        //storageRepository: storageRepository,
      )..getUserCatalogs(uid),
      child: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          return Scaffold(
            body: switch (state) {
              CatalogInitial() || CatalogLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CatalogLoaded() => CatalogScreen(
                  uid: uid,
                  catalogs: state.catalogs.whereType<Catalog>().toList()),
              CatalogError() => ErrorPage(errorMessage: state.message),
            },
          );
        },
      ),
    );
  }
}

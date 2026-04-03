import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/edit_catalog_screen.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';

class EditCatalogPageRoute extends StatelessWidget {
  const EditCatalogPageRoute({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatalogCubit(
        catalogRepository: FirebaseCatalogRepository(),
        storageRepository: FirebaseStorageRepository(),
      ),
      child: EditCatalogScreen(catalog: catalog),
    );
  }
}

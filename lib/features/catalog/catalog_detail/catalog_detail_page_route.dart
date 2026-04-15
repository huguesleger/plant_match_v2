import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/catalog_detail/catalog_detail_screen.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';

class CatalogDetailPageRoute extends StatelessWidget {
  const CatalogDetailPageRoute({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatalogCubit(
        catalogRepository: FirebaseCatalogRepository(),
        storageRepository: FirebaseStorageRepository(),
      ),
      child: CatalogDetailScreen(catalog: catalog),
    );
  }
}

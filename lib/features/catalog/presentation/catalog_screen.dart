import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_sort_option.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_view.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) => switch (state) {
        CatalogInitial() => const Scaffold(),
        CatalogLoading(:final boneMocks) => CatalogView(
            catalogs: boneMocks,
            catalog: Catalog.boneMock(),
            sortOption: CatalogSortOption.newest,
            isLoading: true,
          ),
        CatalogError(:final failure) => Scaffold(
            body: ErrorPage(
              failure: failure,
              onRetry: () {
                context
                    .read<AuthCubit>()
                    .userId
                    .map(context.read<CatalogCubit>().getCatalogsByUserId);
              },
            ),
          ),
        CatalogLoaded(:final catalogs, :final catalog, :final sortOption) =>
          CatalogView(
            catalogs: catalogs,
            catalog: catalog,
            sortOption: sortOption,
          ),
      },
    );
  }
}

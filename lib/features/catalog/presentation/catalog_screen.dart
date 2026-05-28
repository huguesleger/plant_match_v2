import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_loaded_view.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) => switch (state) {
        CatalogInitial() || CatalogLoading() => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        CatalogError(:final message) => Scaffold(
            body: ErrorPage(
              errorMessage: message,
              onRetry: () {
                final userId = context.read<AuthCubit>().userId;
                if (userId != null) {
                  context.read<CatalogCubit>().getCatalogsByUserId(userId);
                }
              },
            ),
          ),
        CatalogLoaded(:final catalogs, :final catalog, :final sortOption) => CatalogLoadedView(
            catalogs: catalogs,
            catalog: catalog,
            sortOption: sortOption,
          ),
      },
    );
  }
}

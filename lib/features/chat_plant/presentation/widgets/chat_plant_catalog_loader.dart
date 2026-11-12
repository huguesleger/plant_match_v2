import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/core/widgets/dots_loader/dots_loader_page.dart';

class ChatPlantCatalogLoader extends StatefulWidget {
  const ChatPlantCatalogLoader({
    super.key,
    required this.plantId,
    required this.builder,
  });

  final String plantId;
  final Widget Function(BuildContext context, Catalog plant) builder;

  @override
  State<ChatPlantCatalogLoader> createState() => _ChatPlantCatalogLoaderState();
}

class _ChatPlantCatalogLoaderState extends State<ChatPlantCatalogLoader> {
  late Future<Either<Failure, Option<Catalog>>> _future = _load();

  Future<Either<Failure, Option<Catalog>>> _load() =>
      FirebaseCatalogRepository().getCatalogById(widget.plantId).run();

  void _reload() => setState(() => _future = _load());

  @override
  void didUpdateWidget(covariant ChatPlantCatalogLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plantId != widget.plantId) {
      _future = _load();
    }
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<Either<Failure, Option<Catalog>>>(
        future: _future,
        builder: (context, snapshot) => Option.fromNullable(snapshot.data).match(
          () => const Scaffold(
            body: DotsLoaderPage(),
          ),
          (result) => result.match(
            (failure) => ErrorPage(
              failure: failure,
              onRetry: _reload,
            ),
            (catalog) => catalog.match(
              () => const _PlantUnavailable(),
              (plant) => widget.builder(context, plant),
            ),
          ),
        ),
      );
}

class _PlantUnavailable extends StatelessWidget {
  const _PlantUnavailable();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              t.chatPlant.screen.plant_unavailable,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}

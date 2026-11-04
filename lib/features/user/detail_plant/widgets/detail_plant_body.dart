import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/user/detail_plant/utils/detail_plant_loader.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/detail_plant_content.dart';

class DetailPlantBody extends StatelessWidget {
  const DetailPlantBody({super.key, required this.data});

  final Future<Option<DetailPlantData>> data;

  @override
  Widget build(BuildContext context) => FutureBuilder<Option<DetailPlantData>>(
        future: data,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Option.fromNullable(snapshot.data)
                    .flatMap((loaded) => loaded)
                    .match(
                      () => const SizedBox.shrink(),
                      (loaded) => DetailPlantContent(data: loaded),
                    ),
      );
}

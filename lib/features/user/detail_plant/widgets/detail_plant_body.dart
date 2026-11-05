import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/user/detail_plant/utils/detail_plant_loader.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/detail_plant_content.dart';

class DetailPlantBody extends StatelessWidget {
  const DetailPlantBody({super.key, required this.data});

  final Option<DetailPlantData> data;

  @override
  Widget build(BuildContext context) => data.match(
        () => const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        (loaded) => DetailPlantContent(data: loaded),
      );
}

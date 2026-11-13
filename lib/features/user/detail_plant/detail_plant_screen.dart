import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/cubit/detail_plant_cubit.dart';
import 'package:plant_match_v2/features/user/detail_plant/cubit/detail_plant_state.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/detail_plant_content.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/detail_plant_page.dart';

class DetailPlantScreen extends StatelessWidget {
  const DetailPlantScreen({super.key, required this.owner});

  final Option<ProfilUser> owner;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DetailPlantCubit, DetailPlantState>(
        builder: (context, state) => switch (state) {
          DetailPlantInitial() => const Scaffold(),
          DetailPlantLoading(:final catalog, :final boneMock) =>
            DetailPlantPage(
              catalog: catalog,
              owner: owner,
              body: AppSkeletonizer(
                enabled: true,
                child: DetailPlantContent(data: boneMock),
              ),
            ),
          DetailPlantError(:final failure) => ErrorPage(
              failure: failure,
              onRetry: context.read<DetailPlantCubit>().load,
            ),
          DetailPlantLoaded(:final data) => DetailPlantPage(
              catalog: data.catalog,
              owner: Some(data.owner),
              body: DetailPlantContent(data: data),
            ),
        },
      );
}

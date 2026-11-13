import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/cubit/detail_plant_cubit.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant_screen.dart';

class DetailPlant extends StatelessWidget {
  const DetailPlant({
    super.key,
    required this.catalog,
    this.owner = const None(),
  });

  final Catalog catalog;
  final Option<ProfilUser> owner;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => DetailPlantCubit(
          catalog: catalog,
          owner: owner,
          currentUserId: context.read<AuthCubit>().userId.getOrElse(() => ''),
        )
          ..incrementViews()
          ..load(),
        child: DetailPlantScreen(owner: owner),
      );
}

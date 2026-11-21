import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/cubit/family_explorer_cubit.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/family_explorer_screen.dart';

class FamilyExplorerPageRoute extends StatelessWidget {
  const FamilyExplorerPageRoute({
    super.key,
    required this.family,
    required this.aroundMeCubit,
  });

  final Family family;
  final AroundMeCubit aroundMeCubit;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: aroundMeCubit),
          BlocProvider(create: (_) => FamilyExplorerCubit(family: family)),
        ],
        child: const FamilyExplorerScreen(),
      );
}

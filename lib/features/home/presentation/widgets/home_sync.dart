import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';

class HomeSync extends StatelessWidget {
  const HomeSync({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<AroundMeCubit, AroundMeState>(
            listener: (context, aroundMe) =>
                context.read<HomeCubit>().syncAroundMe(aroundMe),
          ),
          BlocListener<ProfilCubit, ProfilState>(
            listener: (context, profil) =>
                context.read<HomeCubit>().syncProfil(profil),
          ),
        ],
        child: child,
      );
}

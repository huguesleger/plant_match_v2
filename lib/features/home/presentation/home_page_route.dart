import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/home_screen.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_sync.dart';
import 'package:plant_match_v2/features/home_highlight/data/repositories/active_deal_repository_impl.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/cubit/home_highlight_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';

class HomePageRoute extends StatelessWidget {
  const HomePageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthCubit>().userId.getOrElse(() => '');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()
            ..syncAroundMe(context.read<AroundMeCubit>().state)
            ..syncProfil(context.read<ProfilCubit>().state),
        ),
        BlocProvider(
          create: (context) => HomeHighlightCubit(
            repository: ActiveDealRepositoryImpl(),
          )
            ..listen(uid)
            ..syncHome(context.read<HomeCubit>().state),
        ),
      ],
      child: HomeSync(child: HomeScreen(uid: uid)),
    );
  }
}

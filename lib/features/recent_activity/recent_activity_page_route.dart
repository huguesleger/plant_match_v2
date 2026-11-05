import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/recent_activity/recent_activity_screen.dart';

class RecentActivityPageRoute extends StatelessWidget {
  const RecentActivityPageRoute({super.key, required this.aroundMeCubit});

  final AroundMeCubit aroundMeCubit;

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: aroundMeCubit,
        child: const RecentActivityScreen(),
      );
}

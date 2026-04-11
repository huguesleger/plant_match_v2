import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/map_users/check_user_location.dart';

class AroundMeScreen extends StatelessWidget {
  const AroundMeScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AroundMeCubit, AroundMeState>(
          builder: (context, state) => switch (state) {
            AroundMeInitial() ||
            AroundMeLoading() =>
              const Center(child: CircularProgressIndicator()),
            AroundMeLoaded() => CheckUserLocation(
                currentUser: state.currentUser,
                users: state.users,
                userCatalogs: state.userCatalogs,
              ),
            AroundMeError s => ErrorPage(
                errorMessage: s.message,
                onRetry: () =>
                    context.read<AroundMeCubit>().getAllUserProfiles(uid),
              ),
          },
        ),
      ),
    );
  }
}

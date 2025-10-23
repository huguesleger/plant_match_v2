import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map_users/check_user_location.dart';

class AroundMeMapScreen extends StatelessWidget {
  const AroundMeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AroundMeCubit, AroundMeState>(
          builder: (context, state) {
            return switch (state) {
              AroundMeInitial() || AroundMeLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              AroundMeLoaded() => CheckUserLocation(
                  currentUser: state.currentUser,
                  users: state.users,
                  userCatalogs: state.userCatalogs,
                ),
              AroundMeError() => ErrorPage(errorMessage: state.message),
            };
          },
        ),
      ),
    );
  }
}

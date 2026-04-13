import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/around_me_header.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/around_me_empty.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/around_me_map.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

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
            AroundMeError(:final message) => ErrorPage(
                errorMessage: message,
                onRetry: () =>
                    context.read<AroundMeCubit>().getAllUserProfiles(uid),
              ),
            AroundMeLoaded(
              :final users,
              :final currentUser,
              :final userCatalogs
            ) =>
              _hasValidLocation(currentUser)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AroundMeHeader(),
                        Expanded(
                          child: AroundMeMap(
                            users: users,
                            currentUser: currentUser,
                            userCatalogs: userCatalogs,
                          ),
                        ),
                      ],
                    )
                  : AroundMeEmpty(profilUser: currentUser),
          },
        ),
      ),
    );
  }

  bool _hasValidLocation(ProfilUser user) =>
      user.latitude.match(
        () => false,
        (lat) => lat != 0,
      ) &&
      user.longitude.match(
        () => false,
        (lng) => lng != 0,
      );
}

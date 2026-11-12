import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';

class AppLoaderOverlay extends StatelessWidget {
  const AppLoaderOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final aroundMeState = context.watch<AroundMeCubit>().state;

    return Stack(
      children: [
        child,
        if (_isLoading(authState, aroundMeState))
          const Positioned.fill(child: AppLoaderPage()),
      ],
    );
  }

  bool _isLoading(AuthState auth, AroundMeState aroundMe) => switch (auth) {
        AuthInitial() || AuthLoading() => true,
        Authenticated() => switch (aroundMe) {
            AroundMeInitial() || AroundMeLoading() => true,
            AroundMeLoaded() || AroundMeError() => false,
          },
        Unauthenticated() ||
        AuthEmailVerificationSent() ||
        AuthFinalizing() ||
        AuthError() =>
          false,
      };
}

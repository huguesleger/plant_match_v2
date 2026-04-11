import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_state.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/user_view.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) => switch (state) {
          UserInitial() || UserLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          UserError(:final message) => ErrorPage(
              errorMessage: message,
              onRetry: () => context.read<UserCubit>().fetchUser(uid),
            ),
          UserLoaded(:final data) => UserView(data: data),
        },
      ),
    );
  }
}

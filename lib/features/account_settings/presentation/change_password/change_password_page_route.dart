import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/change_password_screen.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/cubit/change_password_cubit.dart';
import 'package:plant_match_v2/features/auth/domain/entities/password_status.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class ChangePasswordPageRoute extends StatelessWidget {
  const ChangePasswordPageRoute({super.key, required this.passwordStatus});

  final PasswordStatus passwordStatus;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(
        authRepository: context.read<AuthCubit>().authRepository,
      ),
      child: ChangePasswordScreen(passwordStatus: passwordStatus),
    );
  }
}

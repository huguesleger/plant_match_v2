import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/account_settings/presentation/account_settings_screen.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/delete_account_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class AccountSettingsPageRoute extends StatelessWidget {
  const AccountSettingsPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthCubit>().authRepository;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AccountSettingsCubit(authRepository: authRepository),
        ),
        BlocProvider(
          create: (_) => DeleteAccountCubit(authRepository: authRepository),
        ),
      ],
      child: const AccountSettingsScreen(),
    );
  }
}

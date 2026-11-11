import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/icon_list_item/icon_list_item.dart';
import 'package:plant_match_v2/features/account_settings/domain/entities/account_setting.dart';
import 'package:plant_match_v2/features/account_settings/presentation/account_setting_presentation.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:plant_match_v2/features/auth/domain/entities/password_status.dart';

class AccountSettingsList extends StatelessWidget {
  const AccountSettingsList({super.key});

  static const double spacing = 32;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSettingsCubit, PasswordStatus>(
      builder: (context, passwordStatus) {
        final settings = AccountSetting.valuesFor(passwordStatus);
        return Padding(
          padding: const EdgeInsetsGeometry.only(top: 32),
          child: ListView.separated(
            padding: AppSpacing.paddingAll,
            itemCount: settings.length,
            separatorBuilder: (_, __) => const SizedBox(height: spacing),
            itemBuilder: (context, index) {
              final setting = settings[index];
              final cubit = context.read<AccountSettingsCubit>();
              return IconListItem(
                title: setting.title,
                icon: setting.icon,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => setting.page),
                ).then((_) => cubit.refresh()),
              );
            },
          ),
        );
      },
    );
  }
}

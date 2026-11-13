import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/icon_list_item/icon_list_item.dart';
import 'package:plant_match_v2/features/account_settings/domain/entities/account_setting.dart';
import 'package:plant_match_v2/features/account_settings/presentation/account_setting_presentation.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/account_settings_cubit.dart';

class AccountSettingNavigationTile extends StatelessWidget {
  const AccountSettingNavigationTile({super.key, required this.setting});

  final NavigableAccountSetting setting;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccountSettingsCubit>();
    return IconListItem(
      title: setting.title,
      icon: setting.icon,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => setting.page),
      ).then((_) => cubit.refresh()),
    );
  }
}

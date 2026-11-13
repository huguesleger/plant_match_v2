import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/icon_list_item/icon_list_item.dart';
import 'package:plant_match_v2/features/account_settings/domain/entities/account_setting.dart';
import 'package:plant_match_v2/features/account_settings/presentation/account_setting_presentation.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/notification_preference_cubit.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/notification_preference_state.dart';

class NotificationsSwitchTile extends StatelessWidget {
  const NotificationsSwitchTile({super.key, required this.setting});

  final Notifications setting;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationPreferenceCubit,
        NotificationPreferenceState>(
      builder: (context, state) {
        final cubit = context.read<NotificationPreferenceCubit>();
        final interactive = _isInteractive(state);
        return IconListItem(
          title: setting.title,
          icon: setting.icon,
          onTap: interactive ? cubit.toggle : () {},
          trailing: Some(
            Switch.adaptive(
              value: state.enabled,
              activeTrackColor: AppColors.green,
              onChanged: interactive ? cubit.setEnabled : null,
            ),
          ),
        );
      },
    );
  }

  bool _isInteractive(NotificationPreferenceState state) => switch (state) {
        NotificationPreferenceLoading() ||
        NotificationPreferenceUpdating() =>
          false,
        NotificationPreferenceLoaded() ||
        NotificationPreferencePermissionDenied() ||
        NotificationPreferenceFailure() =>
          true,
      };
}

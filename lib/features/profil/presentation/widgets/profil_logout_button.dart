import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_cubit.dart';

class ProfilLogoutButton extends StatelessWidget {
  const ProfilLogoutButton({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) => Padding(
        padding: AppSpacing.paddingHorizontal,
        child: SizedBox(
          width: double.infinity,
          child: ButtonRoundedWithIcon(
            text: t.profil.navigation.logout,
            onPressed: () async {
              final navigator = Navigator.of(context, rootNavigator: true);
              final authCubit = context.read<AuthCubit>();
              await context
                  .read<NotificationCubit>()
                  .removeTokenAndLogout(userId);
              navigator.popUntil((route) => route.isFirst);
              await authCubit.logOut();
            },
            bgColor: AppColors.greenLight.withValues(alpha: 0.3),
            textColor: AppColors.blueGreen,
            icon: const Icon(LucideIcons.log_out, color: AppColors.blueGreen),
            iconAlignment: IconAlignment.start,
          ),
        ),
      );
}

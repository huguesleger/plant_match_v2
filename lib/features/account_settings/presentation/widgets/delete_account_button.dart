import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/dialog/confirm_dialog.dart';
import 'package:plant_match_v2/features/account_settings/presentation/cubit/delete_account_cubit.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingAll,
      child: SizedBox(
        width: double.infinity,
        child: ButtonRoundedWithIcon(
          text: t.accountSettings.delete_account.button,
          onPressed: () => _confirm(context),
          bgColor: AppColors.error,
          textColor: AppColors.white,
          icon: const Icon(LucideIcons.trash_2, color: AppColors.white),
          iconAlignment: IconAlignment.start,
        ),
      ),
    );
  }

  Future<void> _confirm(BuildContext context) {
    final cubit = context.read<DeleteAccountCubit>();
    return showConfirmDialog(
      context,
      title: t.accountSettings.delete_account.dialog.title,
      content: Text(t.accountSettings.delete_account.dialog.content),
      confirmLabel: t.accountSettings.delete_account.dialog.confirm,
      destructive: true,
    ).then((confirmed) => confirmed ? cubit.deleteAccount() : null);
  }
}

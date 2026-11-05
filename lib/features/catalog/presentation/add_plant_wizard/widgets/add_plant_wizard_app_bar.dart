import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/dialog/dialog_with_image.dart';

class AddPlantWizardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AddPlantWizardAppBar({
    super.key,
    required this.canGoBack,
    required this.onBack,
  });

  final bool canGoBack;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _onExit(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => DialogWithImage(
        image: Assets.res.images.emptyCatalogFilter,
        title: t.catalog.wizard.quit_dialog.title,
        text: t.catalog.wizard.quit_dialog.content,
        confirmLabel: Some(t.catalog.wizard.quit_dialog.quit),
        cancelLabel: Some(t.catalog.wizard.quit_dialog.cancel),
      ),
    );
    if (Option.fromNullable(shouldExit).getOrElse(() => false) &&
        context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => AppBarTemplate(
        title: Some(t.catalog.wizard.title),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        onPressed: Some(onBack),
        leading: canGoBack,
        centerTitle: true,
        actions: Some([
          IconButton(
            onPressed: () => _onExit(context),
            icon: const Icon(LucideIcons.x, color: AppColors.greyDark),
          ),
        ]),
        styleIconButton: Some(IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(color: AppColors.greyLight),
        )),
      );
}

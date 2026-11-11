import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/catalog_edit_page_route.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';

class CatalogDetailActions extends StatelessWidget {
  const CatalogDetailActions({
    super.key,
    required this.catalog,
    required this.onUpdate,
  });

  final Catalog catalog;
  final Function(Catalog) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _DeleteButton(catalog: catalog)),
        if (catalog.status != CatalogStatus.archived) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _EditButton(
              catalog: catalog,
              onUpdate: onUpdate,
            ),
          ),
        ],
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return ButtonOutlinedRoundedWithIcon(
      text: t.catalog.detail.delete,
      onPressed: () => _showDeleteDialog(context),
      borderColor: AppColors.blueGreen,
      textColor: AppColors.blueGreen,
      iconAlignment: IconAlignment.start,
      icon: const Icon(LucideIcons.trash_2, color: AppColors.blueGreen),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    var deleting = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(t.catalog.detail.delete_dialog.title),
          content:
              Text(t.catalog.detail.delete_dialog.content(name: catalog.name)),
          actions: [
            TextButton(
              onPressed: Option<VoidCallback>.fromPredicate(
                () => Navigator.pop(ctx),
                (_) => !deleting,
              ).toNullable(),
              child: Text(t.catalog.detail.delete_dialog.cancel),
            ),
            ElevatedButton(
              onPressed: Option<VoidCallback>.fromPredicate(
                () async {
                  setDialogState(() => deleting = true);
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final result = await context
                      .read<CatalogCubit>()
                      .deleteCatalog(catalog)
                      .run();
                  navigator.pop();
                  result.match<void>(
                    (_) => messenger.showSnackBar(
                      SnackBar(
                          content: Text(t.catalog.detail.delete_error)),
                    ),
                    (_) => navigator.pop(true),
                  );
                },
                (_) => !deleting,
              ).toNullable(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: deleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(t.catalog.detail.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.catalog, required this.onUpdate});
  final Catalog catalog;
  final Function(Catalog) onUpdate;

  @override
  Widget build(BuildContext context) {
    return ButtonRoundedWithIcon(
      text: t.catalog.detail.edit,
      onPressed: () async {
        final result = await Navigator.push<Catalog>(
          context,
          MaterialPageRoute(
            builder: (_) => CatalogEditPageRoute(catalog: catalog),
          ),
        );
        Option.fromNullable(result).match(() {}, onUpdate);
      },
      bgColor: AppColors.greenLight,
      textColor: AppColors.blueGreen,
      iconAlignment: IconAlignment.start,
      icon:
          const Icon(LucideIcons.pencil, color: AppColors.blueGreen, size: 16),
    );
  }
}

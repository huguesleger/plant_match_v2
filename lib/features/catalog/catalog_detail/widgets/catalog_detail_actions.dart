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
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';

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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.catalog.detail.delete_dialog.title),
        content:
            Text(t.catalog.detail.delete_dialog.content(name: catalog.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.catalog.detail.delete_dialog.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final catalogCubit = context.read<CatalogCubit>();
              final userPointsCubit = context.read<UserPointsCubit>();

              final result = await catalogCubit
                  .deleteCatalog(
                    catalog.catalogId.getOrElse(() => ''),
                    catalog.userId,
                  )
                  .run();

              result.match(
                (failure) => null,
                (remainingCount) => remainingCount == 0
                    ? userPointsCubit.updateUserPoints(catalog.userId, -25)
                    : null,
              );

              navigator.pop();
              navigator.pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(t.catalog.detail.delete),
          ),
        ],
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
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CatalogEditPageRoute(catalog: catalog),
          ),
        );
        if (result == true && context.mounted) {
          final getResult = await context
              .read<CatalogCubit>()
              .getCatalogById(catalog.catalogId.getOrElse(() => ''))
              .run();
          getResult.match(
            (_) => null,
            (updatedCatalog) => onUpdate(updatedCatalog),
          );
        }
      },
      bgColor: AppColors.greenLight,
      textColor: AppColors.blueGreen,
      iconAlignment: IconAlignment.start,
      icon:
          const Icon(LucideIcons.pencil, color: AppColors.blueGreen, size: 16),
    );
  }
}

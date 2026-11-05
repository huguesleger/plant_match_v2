import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class DetailItem extends StatelessWidget {
  const DetailItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap = const None(),
  });

  final String title;
  final String subtitle;
  final Option<VoidCallback> onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.greyDark,
          fontSize: AppTypo.textS,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: AppColors.greyMedium, fontSize: AppTypo.textXs),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          ...onTap.match(
            () => <Widget>[],
            (_) => [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => _confirmClear(context),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(LucideIcons.x, size: AppTypo.text),
                  ),
                ),
              ),
            ),
            ],
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.personalInformation.detail.clear.title(field: title)),
        content: Text(t.personalInformation.detail.clear.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(t.personalInformation.detail.clear.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              t.personalInformation.detail.clear.confirm,
              style: const TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) onTap.match(() {}, (callback) => callback());
  }
}

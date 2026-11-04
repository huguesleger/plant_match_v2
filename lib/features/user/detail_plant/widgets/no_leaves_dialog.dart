import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';

class NoLeavesDialog extends StatelessWidget {
  const NoLeavesDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog(
        context: context,
        builder: (_) => const NoLeavesDialog(),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.user.detail_plant.no_leaves.title),
      content: Text(t.user.detail_plant.no_leaves.content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.user.detail_plant.no_leaves.ok),
        ),
      ],
    );
  }
}

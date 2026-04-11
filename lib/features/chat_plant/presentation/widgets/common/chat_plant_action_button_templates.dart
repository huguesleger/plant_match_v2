import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

class ChatPlantAcceptOrRefuseBar extends StatelessWidget {
  const ChatPlantAcceptOrRefuseBar({
    super.key,
    required this.label,
    required this.onAccept,
    required this.onRefuse,
  });

  final String label;
  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ButtonRounded(
              onPressed: onAccept,
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: 'Accepter',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ButtonOutlinedRounded(
              onPressed: onRefuse,
              borderColor: AppColors.blueGreen,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: 'Refuser',
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPlantCompleteActionBar extends StatelessWidget {
  const ChatPlantCompleteActionBar({
    super.key,
    required this.label,
    required this.dialogTitle,
    required this.dialogContent,
    required this.onConfirm,
  });

  final String label;
  final String dialogTitle;
  final String dialogContent;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(dialogTitle),
              content: Text(dialogContent),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirmer'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.check_circle_outline, size: 20),
        label: Text('Marquer $label comme terminée'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green.shade700,
          side: BorderSide(color: Colors.green.shade300),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
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
              text: t.chatPlant.actions.accept,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ButtonOutlinedRounded(
              onPressed: onRefuse,
              borderColor: AppColors.blueGreen,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: t.chatPlant.actions.refuse,
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
                  child: Text(t.chatPlant.actions.cancel),
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
                  child: Text(t.chatPlant.actions.confirm),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.check_circle_outline, size: 20),
        label: Text(t.chatPlant.actions.complete_label(label: label)),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green.shade700,
          side: BorderSide(color: Colors.green.shade300),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
class ChatPlantStatusBanner extends StatelessWidget {
  const ChatPlantStatusBanner({
    super.key,
    required this.message,
    required this.icon,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.grey),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

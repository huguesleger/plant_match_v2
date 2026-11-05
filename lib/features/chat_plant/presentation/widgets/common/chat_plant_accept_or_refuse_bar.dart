import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

class ChatPlantAcceptOrRefuseBar extends StatefulWidget {
  const ChatPlantAcceptOrRefuseBar({
    super.key,
    required this.onAccept,
    required this.onRefuse,
  });

  final Future<Option<String>> Function() onAccept;
  final Future<Option<String>> Function() onRefuse;

  @override
  State<ChatPlantAcceptOrRefuseBar> createState() =>
      _ChatPlantAcceptOrRefuseBarState();
}

class _ChatPlantAcceptOrRefuseBarState
    extends State<ChatPlantAcceptOrRefuseBar> {
  bool _sending = false;

  Future<void> _run(Future<Option<String>> Function() action) async {
    if (_sending) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sending = true);
    final error = await action();
    if (!mounted) return;
    setState(() => _sending = false);
    error.match(
      () => unit,
      (message) {
        messenger.showSnackBar(SnackBar(content: Text(message)));
        return unit;
      },
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.greyLight)),
        ),
        child: _sending
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: ButtonRounded(
                      onPressed: Some(() => _run(widget.onAccept)),
                      bgColor: AppColors.greenLight,
                      textColor: AppColors.blueGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      text: t.chatPlant.actions.accept,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonOutlinedRounded(
                      onPressed: () => _run(widget.onRefuse),
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

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/dots_loader/dots_loader.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, required this.message});

  final String message;

  static void show(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.white,
      builder: (_) => LoadingOverlay(message: message),
    );
  }

  static Future<void> hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog.fullscreen(
        backgroundColor: AppColors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DotsLoader(),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

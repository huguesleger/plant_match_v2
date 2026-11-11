import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, required this.message});

  final String message;

  static Stopwatch _shownFor = Stopwatch();

  static void show(BuildContext context, {required String message}) {
    _shownFor = Stopwatch()..start();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.white,
      builder: (_) => LoadingOverlay(message: message),
    );
  }

  static Future<void> waitMinDuration() => Future.delayed(_remaining());

  static Future<void> hide(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    return waitMinDuration().then((_) => navigator.pop());
  }

  static Duration _remaining() {
    final remaining = AppLoader.minDuration - _shownFor.elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
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
              const AppLoader(),
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

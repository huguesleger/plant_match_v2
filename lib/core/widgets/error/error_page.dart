import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.onPressed,
  });

  final String errorMessage;
  final VoidCallback? onPressed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TitlePage(
                  title: t.widgets.error.title,
                  fontSize: AppTypo.textXl,
                ),
                const SizedBox(height: 5),
                Text(
                  errorMessage,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Assets.res.images.auth.error.image(
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.greyLight),
                    ),
                    onPressed: onPressed ?? () => Navigator.of(context).pop(),
                    icon: const Icon(
                      LucideIcons.arrow_left,
                      color: AppColors.blueGreen,
                    ),
                    label: Text(
                      t.widgets.error.back,
                      style: const TextStyle(
                        color: AppColors.blueGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ButtonRounded(
                    text: t.widgets.error.retry,
                    bgColor: AppColors.blueGreen,
                    textColor: AppColors.white,
                    onPressed: onRetry,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

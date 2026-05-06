import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
/*                 Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SvgPicture.asset('res/logo/logo_color.svg'),
                  ),
                ), */
                const SizedBox(height: 20),
                const TitlePage(
                  title: 'Oups ! une erreur est survenue',
                  fontSize: AppTypo.textXl,
                  //textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  errorMessage,
                  //textAlign: TextAlign.left,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Image.asset(
                      'res/images/auth/error.png',
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
                    label: const Text(
                      'Retour',
                      style: TextStyle(
                        color: AppColors.blueGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ButtonRounded(
                    text: 'Essayer à nouveau',
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

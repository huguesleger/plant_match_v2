import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.errorMessage,
    this.onPressed,
  });

  final String errorMessage;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SvgPicture.asset('assets/logo/logo_color.svg'),
                  ),
                ),
                const SizedBox(height: 20),
                const TitlePage(
                  title: 'Oups ! une erreur est survénue',
                  fontSize: AppTypo.textXl,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: Image.asset(
                    'assets/images/auth/error.png',
                    fit: BoxFit.contain,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

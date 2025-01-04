import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

class ProfilPersonalDetailUpdateItem extends StatelessWidget {
  const ProfilPersonalDetailUpdateItem({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    required this.formKey,
    required this.onPressed,
    this.labelButton = 'Suivant',
    required this.onPressedBack,
  });

  final String title;
  final String description;
  final Widget child;
  final GlobalKey formKey;
  final VoidCallback onPressed;
  final String labelButton;
  final VoidCallback onPressedBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          TitlePage(
            title: title,
            fontSize: 24,
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.blueGreen,
            ),
          ),
          const SizedBox(height: 40),
          FormBuilder(
            key: formKey,
            child: child,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ButtonRounded(
              text: labelButton,
              onPressed: onPressed,
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ButtonOutlinedRounded(
              text: 'Précédent',
              onPressed: onPressedBack,
              borderColor: AppColors.greyLight,
              textColor: AppColors.blueGreen,
            ),
          ),
        ],
      ),
    );
  }
}

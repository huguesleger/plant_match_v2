import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class BgHeader extends StatelessWidget {
  const BgHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.white,
        ),
        Image.asset(
          'assets/images/bg_user_screen.jpg',
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}

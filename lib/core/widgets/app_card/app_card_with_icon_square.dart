import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

class AppCardWithIconSquare extends StatelessWidget {
  const AppCardWithIconSquare({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
    required this.bgColorIcon,
    required this.titleColor,
    required this.iconColor,
    required this.textBtn,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;
  final Color bgColorIcon;
  final Color titleColor;
  final Color iconColor;
  final String textBtn;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      //margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: bgColorIcon,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            TitlePage(
              title: title,
              isSubtitle: false,
              color: titleColor,
              fontSize: AppTypo.textL,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: AppTypo.textXxs,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ButtonRounded(
                text: textBtn,
                onPressed: onPressed,
                bgColor: AppColors.blueGreen,
                textColor: AppColors.white,
                fontSize: AppTypo.textXs,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

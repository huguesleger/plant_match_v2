import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class ItemCount extends StatelessWidget {
  const ItemCount({
    super.key,
    required this.count,
    required this.text,
    required this.icon,
    this.isLevel = false,
    this.sup,
  });

  final String count;
  final String text;
  final IconData icon;
  final bool isLevel;
  final String? sup;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSpacing.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.greyUltraLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: Icon(
              icon,
              color: AppColors.greenDark,
              size: 16,
            ),
          ),
          if (isLevel)
            RichText(
              strutStyle: const StrutStyle(
                height: 2.1,
              ),
              text: TextSpan(
                style: InterTextStyle.inter(
                  AppTypo.textL,
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w900,
                ),
                children: [
                  TextSpan(
                    text: count,
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: const Offset(0.0, -10.0),
                      child: Text(
                        Option.fromNullable(sup).getOrElse(() => ''),
                        style: const TextStyle(fontSize: AppTypo.textXxs),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              overflow: TextOverflow.ellipsis,
              count,
              style: InterTextStyle.inter(
                AppTypo.textL,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w900,
              ),
            ),
          Text(text,
              style: InterTextStyle.inter(
                AppTypo.textXs,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w500,
              )),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class RadiusSlider extends StatelessWidget {
  const RadiusSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onChangeEnd,
  });

  static const double min = 1;
  static const double max = 200;

  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  Widget _bound(double km) => Text(
        t.aroundMeMap.distance(value: km.toInt()),
        style: InterTextStyle.inter(AppTypo.textXs, color: AppColors.greyMedium),
      );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.aroundMeMap.radius.within,
                  style: InterTextStyle.inter(AppTypo.textS)),
              Text(
                t.aroundMeMap.distance(value: value.toInt()),
                style: InterTextStyle.inter(
                  AppTypo.textS,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blueGreen,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.blueGreen,
              inactiveTrackColor: AppColors.greyLight,
              thumbColor: AppColors.blueGreen,
              overlayColor: AppColors.blueGreen.withValues(alpha: 0.12),
              trackHeight: 4,
            ),
            child: Slider(
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              value: value,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_bound(0), _bound(max)],
          ),
        ],
      );
}

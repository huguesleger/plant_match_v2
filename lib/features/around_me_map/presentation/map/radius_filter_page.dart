import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_geo.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/radius/radius_preview_map.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/radius/radius_slider.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class RadiusFilterPage extends StatefulWidget {
  const RadiusFilterPage({
    super.key,
    required this.initialRadius,
    required this.currentUser,
  });

  final double initialRadius;
  final ProfilUser currentUser;

  @override
  State<RadiusFilterPage> createState() => _RadiusFilterPageState();
}

class _RadiusFilterPageState extends State<RadiusFilterPage> {
  late double _radius = widget.initialRadius;
  late double _fittedRadius = widget.initialRadius;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarTemplate(
          title: Some(t.aroundMeMap.radius.title),
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          shadowColor: const Some(AppColors.black),
          styleIconButton: Some(
            IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(color: AppColors.greyLight),
            ),
          ),
          onPressed: Some(() => Navigator.pop(context)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.aroundMeMap.radius.description,
                  style: const TextStyle(color: AppColors.greyDark, fontSize: 14),
                ),
                const SizedBox(height: 40),
                RadiusSlider(
                  value: _radius,
                  onChanged: (value) => setState(() => _radius = value),
                  onChangeEnd: (value) => setState(() => _fittedRadius = value),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SizedBox(
                    height: 220,
                    child: RadiusPreviewMap(
                      center: MapGeo.positionOf(widget.currentUser),
                      radiusKm: _radius,
                      fittedRadiusKm: _fittedRadius,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ButtonRounded(
                    text: t.aroundMeMap.radius.apply,
                    onPressed: Some(() => Navigator.pop(context, _radius)),
                    bgColor: AppColors.blueGreen,
                    textColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

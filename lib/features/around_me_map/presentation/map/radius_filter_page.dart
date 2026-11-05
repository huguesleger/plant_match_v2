import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
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
        appBar: AppBar(
          title: Text(
            t.aroundMeMap.radius.title,
            style: const TextStyle(color: AppColors.black),
          ),
          backgroundColor: AppColors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.black),
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
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _radius),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      t.aroundMeMap.radius.apply,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

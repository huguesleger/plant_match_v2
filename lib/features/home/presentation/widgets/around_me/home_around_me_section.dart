import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/around_me/home_around_me_header.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/around_me/home_around_me_list.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_section_message.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class HomeAroundMeSection extends StatelessWidget {
  const HomeAroundMeSection({
    super.key,
    required this.plants,
    required this.isGeolocated,
    required this.onSeeAllPressed,
  });

  final List<(Catalog, ProfilUser, double)> plants;
  final bool isGeolocated;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeAroundMeHeader(onSeeAllPressed: onSeeAllPressed),
          const SizedBox(height: 10),
          SizedBox(
            height: 210,
            child: !isGeolocated
                ? Center(
                    child: HomeSectionMessage(
                      message: t.home.around_me.no_location,
                      textAlign: TextAlign.center,
                    ),
                  )
                : plants.isEmpty
                    ? Center(
                        child: HomeSectionMessage(
                          message: t.home.around_me.empty,
                        ),
                      )
                    : HomeAroundMeList(plants: plants),
          ),
        ],
      );
}

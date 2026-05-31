import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_filter_chips.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_around_me_section.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_recommended_banner.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_recent_activity.dart';
import 'package:plant_match_v2/features/home/presentation/recent_activity/recent_activity_page_route.dart';

class HomeLoadedContent extends StatefulWidget {
  const HomeLoadedContent({
    super.key,
    required this.currentUser,
    required this.users,
    required this.userCatalogs,
  });

  final ProfilUser currentUser;
  final List<ProfilUser> users;
  final Map<String, List<Catalog>> userCatalogs;

  @override
  State<HomeLoadedContent> createState() => _HomeLoadedContentState();
}

class _HomeLoadedContentState extends State<HomeLoadedContent> {
  HomeFilterOption _filter = HomeFilterOption.all;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeFilterChips(
              selectedOption: _filter,
              onOptionSelected: (o) => setState(() => _filter = o)),
          const SizedBox(height: 24),
          HomeAroundMeSection(
            plants: _getFilteredPlants(),
            isGeolocated: _hasValidLoc(widget.currentUser),
            onSeeAllPressed: () => context
                .findAncestorStateOfType<TemplatePageState>()
                ?.onPageChanged(1),
          ),
          const SizedBox(height: 24),
          HomeRecommendedBanner(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Questionnaire bientôt disponible ! 🌿")),
                  )),
          const SizedBox(height: 24),
          HomeRecentActivity(
            activities: _getRecentActivities(),
            onSeeAllPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const RecentActivityPageRoute()),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasValidLoc(ProfilUser u) =>
      u.latitude.getOrElse(() => 0.0) != 0.0 &&
      u.longitude.getOrElse(() => 0.0) != 0.0;

  List<(Catalog, ProfilUser, double)> _getFilteredPlants() {
    final list = <(Catalog, ProfilUser, double)>[];
    widget.userCatalogs.forEach((uid, catalogs) {
      if (uid == widget.currentUser.uid) return;
      final owner = widget.users
          .firstWhere((u) => u.uid == uid, orElse: () => widget.currentUser);
      if (owner.uid == widget.currentUser.uid) return;
      for (final cat in catalogs) {
        if (cat.status != CatalogStatus.published) continue;
        final dist =
            DistanceHelper.calculateDistance(widget.currentUser, owner);
        if (dist > DistanceHelper.maxDistance) continue;
        if (_filter == HomeFilterOption.donation &&
            cat.offerType != OfferType.donation) {
          continue;
        }
        if (_filter == HomeFilterOption.exchange &&
            cat.offerType != OfferType.exchange) {
          continue;
        }
        if (_filter == HomeFilterOption.cutting &&
            !cat.name.toLowerCase().contains("bouture") &&
            !cat.description.toLowerCase().contains("bouture")) {
          continue;
        }
        if (_filter == HomeFilterOption.rare &&
            !cat.name.toLowerCase().contains("rare") &&
            !cat.name.toLowerCase().contains("monstera")) {
          continue;
        }
        list.add((cat, owner, dist));
      }
    });
    return list..sort((a, b) => a.$3.compareTo(b.$3));
  }

  List<(Catalog, ProfilUser)> _getRecentActivities() {
    final list = <(Catalog, ProfilUser)>[];
    widget.userCatalogs.forEach((uid, catalogs) {
      if (uid == widget.currentUser.uid) return;
      final owner = widget.users
          .firstWhere((u) => u.uid == uid, orElse: () => widget.currentUser);
      if (owner.uid == widget.currentUser.uid) return;
      for (final cat in catalogs) {
        if (cat.status == CatalogStatus.published) list.add((cat, owner));
      }
    });
    list.sort((a, b) => b.$1.createdAt.compareTo(a.$1.createdAt));
    return list.take(5).toList();
  }
}

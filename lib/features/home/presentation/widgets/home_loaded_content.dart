import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/core/widgets/filter/filter_bar.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_around_me_section.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_recommended_banner.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_recent_activity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/recent_activity/recent_activity_page_route.dart';
import 'package:plant_match_v2/features/recommendation/presentation/recommendation_page_route.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/saved_recommendation_cubit.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/saved_recommendation_state.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_recommendation_section.dart';

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
  CatalogFilter _filter = CatalogFilter.all;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterBar<CatalogFilter>(
            filters: CatalogFilter.values,
            selected: _filter,
            onChanged: (filter) => setState(() => _filter = filter),
            labelBuilder: (f) => f.label,
            iconBuilder: (f) => f.icon,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeAroundMeSection(
                    plants: _getFilteredPlants(),
                    isGeolocated:
                        DistanceHelper.hasValidLocation(widget.currentUser),
                    onSeeAllPressed: () => Option.fromNullable(context
                            .findAncestorStateOfType<TemplatePageState>())
                        .map((page) => page.onPageChanged(1)),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<SavedRecommendationCubit,
                      SavedRecommendationState>(
                    builder: (context, state) {
                      return state.match(
                        initial: (_) => const SizedBox.shrink(),
                        loading: (_) => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: AppColors.greenDark,
                            ),
                          ),
                        ),
                        loaded: (loadedState) => loadedState.answers.match(
                          () => HomeRecommendedBanner(
                            onPressed: () => _navigateToQuestionnaire(context),
                          ),
                          (answers) => HomeRecommendationSection(
                            plants: loadedState.suggestedPlants,
                            onAdjustPressed: () =>
                                _navigateToQuestionnaire(context),
                          ),
                        ),
                        error: (errorState) => Center(
                          child: Text(
                            "Erreur de chargement : ${errorState.message}",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: HomeRecentActivity(
                    activities: _getRecentActivities(),
                    onSeeAllPressed: () {
                      final aroundMeCubit = context.read<AroundMeCubit>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecentActivityPageRoute(
                            aroundMeCubit: aroundMeCubit,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Option<ProfilUser> _ownerOf(String uid) =>
      widget.users.where((user) => user.uid == uid).firstOption;

  bool _matchesFilter(Catalog cat) =>
      cat.status == CatalogStatus.published &&
      switch (_filter) {
        CatalogFilter.all => true,
        CatalogFilter.donation => cat.offerType == OfferType.donation,
        CatalogFilter.exchange => cat.offerType == OfferType.exchange,
        CatalogFilter.outdoor => cat.environment == Environment.outdoor,
        CatalogFilter.indoor => cat.environment == Environment.indoor,
      };

  Iterable<(Catalog, ProfilUser, double)> _nearbyPlantsOf(
    String uid,
    List<Catalog> catalogs,
  ) =>
      _ownerOf(uid)
          .filter((owner) => owner.uid != widget.currentUser.uid)
          .flatMap(
            (owner) => DistanceHelper.distanceBetween(widget.currentUser, owner)
                .filter((km) => km <= DistanceHelper.maxDistance)
                .map(
                  (km) => catalogs
                      .where(_matchesFilter)
                      .map((cat) => (cat, owner, km)),
                ),
          )
          .getOrElse(() => const []);

  List<(Catalog, ProfilUser, double)> _getFilteredPlants() =>
      widget.userCatalogs.entries
          .expand((entry) => _nearbyPlantsOf(entry.key, entry.value))
          .toList()
        ..sort((a, b) => a.$3.compareTo(b.$3));

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

  Future<void> _navigateToQuestionnaire(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RecommendationPageRoute(),
      ),
    );
    if (context.mounted) {
      context
          .read<SavedRecommendationCubit>()
          .loadSavedRecommendations(widget.currentUser.uid);
    }
  }
}

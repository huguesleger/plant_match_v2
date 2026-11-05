import 'package:fpdart/fpdart.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/around_me_map_view.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_controls.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_geo.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_markers.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/no_plants_banner.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/radius_filter_button.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/radius_filter_page.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class AroundMeMap extends StatefulWidget {
  const AroundMeMap({
    super.key,
    required this.users,
    required this.currentUser,
    required this.userCatalogs,
  });

  final List<ProfilUser> users;
  final ProfilUser currentUser;
  final Map<String, List<Catalog>> userCatalogs;

  @override
  State<AroundMeMap> createState() => _AroundMeMapState();
}

class _AroundMeMapState extends State<AroundMeMap>
    with TickerProviderStateMixin {
  late final AnimatedMapController _controller =
      AnimatedMapController(vsync: this);
  double _selectedRadius = 20.0;
  double _currentZoom = 12.0;
  static const double _minZoom = 6.0;
  static const double _maxZoom = 16.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoomBy(double delta) {
    final next = _currentZoom + delta;
    if (next < _minZoom || next > _maxZoom) return;
    setState(() => _currentZoom = next);
    delta > 0 ? _controller.animatedZoomIn() : _controller.animatedZoomOut();
  }

  Future<void> _openRadiusFilter() async {
    final result = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (_) => RadiusFilterPage(
          initialRadius: _selectedRadius,
          currentUser: widget.currentUser,
        ),
      ),
    );
    Option.fromNullable(result).match(() {}, (newRadius) {
      setState(() => _selectedRadius = newRadius);
      MapGeo.fitRadius(
        _controller,
        MapGeo.positionOf(widget.currentUser),
        newRadius,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = MapMarkers(
      currentUser: widget.currentUser,
      userCatalogs: widget.userCatalogs,
    );
    final otherMarkers = markers.around(widget.users, _selectedRadius);

    return Stack(
      children: [
        Padding(
          padding: AppSpacing.paddingAll,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AroundMeMapView(
              mapController: _controller.mapController,
              center: MapGeo.positionOf(widget.currentUser),
              initialZoom: _currentZoom,
              minZoom: _minZoom,
              maxZoom: _maxZoom,
              radius: _selectedRadius,
              currentUserMarker: markers.forCurrentUser(),
              otherMarkers: otherMarkers,
              onZoomChanged: (zoom) => _currentZoom = zoom,
            ),
          ),
        ),
        if (otherMarkers.isEmpty)
          Positioned(
            top: 30,
            left: 30,
            right: 30,
            child: NoPlantsBanner(
              isRadiusLimited: MapGeo.isLimited(_selectedRadius),
            ),
          ),
        Positioned(
          top: 40,
          left: 30,
          child: RadiusFilterButton(onPressed: _openRadiusFilter),
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: MapControls(
            onCenterOnUser: () => _controller.animateTo(
              dest: MapGeo.positionOf(widget.currentUser),
              zoom: _currentZoom,
            ),
            onZoomIn: () => _zoomBy(1),
            onZoomOut: () => _zoomBy(-1),
          ),
        ),
      ],
    );
  }
}

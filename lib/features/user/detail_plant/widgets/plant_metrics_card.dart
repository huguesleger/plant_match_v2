import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class PlantMetricsCard extends StatelessWidget {
  const PlantMetricsCard({
    super.key,
    required this.catalog,
    required this.owner,
    required this.currentUser,
  });

  final Catalog catalog;
  final ProfilUser owner;
  final ProfilUser? currentUser;

  String _getDistanceText() {
    if (currentUser == null) return '-- km';
    final hasLoc = currentUser!.latitude.isSome() &&
        currentUser!.longitude.isSome() &&
        owner.latitude.isSome() &&
        owner.longitude.isSome();
    return hasLoc
        ? '${DistanceHelper.calculateDistance(currentUser!, owner).toStringAsFixed(0)} km'
        : '-- km';
  }

  String _getElapsedTimeText(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    return difference.inDays >= 365
        ? (difference.inDays / 365).floor() == 1
            ? '1 an'
            : '${(difference.inDays / 365).floor()} ans'
        : difference.inDays >= 30
            ? '${(difference.inDays / 30).floor()} mois'
            : difference.inDays >= 1
                ? difference.inDays == 1
                    ? '1 jour'
                    : '${difference.inDays} jours'
                : difference.inHours >= 1
                    ? difference.inHours == 1
                        ? '1 heure'
                        : '${difference.inHours} heures'
                    : difference.inMinutes >= 1
                        ? difference.inMinutes == 1
                            ? '1 minute'
                            : '${difference.inMinutes} minutes'
                        : 'quelques instants';
  }

  @override
  Widget build(BuildContext context) {
    final distanceText = _getDistanceText();
    final timeText = _getElapsedTimeText(catalog.createdAt);
    final viewsCount = catalog.views;

    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyUltraLight),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _MetricItem(
              icon: LucideIcons.map_pin,
              title: distanceText,
              subtitle: 'de chez vous',
              isTitleBold: true,
            ),
          ),
          _buildDivider(),
          Expanded(
            flex: 4,
            child: _MetricItem(
              icon: LucideIcons.calendar,
              title: 'Publiée il y a',
              subtitle: timeText,
              isTitleBold: false,
            ),
          ),
          _buildDivider(),
          Expanded(
            flex: 2,
            child: _MetricItem(
              icon: LucideIcons.eye,
              title: '$viewsCount',
              subtitle: 'vues',
              isTitleBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          height: 35,
          width: 1,
          color: AppColors.greyLight,
        ),
      );
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isTitleBold,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isTitleBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipOval(
          child: Container(
            color: AppColors.greenLight.withValues(alpha: 0.2),
            width: 30,
            height: 30,
            child: Icon(icon, color: AppColors.greenDark, size: AppTypo.text),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isTitleBold ? FontWeight.bold : FontWeight.normal,
                  color: AppColors.black,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

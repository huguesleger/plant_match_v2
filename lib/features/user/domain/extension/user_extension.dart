import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';
import 'package:plant_match_v2/features/user/domain/entities/user.dart';

extension UserExtension on User {
  List<Catalog> publishedCatalogs(String userId) {
    final list = userCatalogs[userId] ?? [];

    return list.where((c) => c.status == CatalogStatus.published).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Catalog> recentCatalogs(String userId) {
    return publishedCatalogs(userId)
        .where((c) => _isRecent(c.createdAt))
        .take(3)
        .toList();
  }

  List<Catalog> filteredCatalogs(String userId) {
    final fullCatalog = publishedCatalogs(userId);

    return switch (selectedFilter) {
      CatalogFilter.donation =>
        fullCatalog.where((c) => c.offerType == OfferType.donation).toList(),
      CatalogFilter.exchange =>
        fullCatalog.where((c) => c.offerType == OfferType.exchange).toList(),
      CatalogFilter.outdoor =>
        fullCatalog.where((c) => c.environment == Environment.outdoor).toList(),
      CatalogFilter.indoor =>
        fullCatalog.where((c) => c.environment == Environment.indoor).toList(),
      _ => fullCatalog,
    };
  }

  bool _isRecent(DateTime createdAt) {
    return DateTime.now().difference(createdAt).inDays <= 360;
  }
}

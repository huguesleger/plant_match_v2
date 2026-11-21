import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

extension FamilyImage on Family {
  AssetGenImage get image => switch (this) {
        Family.tropical => Assets.res.images.family.tropical,
        Family.succulent => Assets.res.images.family.succulent,
        Family.cactus => Assets.res.images.family.cactus,
        Family.aquatic => Assets.res.images.family.aquatic,
        Family.climbing => Assets.res.images.family.climbing,
        Family.bonsai => Assets.res.images.family.bonsai,
        Family.flower => Assets.res.images.family.flower,
        Family.aromatic => Assets.res.images.family.aromatic,
        Family.medical => Assets.res.images.family.medical,
        Family.carnivorous => Assets.res.images.family.carnivorous,
      };
}

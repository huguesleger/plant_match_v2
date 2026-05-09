import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/family_item.dart';

final List<FamilyItem> familyItems = [
  FamilyItem(
    label: t.catalog.families.tropical,
    value: 'tropical',
    icon: LucideIcons.tree_palm,
  ),
  FamilyItem(
    label: t.catalog.families.succulent,
    value: 'succulent',
    icon: LucideIcons.clover,
  ),
  FamilyItem(
    label: t.catalog.families.aquatic,
    value: 'aquatic',
    icon: LucideIcons.waves,
  ),
  FamilyItem(
      label: t.catalog.families.climbing,
      value: 'climbing',
      icon: LucideIcons.flower_2),
  FamilyItem(
    label: t.catalog.families.bonsai,
    value: 'bonsai',
    icon: LucideIcons.sprout,
  ),
  FamilyItem(
    label: t.catalog.families.flower,
    value: 'flower',
    icon: LucideIcons.flower,
  ),
  FamilyItem(
    label: t.catalog.families.aromatic,
    value: 'aromatic',
    icon: LucideIcons.leaf,
  ),
  FamilyItem(
    label: t.catalog.families.medical,
    value: 'medical',
    icon: LucideIcons.pill,
  ),
  FamilyItem(
    label: t.catalog.families.carnivorous,
    value: 'carnivorous',
    icon: LucideIcons.ham,
  ),
];

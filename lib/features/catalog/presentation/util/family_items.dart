import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/family_item.dart';

final List<FamilyItem> familyItems = [
  FamilyItem(
    label: t.catalog.families.tropical,
    value: Family.tropical,
    icon: LucideIcons.tree_palm,
  ),
  FamilyItem(
    label: t.catalog.families.succulent,
    value: Family.succulent,
    icon: LucideIcons.clover,
  ),
  FamilyItem(
    label: t.catalog.families.aquatic,
    value: Family.aquatic,
    icon: LucideIcons.waves,
  ),
  FamilyItem(
      label: t.catalog.families.climbing,
      value: Family.climbing,
      icon: LucideIcons.flower_2),
  FamilyItem(
    label: t.catalog.families.bonsai,
    value: Family.bonsai,
    icon: LucideIcons.sprout,
  ),
  FamilyItem(
    label: t.catalog.families.flower,
    value: Family.flower,
    icon: LucideIcons.flower,
  ),
  FamilyItem(
    label: t.catalog.families.aromatic,
    value: Family.aromatic,
    icon: LucideIcons.leaf,
  ),
  FamilyItem(
    label: t.catalog.families.medical,
    value: Family.medical,
    icon: LucideIcons.pill,
  ),
  FamilyItem(
    label: t.catalog.families.carnivorous,
    value: Family.carnivorous,
    icon: LucideIcons.ham,
  ),
];

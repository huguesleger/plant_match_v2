import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/family_item.dart';

final List<FamilyItem> familyItems = [
  FamilyItem(
    label: 'Tropicale',
    value: 'tropical',
    icon: LucideIcons.tree_palm,
  ),
  FamilyItem(
    label: 'Succulente / Cactée',
    value: 'succulent',
    icon: LucideIcons.clover,
  ),
  FamilyItem(
    label: 'Aquatique',
    value: 'aquatic',
    icon: LucideIcons.waves,
  ),
  FamilyItem(label: 'Grimpante', value: 'climbing', icon: LucideIcons.flower_2),
  FamilyItem(
    label: 'Bonsaï et miniature',
    value: 'bonsai',
    icon: LucideIcons.sprout,
  ),
  FamilyItem(
    label: 'Fleur',
    value: 'flower',
    icon: LucideIcons.flower,
  ),
  FamilyItem(
    label: 'Aromatique',
    value: 'aromatic',
    icon: LucideIcons.leaf,
  ),
  FamilyItem(
    label: 'Médicinale',
    value: 'medical',
    icon: LucideIcons.pill,
  ),
  FamilyItem(
    label: 'Carnivore',
    value: 'carnivorous',
    icon: LucideIcons.ham,
  ),
];

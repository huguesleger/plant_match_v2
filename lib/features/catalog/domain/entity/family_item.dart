import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class FamilyItem {
  final String label;
  final Family value;
  final IconData icon;

  FamilyItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}

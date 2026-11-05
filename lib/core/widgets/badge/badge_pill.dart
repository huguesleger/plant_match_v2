import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class BadgePill extends StatelessWidget {
  const BadgePill({
    super.key,
    required this.text,
    required this.badgeColor,
    this.borderColor = const None(),
  });

  final Widget text;
  final Color badgeColor;
  final Option<Color> borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor.map((c) => Border.all(color: c)).toNullable(),
      ),
      child: text,
    );
  }

  factory BadgePill.outlined({
    required Widget text,
    required Color badgeColor,
    required Color borderColor,
  }) {
    return BadgePill(
      text: text,
      badgeColor: badgeColor,
      borderColor: Some(borderColor),
    );
  }
}

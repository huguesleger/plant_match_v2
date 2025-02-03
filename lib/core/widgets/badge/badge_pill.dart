import 'package:flutter/material.dart';

class BadgePill extends StatelessWidget {
  const BadgePill({
    super.key,
    required this.text,
    required this.badgeColor,
    this.borderColor,
  });

  final Widget text;
  final Color badgeColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
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
      borderColor: borderColor,
    );
  }
}

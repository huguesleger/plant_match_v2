import 'package:flutter/material.dart';

class ButtonRoundedWithIcon extends StatelessWidget {
  const ButtonRoundedWithIcon({
    super.key,
    required this.text,
    required this.onPressed,
    required this.bgColor,
    required this.textColor,
    this.fontSize = 14,
    required this.icon,
    this.iconAlignment = IconAlignment.end,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
  });

  const ButtonRoundedWithIcon.small({
    super.key,
    required this.text,
    required this.onPressed,
    required this.bgColor,
    required this.textColor,
    required this.icon,
    this.iconAlignment = IconAlignment.end,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  });

  final String text;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;
  final double? fontSize;
  final Widget icon;
  final IconAlignment iconAlignment;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bgColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      icon: icon,
      iconAlignment: iconAlignment,
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

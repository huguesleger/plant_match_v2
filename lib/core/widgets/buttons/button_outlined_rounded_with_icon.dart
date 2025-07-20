import 'package:flutter/material.dart';

class ButtonOutlinedRoundedWithIcon extends StatelessWidget {
  const ButtonOutlinedRoundedWithIcon({
    super.key,
    required this.text,
    required this.onPressed,
    required this.borderColor,
    required this.textColor,
    this.fontSize = 14,
    required this.icon,
    this.iconAlignment = IconAlignment.end,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
  });

  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double? fontSize;
  final Widget icon;
  final IconAlignment iconAlignment;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
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

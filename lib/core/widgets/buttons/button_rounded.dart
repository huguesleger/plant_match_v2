import 'package:flutter/material.dart';

class ButtonRounded extends StatelessWidget {
  const ButtonRounded({
    super.key,
    required this.text,
    this.onPressed,
    required this.bgColor,
    required this.textColor,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
  });

  const ButtonRounded.small({
    super.key,
    required this.text,
    this.onPressed,
    required this.bgColor,
    required this.textColor,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  });

  final String text;
  final VoidCallback? onPressed;
  final Color bgColor;
  final Color textColor;
  final double? fontSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: bgColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }
}

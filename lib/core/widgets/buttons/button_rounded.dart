import 'package:flutter/material.dart';

class ButtonRounded extends StatelessWidget {
  const ButtonRounded({
    super.key,
    required this.text,
    required this.onPressed,
    required this.bgColor,
    required this.textColor,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
  });

  final String text;
  final VoidCallback onPressed;
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

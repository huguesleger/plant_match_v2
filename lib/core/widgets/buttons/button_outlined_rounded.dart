import 'package:flutter/material.dart';

class ButtonOutlinedRounded extends StatelessWidget {
  const ButtonOutlinedRounded({
    super.key,
    required this.text,
    required this.onPressed,
    required this.borderColor,
    required this.textColor,
    this.fontSize = 14,
  });

  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

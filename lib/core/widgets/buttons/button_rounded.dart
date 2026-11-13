import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fpdart/fpdart.dart';

class ButtonRounded extends StatelessWidget {
  const ButtonRounded({
    super.key,
    required this.text,
    this.onPressed = const None(),
    required this.bgColor,
    required this.textColor,
    this.isLoading = false,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
  });

  const ButtonRounded.small({
    super.key,
    required this.text,
    this.onPressed = const None(),
    required this.bgColor,
    required this.textColor,
    this.isLoading = false,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  });

  final String text;
  final Option<VoidCallback> onPressed;
  final Color bgColor;
  final Color textColor;
  final bool isLoading;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Skeleton.leaf(
      child: FilledButton(
        onPressed: onPressed.filter((_) => !isLoading).toNullable(),
        style: FilledButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: bgColor,
          disabledBackgroundColor:
              Option.fromPredicate(bgColor, (_) => isLoading).toNullable(),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: fontSize + 4,
                height: fontSize + 4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Text(
                text,
                style: TextStyle(color: textColor, fontSize: fontSize),
              ),
      ),
    );
  }
}

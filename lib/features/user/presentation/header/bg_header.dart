import 'package:flutter/material.dart';

class BgHeader extends StatelessWidget {
  const BgHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'res/images/bg_user_screen.jpg',
      fit: BoxFit.cover,
    );
  }
}

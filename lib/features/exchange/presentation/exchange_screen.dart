import 'package:flutter/material.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({
    required this.body,
    required this.title,
    super.key,
  });

  final Widget body;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
    );
  }
}



import 'package:flutter/material.dart';

class GetStartedBgImage extends StatelessWidget {
  const GetStartedBgImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_intro.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

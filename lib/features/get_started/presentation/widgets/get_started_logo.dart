import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStartedLogo extends StatelessWidget {
  const GetStartedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: SvgPicture.asset('assets/logo/logo_white.svg'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_dynamic_header.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in/widgets/form_sign_in.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in/widgets/sign_in_header_logo.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in/widgets/sign_in_background.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
    required this.toggleSignInOrRegister,
  });

  final void Function() toggleSignInOrRegister;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarDynamicHeader(
        height: MediaQuery.of(context).size.height > 700 ? 345 : 250,
        leading: false,
        titlePadding: const EdgeInsets.only(bottom: 0),
        titlePaddingShrink: const EdgeInsets.only(bottom: 0),
        visual: const SignInHeaderLogo(),
        shrinkVisual: const SignInHeaderLogo(),
        body: Padding(
          padding: AppSpacing.paddingHorizontal,
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: TitlePage(
                    title: 'Hey! Bienvenue',
                  ),
                ),
                FormSignIn(toggleSignInOrRegister: toggleSignInOrRegister),
              ],
            ),
          ),
        ),
        backgroundAppBar : const SignInBackground(),
      ),
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  final double curveHeight;
  final double progress;
  BottomRoundedClipper({this.curveHeight = 60.0, this.progress = 1.0});

  @override
  Path getClip(Size size) {
    Path path = Path();
    
    // Les extrémités descendent vers size.height
    final yExtremities = size.height - curveHeight;
    // Le point de contrôle remonte vers size.height - 60
    final yControl = size.height - (60.0 - curveHeight);

    path.lineTo(0, yExtremities);
    path.quadraticBezierTo(
      size.width / 2,
      yControl,
      size.width,
      yExtremities,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant BottomRoundedClipper oldClipper) {
    return oldClipper.curveHeight != curveHeight || oldClipper.progress != progress;
  }
}

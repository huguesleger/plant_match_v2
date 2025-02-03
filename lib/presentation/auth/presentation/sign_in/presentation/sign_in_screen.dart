import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_dynamic_header.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/sign_in/presentation/form_sign_in.dart';

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: IconButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: AppColors.white,
          ),
          icon: const Icon(LucideIcons.chevron_left, color: AppColors.greyDark),
        ),
        titlePadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height > 700 ? 140 : 70,
            top: 50),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
        backgroundAppBar: SizedBox(
          //width: double.infinity,
          //height: MediaQuery.of(context).size.height * 0.4,
          child: ClipPath(
            clipper: BottomRoundedClipper(),
            child: Image.asset(
              'assets/images/auth/login.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

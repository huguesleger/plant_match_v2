import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/auth/presentation/register/register_page_route.dart';
import 'sign_in/sign_in_page_route.dart';

class SignInOrRegister extends StatefulWidget {
  const SignInOrRegister({super.key});

  @override
  State<SignInOrRegister> createState() => _SignInOrRegisterState();
}

class _SignInOrRegisterState extends State<SignInOrRegister> {
  bool showSignIn = true;

  void toggleSignInOrRegister() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInPageRoute(toggleSignInOrRegister: toggleSignInOrRegister);
    } else {
      return const RegisterPageRoute();
    }
  }
}

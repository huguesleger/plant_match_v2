import 'package:flutter/material.dart';
import 'package:plant_match_v2/presentation/auth/presentation/register/register_page.dart';

import 'sign_in/presentation/sign_in_page.dart';

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
      return SignInPage(toggleSignInOrRegister: toggleSignInOrRegister);
    } else {
      return const RegisterPage();
    }
  }
}

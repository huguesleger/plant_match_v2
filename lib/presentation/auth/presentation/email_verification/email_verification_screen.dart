import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';

class EmailVerificationScreen extends StatefulWidget {
  final UserAuth user;

  const EmailVerificationScreen({super.key, required this.user});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  //bool _checking = false;
  bool _cooldown = true;
  Timer? _autoTimer;
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    // Optionnel : vérification automatique toutes les 10s
    _autoTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        await context.read<AuthCubit>().checkEmailVerified();
      } catch (e) {
        // le Cubit émettra AuthError si besoin, rien à faire ici
      }
    });
  }

  void _startCooldown() {
    setState(() {
      _cooldown = true;
      _remainingSeconds = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() => _cooldown = false);
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  Future<void> _resendVerification() async {
    if (_cooldown) return;
    _startCooldown();

    setState(() {
      _cooldown = true;
      _remainingSeconds = 60; // durée du cooldown
    });

    try {
      await context.read<AuthCubit>().resendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Un nouvel email de vérification a été envoyé.")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.toString()}")),
      );
    } finally {
      // décompte
      for (var i = 60; i > 0; i--) {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        setState(() => _remainingSeconds = i - 1);
      }
      if (mounted) setState(() => _cooldown = false);
    }
  }

/*  Future<void> _checkVerificationOnce() async {
    setState(() => _checking = true);
    try {
      await context.read<AuthCubit>().checkEmailVerified();
      // Le cubit émettra Authenticated si vérifié -> RegisterPage le traitera et naviguera.
    } catch (e) {
      final err = e.toString().replaceFirst('Exception: ', '');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la vérification : $err")),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SvgPicture.asset('assets/logo/logo_color.svg'),
                ),
              ),
              const SizedBox(height: 20),
              const TitlePage(
                title: 'Valider votre compte',
                fontSize: AppTypo.textXl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Un e-mail à été envoyé sur votre adresse \n',
                    children: [
                      TextSpan(
                        text: widget.user.email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            '\nCliquez sur le lien pour vérifier votre e-mail.',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height > 700 ? 45 : 25),
              SizedBox(
                height: MediaQuery.of(context).size.height > 700 ? 373 : 280,
                child: Image.asset('assets/images/auth/verify_email.png'),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  TextButton(
                    onPressed: _cooldown ? null : _resendVerification,
                    child: Text(
                      _cooldown
                          ? "Réessayez dans $_remainingSeconds s"
                          : "Renvoyer l'email",
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonOutlinedRounded(
                      text: 'Retour',
                      borderColor: AppColors.greyLight,
                      textColor: AppColors.blueGreen,
                      onPressed: () {
                        context.read<AuthCubit>().reset();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    /*   return Scaffold(
      appBar: AppBar(title: const Text("Vérification de l'email")),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email_outlined, size: 80),
                const SizedBox(height: 16),
                Text("Un email a été envoyé à :\n${widget.user.email}",
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                _checking
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _checkVerificationOnce,
                        child: const Text("J'ai validé mon email"),
                      ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _cooldown ? null : _resendVerification,
                  child: Text(_cooldown
                      ? "Réessayez dans $_remainingSeconds s"
                      : "Renvoyer l'email"),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Si vous ne voyez pas l'email, vérifiez vos spams.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );*/
  }
}

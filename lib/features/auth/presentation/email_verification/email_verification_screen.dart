import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class EmailVerificationScreen extends StatefulWidget {
  final UserAuth user;

  const EmailVerificationScreen({super.key, required this.user});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with WidgetsBindingObserver {
  bool _cooldown = true;
  Timer? _autoTimer;
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCooldown();

    // ✅ Vérification automatique toutes les 5 secondes (au lieu de 10)
    _autoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkVerification();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ✅ Déclencher une vérification immédiate dès que l'utilisateur revient dans l'app
    if (state == AppLifecycleState.resumed) {
      _checkVerification();
    }
  }

  void _checkVerification() {
    if (!mounted) return;
    context
        .read<AuthCubit>()
        .checkEmailVerified(fullName: widget.user.fullName);
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
    WidgetsBinding.instance.removeObserver(this);
    _autoTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resendVerification() async {
    if (_cooldown) return;
    _startCooldown();

    try {
      context.read<AuthCubit>().resendEmailVerification();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.auth.emailVerification.resendEmailSent),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(t.auth.emailVerification.error(error: e.toString()))),
      );
    } finally {
      for (var i = 60; i > 0; i--) {
        await Future.delayed(const Duration(seconds: 1));
        setState(() => _remainingSeconds = i - 1);
      }
      if (mounted) setState(() => _cooldown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Assets.res.logo.logoColor.svg(),
                ),
              ),
              const SizedBox(height: 20),
              TitlePage(
                title: t.auth.emailVerification.title,
                fontSize: AppTypo.textXl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: t.auth.emailVerification.description,
                    children: [
                      TextSpan(
                        text: widget.user.email.getOrElse(() => ''),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: t.auth.emailVerification.instruction,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Assets.res.images.auth.verifyEmail.image(
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  TextButton(
                    onPressed: _cooldown ? null : _resendVerification,
                    child: Text(
                      _cooldown
                          ? t.auth.emailVerification
                              .retryLabel(count: _remainingSeconds)
                          : t.auth.emailVerification.resendBtn,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonOutlinedRounded(
                      text: t.auth.common.back,
                      borderColor: AppColors.greyLight,
                      textColor: AppColors.blueGreen,
                      onPressed: () {
                        final cubit = context.read<AuthCubit>();
                        cubit.deleteUnverifiedUser();
                        cubit.reset();
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
  }
}

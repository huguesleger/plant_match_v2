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
  Option<Timer> _autoTimer = const None();
  Option<Timer> _timer = const None();
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCooldown();

    _autoTimer = Some(Timer.periodic(const Duration(seconds: 5), (_) {
      _checkVerification();
    }));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVerification();
    }
  }

  void _checkVerification() {
    if (!mounted) return;
    context
        .read<AuthCubit>()
        .checkEmailVerified(fullName: Some(widget.user.fullName));
  }

  void _startCooldown() {
    setState(() {
      _cooldown = true;
      _remainingSeconds = 60;
    });

    _cancel(_timer);
    _timer = Some(Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
      } else if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() => _cooldown = false);
      } else {
        setState(() => _remainingSeconds--);
      }
    }));
  }

  void _cancel(Option<Timer> timer) => timer.match(() {}, (t) => t.cancel());

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancel(_autoTimer);
    _cancel(_timer);
    super.dispose();
  }

  Future<void> _resendVerification() async {
    if (_cooldown) return;
    _startCooldown();

    final messenger = ScaffoldMessenger.of(context);
    final result =
        await context.read<AuthCubit>().resendEmailVerification().run();
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.match(
            (failure) => t.auth.emailVerification.error(error: failure.message),
            (_) => t.auth.emailVerification.resendEmailSent,
          ),
        ),
      ),
    );
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
                textAlign: const Some(TextAlign.center),
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
                    onPressed: Option.fromPredicate(
                      _resendVerification,
                      (_) => !_cooldown,
                    ).toNullable(),
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

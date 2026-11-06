import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/core/widgets/error/error_page_actions.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({
    super.key,
    required Failure failure,
    required this.onRetry,
    this.onPressed = const None(),
  }) : content = failure.errorContent;

  final ErrorContent content;
  final Option<VoidCallback> onPressed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TitlePage(
                  title: content.title,
                  fontSize: AppTypo.textXl,
                ),
                const SizedBox(height: 5),
                Text(content.message),
                const SizedBox(height: 30),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Assets.res.images.auth.error.image(
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ErrorPageActions(
                  onBack: onPressed.alt(
                    () => Option.fromPredicate(
                      () => Navigator.of(context).maybePop(),
                      (_) => Navigator.of(context).canPop(),
                    ),
                  ),
                  primary: _primaryAction(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Option<(String, VoidCallback)> _primaryAction(BuildContext context) =>
      switch (content.action) {
        RetryAction() => Some((t.widgets.error.retry, onRetry)),
        ReconnectAction() => Some((
            t.widgets.error.reconnect,
            () => context.read<AuthCubit>().logOut(),
          )),
        NoAction() => const None(),
      };
}

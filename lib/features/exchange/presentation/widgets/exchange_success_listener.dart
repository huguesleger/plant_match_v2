import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_proposal_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_proposal_state.dart';

class ExchangeSuccessListener extends StatelessWidget {
  const ExchangeSuccessListener({super.key, required this.child});

  final Widget child;

  static const _closeDelay = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) =>
      BlocListener<ExchangeProposalCubit, ExchangeProposalState>(
        listenWhen: (_, current) => current is ExchangeProposalSuccess,
        listener: (context, _) => Future.delayed(_closeDelay).then(
          (_) => context.mounted ? Navigator.pop(context) : null,
        ),
        child: child,
      );
}

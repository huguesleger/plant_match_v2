import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/dots_loader/dots_loader_page.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_proposal_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_proposal_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_app_bar.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_confirmation.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_list.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_picker.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ExchangeProposalCubit, ExchangeProposalState>(
        builder: (context, state) {
          final (title, body) = switch (state) {
            ExchangeProposalLoading(:final boneMocks) => (
                t.exchange.screen.picking_title,
                AppSkeletonizer(
                  enabled: true,
                  child: ExchangePlantList(plants: boneMocks),
                ),
              ),
            ExchangeProposalPicking(:final userPlants) => (
                t.exchange.screen.picking_title,
                ExchangePlantPicker(plants: userPlants, userId: userId),
              ),
            ExchangeProposalConfirming(
              :final targetPlant,
              :final offeredPlant,
            ) =>
              (
                t.exchange.screen.confirm_title,
                ExchangeConfirmation(
                  targetPlant: targetPlant,
                  offeredPlant: offeredPlant,
                ),
              ),
            ExchangeProposalSending() => (
                t.exchange.screen.confirm_title,
                const DotsLoaderPage(),
              ),
            ExchangeProposalSuccess() => (
                t.exchange.screen.success_title,
                Center(child: Text(t.exchange.screen.success_message)),
              ),
            ExchangeProposalError(:final failure) => (
                t.exchange.screen.error_title,
                ErrorPage(
                  failure: failure,
                  onRetry: context.read<ExchangeProposalCubit>().load,
                ),
              ),
          };

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: ExchangeAppBar(title: title),
            body: SafeArea(child: body),
          );
        },
      );
}

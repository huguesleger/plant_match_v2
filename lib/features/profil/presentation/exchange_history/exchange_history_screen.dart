import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/filter/filter_bar.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_state.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/history_item.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/widgets/empty_history_view.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/widgets/history_card_item.dart';

class ExchangeHistoryScreen extends StatelessWidget {
  const ExchangeHistoryScreen({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Historique',
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.black,
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(color: AppColors.greyLight),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          BlocBuilder<ExchangeHistoryCubit, ExchangeHistoryState>(
            builder: (context, state) => FilterBar<HistoryStatusFilter>(
              filters: HistoryStatusFilter.values,
              selected: switch (state) {
                ExchangeHistoryLoaded s => s.currentFilter,
                _ => HistoryStatusFilter.all,
              },
              onChanged: (filter) =>
                  context.read<ExchangeHistoryCubit>().load(filter: filter),
              labelBuilder: (f) => f.label,
              iconBuilder: (f) => f.icon,
            ),
          ),
          Expanded(
            child: BlocBuilder<ExchangeHistoryCubit, ExchangeHistoryState>(
              builder: (context, state) => switch (state) {
                ExchangeHistoryInitial() ||
                ExchangeHistoryLoading() =>
                  const Center(child: CircularProgressIndicator()),
                ExchangeHistoryError s => Center(
                    child: Text(
                      'Erreur : ${s.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ExchangeHistoryLoaded s => s.items.isEmpty
                    ? const EmptyHistoryView()
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 20),
                        itemCount: s.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => HistoryCardItem(
                          item: s.items[index],
                          currentUserId: currentUserId,
                        ),
                      ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

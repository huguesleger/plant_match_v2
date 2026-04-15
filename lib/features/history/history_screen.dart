import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/filter/filter_bar.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_cubit.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_state.dart';
import 'package:plant_match_v2/features/history/widgets/history_item.dart';
import 'package:plant_match_v2/features/history/widgets/empty_history_view.dart';
import 'package:plant_match_v2/features/history/widgets/history_card_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
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
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) => FilterBar<HistoryStatusFilter>(
              filters: HistoryStatusFilter.values,
              selected: switch (state) {
                HistoryLoaded s => s.currentFilter,
                HistoryInitial() ||
                HistoryLoading() ||
                HistoryError() =>
                  HistoryStatusFilter.all,
              },
              onChanged: (filter) =>
                  context.read<HistoryCubit>().load(filter: filter),
              labelBuilder: (f) => f.label,
              iconBuilder: (f) => f.icon,
            ),
          ),
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) => switch (state) {
                HistoryInitial() ||
                HistoryLoading() =>
                  const Center(child: CircularProgressIndicator()),
                HistoryError s => Center(
                    child: Text(
                      'Erreur : ${s.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                HistoryLoaded s => s.items.isEmpty
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

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/filter/filter_bar.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_cubit.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_state.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/history_item.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/history_content.dart';

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
        title: Some(t.history.screen.title),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: const Some(AppColors.black),
        styleIconButton: Some(IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(color: AppColors.greyLight),
        )),
        onPressed: Some(() => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) => FilterBar<HistoryStatusFilter>(
              filters: HistoryStatusFilter.values,
              selected: switch (state) {
                HistoryLoaded s => s.currentFilter,
                HistoryLoading s => s.currentFilter,
                HistoryInitial() || HistoryError() => HistoryStatusFilter.all,
              },
              onChanged: (filter) =>
                  context.read<HistoryCubit>().load(filter: filter),
              labelBuilder: (f) => f.label,
              iconBuilder: (f) => f.icon,
            ),
          ),
          Expanded(
            child: HistoryContent(currentUserId: currentUserId),
          ),
        ],
      ),
    );
  }
}

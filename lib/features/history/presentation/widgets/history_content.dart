import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_fill_view.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_screen.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_cubit.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_state.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/empty_history_view.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/history_list.dart';

class HistoryContent extends StatelessWidget {
  const HistoryContent({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) => switch (state) {
          HistoryInitial() => const SizedBox.shrink(),
          HistoryLoading(:final boneMocks) => AppSkeletonizer(
              enabled: true,
              child: HistoryList(
                items: boneMocks,
                currentUserId: currentUserId,
              ),
            ),
          HistoryError s => Center(
              child: Text(
                s.failure.errorContent.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          HistoryLoaded s => RefreshScreen(
              onRefresh: context.read<HistoryCubit>().refresh,
              child: s.items.isEmpty
                  ? const RefreshFillView(child: EmptyHistoryView())
                  : HistoryList(
                      items: s.items,
                      currentUserId: currentUserId,
                    ),
            ),
        },
      );
}

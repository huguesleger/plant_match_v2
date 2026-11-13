import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/history_card_item.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/history_item.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    required this.items,
    required this.currentUserId,
  });

  final List<HistoryItem> items;
  final String currentUserId;

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => HistoryCardItem(
          item: items[index],
          currentUserId: currentUserId,
        ),
      );
}

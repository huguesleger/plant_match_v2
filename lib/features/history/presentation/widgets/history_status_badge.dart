import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';

class HistoryStatusBadge extends StatelessWidget {
  const HistoryStatusBadge({
    super.key,
    required this.rawStatus,
  });

  final String rawStatus;

  @override
  Widget build(BuildContext context) {
    final s = _statusStyle(rawStatus);
    return BadgePill(
      text: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 12, color: s.color),
          const SizedBox(width: 4),
          Text(s.text, style: TextStyle(fontSize: 10, color: s.color)),
        ],
      ),
      badgeColor: s.color.withValues(alpha: 0.1),
    );
  }

  ({Color color, String text, IconData icon}) _statusStyle(String rawStatus) {
    final pending = (
      color: Colors.orange,
      text: t.history.status.pending,
      icon: Icons.hourglass_empty,
    );
    return Option.fromNullable(ExchangeStatus.values.asNameMap()[rawStatus])
        .match(
      () => pending,
      (status) => switch (status) {
        ExchangeStatus.accepted => (
            color: Colors.green,
            text: t.history.status.accepted,
            icon: Icons.check_circle,
          ),
        ExchangeStatus.completed => (
            color: Colors.blue,
            text: t.history.status.completed,
            icon: Icons.done_all,
          ),
        ExchangeStatus.rejected => (
            color: Colors.red,
            text: t.history.status.rejected,
            icon: Icons.cancel,
          ),
        ExchangeStatus.pending || ExchangeStatus.waitingValidation => pending,
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';

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
    return switch (rawStatus) {
      'accepted' => (
          color: Colors.green,
          text: t.history.status.accepted,
          icon: Icons.check_circle,
        ),
      'completed' => (
          color: Colors.blue,
          text: t.history.status.completed,
          icon: Icons.done_all,
        ),
      'rejected' => (
          color: Colors.red,
          text: t.history.status.rejected,
          icon: Icons.cancel,
        ),
      _ => (
          color: Colors.orange,
          text: t.history.status.pending,
          icon: Icons.hourglass_empty,
        ),
    };
  }
}

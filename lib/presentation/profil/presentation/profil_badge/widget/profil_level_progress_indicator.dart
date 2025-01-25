import 'package:flutter/material.dart';

class ProfilLevelProgressIndicator extends StatelessWidget {
  const ProfilLevelProgressIndicator({
    super.key,
    required this.currentPoints,
    required this.maxPoints,
    required this.level,
  });

  final int currentPoints;
  final int maxPoints;
  final int level;

  @override
  Widget build(BuildContext context) {
    double progress = currentPoints / maxPoints;

    return Container(
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Niveau $level',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          Text(
            '$currentPoints / $maxPoints points',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

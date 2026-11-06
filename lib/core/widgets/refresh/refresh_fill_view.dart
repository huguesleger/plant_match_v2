import 'package:flutter/material.dart';

class RefreshFillView extends StatelessWidget {
  const RefreshFillView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(hasScrollBody: false, child: child),
        ],
      );
}

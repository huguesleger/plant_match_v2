import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/widgets/app_loader/app_loader.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_page.dart';

class AppLoaderGate extends StatefulWidget {
  const AppLoaderGate({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<AppLoaderGate> createState() => _AppLoaderGateState();
}

class _AppLoaderGateState extends State<AppLoaderGate> {
  Option<Timer> _timer = const None();
  bool _holding = false;

  @override
  void initState() {
    super.initState();
    if (widget.isLoading) _hold();
  }

  @override
  void didUpdateWidget(covariant AppLoaderGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading && !_holding) _hold();
  }

  void _hold() {
    _holding = true;
    _timer = Some(Timer(AppLoader.minDuration, _release));
  }

  void _release() {
    if (mounted) setState(() => _holding = false);
  }

  @override
  void dispose() {
    _timer.match(() {}, (timer) => timer.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.isLoading || _holding ? const AppLoaderPage() : widget.child;
}

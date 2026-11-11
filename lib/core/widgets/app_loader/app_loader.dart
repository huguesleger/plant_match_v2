import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key, this.width = 160});

  final double width;

  static const minDuration = Duration(milliseconds: 2500);

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  static const _loopStart = 0.5;

  late final AnimationController _controller = AnimationController(
    vsync: this,
  );

  void _play(LottieComposition composition) => _controller
    ..duration = composition.duration
    ..forward(from: 0).then(
      (_) => _controller.repeat(min: _loopStart, max: 1),
    );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Assets.res.animations.plantMatchLoader.lottie(
        controller: _controller,
        width: widget.width,
        fit: BoxFit.contain,
        onLoaded: _play,
      );
}

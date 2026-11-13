import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width = const None(),
    this.height = const None(),
    this.fit = BoxFit.cover,
    this.errorWidget = const None(),
  });

  final String url;
  final Option<double> width;
  final Option<double> height;
  final BoxFit fit;
  final Option<Widget> errorWidget;

  static const _fadeInDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: url,
        width: width.toNullable(),
        height: height.toNullable(),
        fit: fit,
        fadeInDuration: _fadeInDuration,
        placeholder: (_, __) => _ImagePlaceholder(width: width, height: height),
        errorWidget: (_, __, ___) => errorWidget.getOrElse(
          () => Assets.res.images.emptyPicture.image(
            width: width.toNullable(),
            height: height.toNullable(),
            fit: fit,
          ),
        ),
      );
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.width, required this.height});

  final Option<double> width;
  final Option<double> height;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => AppSkeletonizer(
          enabled: true,
          child: Bone(
            width: width.getOrElse(
              () => constraints.hasBoundedWidth ? constraints.maxWidth : 0,
            ),
            height: height.getOrElse(
              () => constraints.hasBoundedHeight ? constraints.maxHeight : 0,
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class HistoryCardImage extends StatelessWidget {
  const HistoryCardImage({
    super.key,
    this.imageUrl,
    required this.height,
    required this.width,
  });

  final String? imageUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final imageOpt =
        Option.fromNullable(imageUrl).filter((url) => url.startsWith('http'));

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageOpt.match(
        () => Image(
          image: const AssetImage('res/images/empty_picture.png'),
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
        (url) => Image.network(
          url,
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

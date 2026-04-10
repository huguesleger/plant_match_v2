import 'package:flutter/material.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrl != null && imageUrl!.startsWith('http')
          ? Image.network(
              imageUrl!,
              height: height,
              width: width,
              fit: BoxFit.cover,
            )
          : Image(
              image: const AssetImage('assets/images/empty_picture.png'),
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
    );
  }
}

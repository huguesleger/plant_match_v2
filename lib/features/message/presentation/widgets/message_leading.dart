import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class MessageLeading extends StatelessWidget {
  const MessageLeading({
    super.key,
    required this.plantImage,
  });

  final String plantImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: plantImage.isNotEmpty
          ? Image.network(
              plantImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          : Container(
              width: 50,
              height: 50,
              color: AppColors.greyLight,
              child: const Icon(
                Icons.local_florist,
                color: AppColors.greyDark,
              ),
            ),
    );
  }
}

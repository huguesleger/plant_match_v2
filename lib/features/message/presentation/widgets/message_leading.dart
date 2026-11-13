import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/widgets/network_image/app_network_image.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class MessageLeading extends StatelessWidget {
  const MessageLeading({
    super.key,
    required this.plantImage,
    required this.isOnline,
  });

  final String plantImage;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: plantImage.isNotEmpty
              ? AppNetworkImage(
                  url: plantImage,
                  width: const Some(50),
                  height: const Some(50),
                )
              : Skeleton.leaf(
                  child: Container(
                    width: 50,
                    height: 50,
                    color: AppColors.greyLight,
                    child: const Icon(
                      Icons.local_florist,
                      color: AppColors.greyDark,
                    ),
                  ),
                ),
        ),
        Positioned(
          bottom: -3,
          right: -6,
          child: Skeleton.leaf(
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isOnline ? AppColors.green : AppColors.red,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

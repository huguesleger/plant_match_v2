import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class MessageSubtitle extends StatelessWidget {
  const MessageSubtitle({
    super.key,
    required this.lastMessage,
  });

  final String? lastMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          lastMessage ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: InterTextStyle.inter(
            AppTypo.textS,
            color: AppColors.greyMedium,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

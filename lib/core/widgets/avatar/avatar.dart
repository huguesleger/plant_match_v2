import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/widgets/network_image/app_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.profilUser = const None(),
    this.imageUrl = const None(),
    this.name = const None(),
    this.radius = 30,
    this.imgSizeAvatar = 60,
    this.backgroundColor = AppColors.greenMedium,
  });

  final Option<ProfilUser> profilUser;
  final Option<String> imageUrl;
  final Option<String> name;
  final double radius;
  final double imgSizeAvatar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final String effectiveImageUrl = imageUrl
        .alt(() => profilUser.map((user) => user.profilImg))
        .getOrElse(() => '');
    final String effectiveName = name
        .alt(
          () => profilUser.map(
            (user) => user.userName.getOrElse(() => user.firstName),
          ),
        )
        .getOrElse(() => '');

    final bool isNetworkImage = effectiveImageUrl.contains('http');
    final bool isSelectedAvatar =
        effectiveImageUrl.isNotEmpty && effectiveImageUrl.contains('avatar');

    return Skeleton.leaf(
      child: isSelectedAvatar
          ? _buildSelectedAvatar(effectiveImageUrl)
          : CircleAvatar(
              backgroundColor: backgroundColor,
              radius: radius,
              child: ClipOval(
                child: isNetworkImage
                    ? _buildNetworkImage(effectiveImageUrl)
                    : Center(
                        child: Text(
                          effectiveName.toInitials(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: radius * 0.65,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
    );
  }

  Widget _buildSelectedAvatar(String url) {
    return Container(
      width: imgSizeAvatar,
      height: imgSizeAvatar,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: ClipOval(
        child: Transform.scale(
          alignment: Alignment.center,
          scale: 0.65,
          child: AppNetworkImage(url: url, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    return AppNetworkImage(
      url: url,
      width: Some(imgSizeAvatar),
      height: Some(imgSizeAvatar),
    );
  }
}

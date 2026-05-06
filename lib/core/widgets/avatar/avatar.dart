import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.profilUser,
    this.radius = 30,
    this.imgSizeAvatar = 60,
    this.defaultSizeAvatar = 45,
  });

  final ProfilUser profilUser;
  final double radius;
  final double imgSizeAvatar;
  final double defaultSizeAvatar;

  @override
  Widget build(BuildContext context) {
    String imageUrl = profilUser.profilImg;

    final String defaultAvatarPath = Assets.res.images.avatarPng.path;
    final bool isNetworkImage = imageUrl.contains('http');
    final bool isDefaultAvatar =
        imageUrl.isEmpty || imageUrl == defaultAvatarPath;
    final bool isSelectedAvatar =
        imageUrl.isNotEmpty && !isDefaultAvatar && imageUrl.contains('avatar');

    if (isSelectedAvatar) {
      return _buildSelectedAvatar(imageUrl);
    }

    return CircleAvatar(
      backgroundColor: AppColors.greyLight,
      radius: radius,
      child: ClipOval(
        child: isNetworkImage
            ? _buildNetworkImage(imageUrl)
            : Assets.res.images.avatarPng.image(
                width: defaultSizeAvatar,
                height: defaultSizeAvatar,
                alignment: Alignment.bottomCenter,
              ),
      ),
    );
  }

  Widget _buildSelectedAvatar(String url) {
    return Container(
      width: imgSizeAvatar,
      height: imgSizeAvatar,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.greyLight,
      ),
      child: ClipOval(
        child: Transform.scale(
          alignment: Alignment.center,
          scale: 0.65,
          child: Image.network(url),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: imgSizeAvatar,
      height: imgSizeAvatar,
    );
  }
}

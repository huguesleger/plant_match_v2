import 'package:flutter/material.dart';
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

    if (imageUrl.isEmpty) {
      imageUrl = 'res/images/avatar.png';
    }

    const String defaultAvatar = 'res/images/avatar.png';
    final bool isNetworkImage = imageUrl.contains('http');
    final bool isDefaultAvatar = imageUrl == defaultAvatar;
    final bool isSelectedAvatar = imageUrl.isNotEmpty &&
        !isDefaultAvatar &&
        imageUrl.contains('avatar');

    if (isSelectedAvatar) {
      return _buildSelectedAvatar(imageUrl);
    }

    return CircleAvatar(
      backgroundColor: AppColors.greyLight,
      radius: radius,
      child: ClipOval(
        child: isNetworkImage
            ? _buildNetworkImage(imageUrl)
            : _buildDefaultAvatar(defaultAvatar),
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

  Widget _buildDefaultAvatar(String url) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        url,
        width: defaultSizeAvatar,
        height: defaultSizeAvatar,
      ),
    );
  }
}

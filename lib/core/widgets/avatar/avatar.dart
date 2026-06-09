import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.profilUser,
    this.imageUrl,
    this.name,
    this.radius = 30,
    this.imgSizeAvatar = 60,
    this.backgroundColor = AppColors.greenMedium,
  });

  final ProfilUser? profilUser;
  final String? imageUrl;
  final String? name;
  final double radius;
  final double imgSizeAvatar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final String effectiveImageUrl = imageUrl ?? profilUser?.profilImg ?? '';
    final String effectiveName = name ??
        profilUser?.userName.getOrElse(() => profilUser?.firstName ?? '') ??
        '';

    final bool isNetworkImage = effectiveImageUrl.contains('http');
    final bool isSelectedAvatar =
        effectiveImageUrl.isNotEmpty && effectiveImageUrl.contains('avatar');

    if (isSelectedAvatar) {
      return _buildSelectedAvatar(effectiveImageUrl);
    }

    return CircleAvatar(
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

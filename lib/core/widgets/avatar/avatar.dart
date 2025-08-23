import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_state.dart';

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
    return BlocBuilder<ProfilCubit, ProfilState>(
      builder: (context, state) {
        String imageUrl = profilUser.profilImg;

        if (state is ProfilLoaded) {
          imageUrl = state.profilUser.profilImg.isNotEmpty
              ? state.profilUser.profilImg
              : 'assets/images/avatar.png';
        }

        const String defaultAvatar = 'assets/images/avatar.png';
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
      },
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_state.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.profilUser});

  final ProfilUser profilUser;

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

        const imgAvatar = 'assets/images/avatar.png';

        return CircleAvatar(
          backgroundColor: AppColors.greyLight,
          radius: 30,
          child: ClipOval(
            child: imageUrl.isNotEmpty &&
                    imageUrl != imgAvatar &&
                    imageUrl.contains('http')
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  )
                : const Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image(
                          image: AssetImage(imgAvatar),
                          width: 45,
                          height: 45,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

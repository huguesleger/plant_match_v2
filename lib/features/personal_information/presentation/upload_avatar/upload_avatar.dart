import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/personal_information/presentation/upload_avatar/show_image_source_bottom_sheet.dart';

class UploadAvatar extends StatefulWidget {
  const UploadAvatar({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  State<UploadAvatar> createState() => _UploadAvatarState();
}

class _UploadAvatarState extends State<UploadAvatar> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 300,
    );

    if (mounted && image != null) {
      final profilCubit = context.read<ProfilCubit>();
      profilCubit.updateProfilImage(
        uid: widget.profilUser.uid,
        imagePath: image.path,
        isAsset: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilCubit, ProfilState>(
      builder: (context, state) {
        String avatarUrl = widget.profilUser.profilImg;

        if (state is ProfilLoaded) {
          avatarUrl = state.profilUser.profilImg;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(60),
              onTap: () {
                showImageSourceBottomSheet(
                  context: context,
                  profilUser: widget.profilUser,
                  onPickImage: _pickImage,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(
                        color: AppColors.white,
                        width: 2,
                      ),
                    ),
                    child: Avatar(
                      profilUser: state is ProfilLoaded
                          ? state.profilUser
                          : widget.profilUser,
                      imageUrl: avatarUrl,
                      radius: 60,
                      imgSizeAvatar: 120,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.greenLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.pencil,
                        color: AppColors.blueGreen,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

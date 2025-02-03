import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart'; // Importez ce package
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/presentation/profil_personal_upload_avatar/show_image_source_bottom_sheet.dart';

class ProfilPersonalUploadAvatar extends StatefulWidget {
  const ProfilPersonalUploadAvatar({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  State<ProfilPersonalUploadAvatar> createState() =>
      _ProfilPersonalUploadAvatarState();
}

class _ProfilPersonalUploadAvatarState
    extends State<ProfilPersonalUploadAvatar> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (mounted) {
      if (image != null) {
        final profilCubit = context.read<ProfilCubit>();
        profilCubit.updateProfilUser(
          uid: widget.profilUser.uid,
          imageUrl: image.path,
        );
      }
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

        final profilImage = avatarUrl.isNotEmpty && avatarUrl.contains('http')
            ? NetworkImage(avatarUrl)
            : const AssetImage('assets/images/avatar.png');

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
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.greyLight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: profilImage is AssetImage
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Image(
                                image: profilImage,
                                width: 120,
                                height: 100,
                                //fit: BoxFit.cover,
                              ),
                            )
                          : Image(
                              image: profilImage as ImageProvider,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
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

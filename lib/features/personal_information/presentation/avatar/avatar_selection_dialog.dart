import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/avatar/avatar_collection_list.dart';

class AvatarSelectionDialog extends StatefulWidget {
  final ProfilUser profilUser;

  const AvatarSelectionDialog({super.key, required this.profilUser});

  @override
  State<AvatarSelectionDialog> createState() => _AvatarSelectionDialogState();
}

class _AvatarSelectionDialogState extends State<AvatarSelectionDialog> {
  int selectedIndex = -1;

  late final List<AssetGenImage> avatars;

  @override
  void initState() {
    super.initState();
    avatars = Assets.res.images.avatar.values;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AvatarCollectionList(
          avatars: avatars,
          selectedIndex: selectedIndex,
          onAvatarSelected: (avatar) {
            setState(() {
              selectedIndex = avatars.indexOf(avatar);
            });
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ButtonOutlinedRounded(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                text: 'Annuler',
                borderColor: AppColors.greyLight,
                textColor: AppColors.greyMedium,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ButtonRounded(
                text: 'Valider',
                bgColor: AppColors.greenLight,
                textColor: AppColors.blueGreen,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                onPressed: selectedIndex != -1
                    ? () async {
                        final selectedAvatar = avatars[selectedIndex];
                        final profilCubit = context.read<ProfilCubit>();
                        final navigator = Navigator.of(context);

                        profilCubit.updateProfilImage(
                          uid: widget.profilUser.uid,
                          imagePath: selectedAvatar.path,
                          isAsset: true,
                        );
                        if (mounted) {
                          navigator.pop(true);
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

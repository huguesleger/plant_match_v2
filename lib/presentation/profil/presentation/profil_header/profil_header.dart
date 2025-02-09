import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

class ProfilHeader extends StatelessWidget {
  const ProfilHeader({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TitlePage(
            title: profilUser.userName.isNotEmpty
                ? profilUser.userName.toCapitalizeWords()
                : profilUser.fullName.toCapitalizeWords(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Avatar(profilUser: profilUser),
      ],
    );
  }
}

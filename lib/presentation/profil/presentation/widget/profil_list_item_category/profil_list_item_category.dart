import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/presentation/profil_personal_information.dart';
import 'package:plant_match_v2/presentation/profil/presentation/widget/profil_list_item_category/profil_list_item.dart';

class ProfilListItemCategory extends StatelessWidget {
  const ProfilListItemCategory({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProfilListItem(
          title: 'Informations personnelles',
          icon: LucideIcons.user_cog,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilPersonalInformation(
                  profilUser: profilUser,
                  userId: profilUser.uid,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        ProfilListItem(
          title: 'Historique d’échanges',
          icon: LucideIcons.history,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfilListItem(
          title: 'Paramètres de compte',
          icon: LucideIcons.settings,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfilListItem(
          title: 'Aide',
          icon: LucideIcons.message_circle_question,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfilListItem(
          title: 'Informations juridiques',
          icon: LucideIcons.file_text,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        ProfilListItem(
          title: 'A propos',
          icon: LucideIcons.info,
          onTap: () {},
        ),
      ],
    );
  }
}

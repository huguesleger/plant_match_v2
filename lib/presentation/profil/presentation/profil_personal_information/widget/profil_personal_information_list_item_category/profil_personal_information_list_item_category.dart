import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/widget/profil_personal_information_list_item_category/profil_personal_information_list_item.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/widget/profil_personal_information_wizard/profil_personal_information_wizard.dart';

class ProfilPersonalInformationListItemCategory extends StatelessWidget {
  const ProfilPersonalInformationListItemCategory(
      {super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilCubit, ProfilState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitlePage(
              title: 'Détail de mon profil',
              fontSize: AppTypo.textXl,
            ),
            ProfilPersonalInformationListItem(
              title: 'Pseudo d\'affichage',
              subtitle: profilUser.userName.isEmpty
                  ? 'A renseigner'
                  : profilUser.userName,
/*              onTap: () async {
                final profilCubit = context.read<ProfilCubit>();
                profilCubit.getProfilUser(profilUser.uid);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilPersonalInformationWizard(
                      profilUser: profilUser,
                    ),
                  ),
                );
                profilCubit.getProfilUser(profilUser.uid);
              },*/
            ),
            const Divider(height: 0),
            ProfilPersonalInformationListItem(
              title: 'Date d\'anniversaire',
              subtitle: profilUser.birthdayDate.toString().isNotEmpty
                  ? DateFormat('dd/MM/yyyy').format(profilUser.birthdayDate)
                  : 'A renseigner',
            ),
            const Divider(height: 0),
            ProfilPersonalInformationListItem(
              title: 'Bio',
              subtitle:
                  profilUser.bio.isEmpty ? 'A renseigner' : profilUser.bio,
            ),
            const Divider(height: 0),
            ProfilPersonalInformationListItem(
              title: 'Localisation',
              subtitle: profilUser.localisation.isEmpty
                  ? 'A renseigner'
                  : profilUser.localisation,
            ),
            const Divider(height: 0),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ButtonRounded(
                text: 'Modifier mon profil',
                onPressed: () async {
                  final profilCubit = context.read<ProfilCubit>();
                  profilCubit.getProfilUser(profilUser.uid);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilPersonalInformationWizard(
                        profilUser: profilUser,
                      ),
                    ),
                  );
                  profilCubit.getProfilUser(profilUser.uid);
                },
                bgColor: AppColors.greenLight,
                textColor: AppColors.blueGreen,
              ),
            ),
          ],
        );
      },
    );
  }
}

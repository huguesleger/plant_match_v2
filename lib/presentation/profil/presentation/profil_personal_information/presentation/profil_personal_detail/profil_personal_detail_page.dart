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
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/presentation/profil_personal_detail/profil_personal_detail_item.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/presentation/profil_personal_detail_wizard/profil_personal_detail_wizard_page.dart';

class ProfilPersonalDetailPage extends StatelessWidget {
  const ProfilPersonalDetailPage({super.key, required this.profilUser});

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
            ProfilPersonalDetailItem(
              title: 'Pseudo d\'affichage',
              subtitle: profilUser.userName.isEmpty
                  ? 'A renseigner'
                  : profilUser.userName,
              onTap: () async {
                final profilCubit = context.read<ProfilCubit>();
                await profilCubit.clearField(
                    uid: profilUser.uid, fieldName: 'userName');
              },
            ),
            const Divider(height: 0),
            ProfilPersonalDetailItem(
              title: 'Date d\'anniversaire',
              subtitle: profilUser.birthdayDate != null
                  ? DateFormat('dd/MM/yyyy').format(profilUser.birthdayDate!)
                  : 'A renseigner',
            ),
            const Divider(height: 0),
            ProfilPersonalDetailItem(
              title: 'Bio',
              subtitle: profilUser.bio != '' ? profilUser.bio! : 'A renseigner',
              onTap: () async {
                final profilCubit = context.read<ProfilCubit>();
                await profilCubit.clearField(
                    uid: profilUser.uid, fieldName: 'bio');
              },
            ),
            const Divider(height: 0),
            ProfilPersonalDetailItem(
              title: 'Localisation',
              subtitle: profilUser.localisation.isEmpty
                  ? 'A renseigner'
                  : '${profilUser.localisation} - ${profilUser.country}',
              onTap: () async {
                final profilCubit = context.read<ProfilCubit>();
                await profilCubit.clearField(
                  uid: profilUser.uid,
                  fieldName: 'localisation',
                );
                await profilCubit.clearField(
                  uid: profilUser.uid,
                  fieldName: 'country',
                );
              },
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
                      builder: (context) => ProfilPersonalDetailWizardPage(
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/personal_information/presentation/detail/detail_item.dart';
import 'package:plant_match_v2/features/personal_information/presentation/detail_wizard/wizard_page.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.profilUser});

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
            DetailItem(
              title: 'Pseudo d\'affichage',
              subtitle: profilUser.userName.match(
                () => 'A renseigner',
                (userName) => userName.isEmpty ? 'A renseigner' : userName,
              ),
              onTap: () {
                final profilCubit = context.read<ProfilCubit>();
                profilCubit.clearField(
                    uid: profilUser.uid, fieldName: 'userName');
              },
            ),
            const Divider(height: 0),
            DetailItem(
              title: 'Date d\'anniversaire',
              subtitle: profilUser.birthdayDate.match(
                () => 'A renseigner',
                (date) => DateFormat('dd/MM/yyyy').format(date),
              ),
              onTap: () {
                final profilCubit = context.read<ProfilCubit>();
                profilCubit.clearField(
                    uid: profilUser.uid, fieldName: 'birthdayDate');
              },
            ),
            const Divider(height: 0),
            DetailItem(
              title: 'Bio',
              subtitle: profilUser.bio.match(
                () => 'A renseigner',
                (bio) => bio.isEmpty ? 'A renseigner' : bio,
              ),
              onTap: () {
                final profilCubit = context.read<ProfilCubit>();
                profilCubit.clearField(
                    uid: profilUser.uid, fieldName: 'bio');
              },
            ),
            const Divider(height: 0),
            DetailItem(
              title: 'Localisation',
              subtitle: profilUser.localisation.isEmpty
                  ? 'A renseigner'
                  : '${profilUser.localisation} ${(profilUser.zipCode)} - ${profilUser.country}',
              onTap: () {
                context.read<ProfilCubit>().clearLocation(profilUser.uid);
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
                        builder: (contextRoute) => BlocProvider.value(
                          value: profilCubit,
                          child: DetailWizardPage(
                            profilUser: profilUser,
                          ),
                        ),
                      ),
                    );
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

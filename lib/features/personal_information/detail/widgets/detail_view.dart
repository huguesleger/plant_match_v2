import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/personal_information/detail/detail_item.dart';
import 'package:plant_match_v2/features/personal_information/detail/open_detail_wizard.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/wizard_step.dart';
import 'package:plant_match_v2/features/personal_information/detail/widgets/detail_edit_button.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitlePage(
          title: t.personalInformation.detail.title,
          fontSize: AppTypo.textXl,
        ),
        DetailItem(
          title: t.personalInformation.detail.pseudo,
          onEdit: Some(() => _edit(context, const WizardStepPseudo())),
          subtitle: profilUser.userName.match(
            () => t.personalInformation.detail.empty_field,
            (userName) => userName.isEmpty ? t.personalInformation.detail.empty_field : userName,
          ),
          onTap: profilUser.userName
              .filter((name) => name.isNotEmpty)
              .map<VoidCallback>((_) => () => context
                  .read<ProfilCubit>()
                  .clearField(uid: profilUser.uid, fieldName: 'userName'))
        ),
        const Divider(height: 0),
        DetailItem(
          title: t.personalInformation.detail.birthday,
          onEdit: Some(() => _edit(context, const WizardStepBirthday())),
          subtitle: profilUser.birthdayDate.match(
            () => t.personalInformation.detail.empty_field,
            (date) => DateFormat('dd/MM/yyyy').format(date),
          ),
          onTap: profilUser.birthdayDate
              .map<VoidCallback>((_) => () => context
                  .read<ProfilCubit>()
                  .clearField(uid: profilUser.uid, fieldName: 'birthdayDate'))
        ),
        const Divider(height: 0),
        DetailItem(
          title: t.personalInformation.detail.bio,
          onEdit: Some(() => _edit(context, const WizardStepBio())),
          subtitle: profilUser.bio.match(
            () => t.personalInformation.detail.empty_field,
            (bio) => bio.isEmpty ? t.personalInformation.detail.empty_field : bio,
          ),
          onTap: profilUser.bio
              .filter((bio) => bio.isNotEmpty)
              .map<VoidCallback>((_) => () => context
                  .read<ProfilCubit>()
                  .clearField(uid: profilUser.uid, fieldName: 'bio'))
        ),
        const Divider(height: 0),
        DetailItem(
          title: t.personalInformation.detail.location,
          onEdit: Some(() => _edit(context, const WizardStepLocation())),
          subtitle: profilUser.localisation.isEmpty
              ? t.personalInformation.detail.empty_field
              : '${profilUser.localisation} ${(profilUser.zipCode)} - ${profilUser.country}',
          onTap: Option<VoidCallback>.fromPredicate(
            () => context.read<ProfilCubit>().clearLocation(profilUser.uid),
            (_) => profilUser.localisation.isNotEmpty,
          ),
        ),
        const Divider(height: 0),
        const SizedBox(height: 30),
        DetailEditButton(profilUser: profilUser),
      ],
    );
  }

  void _edit(BuildContext context, WizardStep step) =>
      openDetailWizard(context, profilUser: profilUser, step: Some(step));
}

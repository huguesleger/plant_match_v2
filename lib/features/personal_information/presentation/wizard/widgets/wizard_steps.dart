import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/wizard_item.dart';

class WizardPseudoStep extends StatelessWidget {
  const WizardPseudoStep({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DetailWizardItem(
      formKey: formKey,
      title: 'Pseudo d\'affichage',
      description: 'Choisissez votre pseudo qui sera visible par les autres utilisateurs.',
      child: FormBuilderTextField(
        name: 'userName',
        decoration: DecorationInput.inputDecoration(
          hintText: 'Entrez votre pseudo',
          labelText: 'Pseudo',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
      ),
    );
  }
}

class WizardBirthdayStep extends StatelessWidget {
  const WizardBirthdayStep({
    super.key,
    required this.formKey,
    required this.controller,
    required this.profilUser,
  });

  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return DetailWizardItem(
      formKey: formKey,
      title: 'Date d\'anniversaire',
      description: 'Renseignez votre date de naissance pour recevoir des points le jour de votre anniversaire.',
      child: FormBuilderDateTimePicker(
        name: 'dateOfBirth',
        inputType: InputType.date,
        initialDate: controller.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(controller.text)
            : profilUser.birthdayDate.toNullable(),
        initialValue: controller.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(controller.text)
            : profilUser.birthdayDate.toNullable(),
        format: DateFormat('dd/MM/yyyy'),
        lastDate: DateTime.now(),
        decoration: DecorationInput.inputDecoration(
          hintText: 'Entrez votre date de naissance',
          labelText: 'Date de naissance',
          suffixIcon: const Icon(LucideIcons.calendar),
        ),
        locale: const Locale('fr', 'FR'),
        controller: controller,
        validator: FormBuilderValidators.required(errorText: 'Ce champ est requis'),
      ),
    );
  }
}

class WizardBioStep extends StatelessWidget {
  const WizardBioStep({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DetailWizardItem(
      title: 'Bio',
      description: 'Rédigez une courte description de vous.',
      formKey: formKey,
      child: FormBuilderTextField(
        name: 'bio',
        decoration: DecorationInput.inputDecoration(
          hintText: 'Ajoutez une description',
          labelText: 'Bio',
          alignLabelWithHint: true,
        ),
        minLines: 3,
        maxLines: 5,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        maxLength: 150,
      ),
    );
  }
}

class WizardLocationStep extends StatelessWidget {
  const WizardLocationStep({
    super.key,
    required this.formKey,
    required this.profilUser,
  });

  final GlobalKey<FormBuilderState> formKey;
  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return DetailWizardItem(
      title: 'Localisation',
      description: 'Votre position sera utilisée pour vous proposer des profils proches de chez vous.',
      formKey: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height > 700 ? 45 : 25),
          Center(
            child: profilUser.localisation.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height > 700 ? 300 : 200,
                    child: Assets.res.images.illuLocation.image(),
                  )
                : Row(
                    children: [
                      Container(
                        width: 53,
                        height: 53,
                        decoration: BoxDecoration(
                          color: AppColors.greenLight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.map_pin,
                            color: AppColors.blueGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '${profilUser.localisation} ${profilUser.zipCode} - ${profilUser.country}',
                          style: const TextStyle(
                            fontSize: AppTypo.text,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

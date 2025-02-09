import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/presentation/profil_personal_detail_wizard/profil_personal_detail_wizard_item.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/widget/profil_personal_detail_location.dart';

class ProfilPersonalDetailWizardPage extends StatefulWidget {
  const ProfilPersonalDetailWizardPage({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  State<ProfilPersonalDetailWizardPage> createState() =>
      _ProfilPersonalDetailWizardPageState();
}

class _ProfilPersonalDetailWizardPageState
    extends State<ProfilPersonalDetailWizardPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _birthdayDateController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final _formKeyPseudo = GlobalKey<FormBuilderState>();
  final _formKeyBirthdayDate = GlobalKey<FormBuilderState>();
  final _formKeyBio = GlobalKey<FormBuilderState>();
  final _formKeyCity = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _pseudoController.text = widget.profilUser.userName;
    _birthdayDateController.text = widget.profilUser.birthdayDate != null
        ? DateFormat('dd/MM/yyyy').format(widget.profilUser.birthdayDate!)
        : '';
    _bioController.text = widget.profilUser.bio ?? '';
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _birthdayDateController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onPressed({
    required GlobalKey<FormBuilderState> formKey,
    required TextEditingController controller,
    required Function(String) updateUserField,
  }) {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final String value = controller.text;
      updateUserField(value);

      if (_currentPage < _totalPages - 1) {
        _onPressedNext();
      }
    }
  }

  Future<void> _onPressedLocation() async {
    currentPosition = await getCurrentLocation();
    await getCurrentAddress();
    setState(() {
      context.read<ProfilCubit>().saveProfilUser(
            widget.profilUser.copyWith(
              newUserName: _pseudoController.text,
              newBirthdayDate:
                  DateFormat('dd/MM/yyyy').parse(_birthdayDateController.text),
              newBio: _bioController.text,
              newLocalisation: currentAddress,
              newCountry: currentCountry,
              newLatitude: currentLatitude,
              newLongitude: currentLongitude,
              newPosition: GeoPoint(currentLatitude, currentLongitude),
            ),
          );
    });
  }

  Future<void> _handlePageAction(int currentPage) async {
    switch (currentPage) {
      case 0:
        _onPressed(
          formKey: _formKeyPseudo,
          controller: _pseudoController,
          updateUserField: (value) {
            context.read<ProfilCubit>().saveProfilUser(
                  widget.profilUser.copyWith(newUserName: value),
                );
          },
        );
        break;
      case 1:
        _onPressed(
          formKey: _formKeyBirthdayDate,
          controller: _birthdayDateController,
          updateUserField: (value) {
            context.read<ProfilCubit>().saveProfilUser(
                  widget.profilUser.copyWith(
                    newUserName: _pseudoController.text,
                    newBirthdayDate: DateFormat('dd/MM/yyyy').parse(value),
                  ),
                );
          },
        );
        break;
      case 2:
        _onPressed(
          formKey: _formKeyBio,
          controller: _bioController,
          updateUserField: (value) {
            context.read<ProfilCubit>().saveProfilUser(
                  widget.profilUser.copyWith(
                    newUserName: _pseudoController.text,
                    newBirthdayDate: DateFormat('dd/MM/yyyy')
                        .parse(_birthdayDateController.text),
                    newBio: value,
                  ),
                );
          },
        );
        break;
      default:
        break;
    }
  }

  void _onPressedNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _onPressedBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Informations personnelles',
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyLight),
        ),
        leading: _currentPage == 0 ? false : true,
        onPressed: () {
          _onPressedBack();
        },
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(LucideIcons.x),
            color: AppColors.greyDark,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Progress Indicator
            _ProgressWizard(currentPage: _currentPage, totalPages: _totalPages),
            // PageView
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                ProfilPersonalDetailWizardItem(
                  formKey: _formKeyPseudo,
                  title: 'Pseudo d\'affichage',
                  description:
                      'Choisissez votre pseudo qui sera visible par les autres utilisateurs.',
                  child: FormBuilderTextField(
                    name: 'userName',
                    decoration: DecorationInput.inputDecoration(
                      hintText: 'Entrez votre pseudo',
                      labelText: 'Pseudo',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _pseudoController,
                  ),
                ),
                ProfilPersonalDetailWizardItem(
                  formKey: _formKeyBirthdayDate,
                  title: 'Date d\'anniversaire',
                  description:
                      'Renseignez votre date de naissance pour recevoir des points le jour de votre anniversaire.',
                  child: FormBuilderDateTimePicker(
                    name: 'dateOfBirth',
                    inputType: InputType.date,
                    initialDate: _birthdayDateController.text.isNotEmpty
                        ? DateFormat('dd/MM/yyyy')
                            .parse(_birthdayDateController.text)
                        : widget.profilUser.birthdayDate,
                    initialValue: _birthdayDateController.text.isNotEmpty
                        ? DateFormat('dd/MM/yyyy')
                            .parse(_birthdayDateController.text)
                        : null,
                    format: DateFormat('dd/MM/yyyy'),
                    lastDate: DateTime.now(),
                    decoration: DecorationInput.inputDecoration(
                      hintText: 'Entrez votre date de naissance',
                      labelText: 'Date de naissance',
                      suffixIcon: const Icon(LucideIcons.calendar),
                    ),
                    locale: const Locale('fr', 'FR'),
                    controller: _birthdayDateController,
                  ),
                ),
                ProfilPersonalDetailWizardItem(
                  title: 'Bio',
                  description: 'Rédigez une courte description de vous.',
                  formKey: _formKeyBio,
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
                    controller: _bioController,
                  ),
                ),
                ProfilPersonalDetailWizardItem(
                  title: 'Localisation',
                  description:
                      'Votre position sera utilisée pour vous proposer des profils proches de chez vous.',
                  formKey: _formKeyCity,
                  child: Column(
                    children: [
                      const Text('Localisation'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Localisation coordonnées'),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(widget.profilUser.localisation),
                      Text(widget.profilUser.country),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        child: ButtonRounded(
          text: _currentPage == _totalPages - 1 ? 'Me géolocaliser' : 'Suivant',
          onPressed: () async {
            if (_currentPage == _totalPages - 1) {
              await _onPressedLocation();
            } else {
              await _handlePageAction(_currentPage);
            }
          },
          bgColor: AppColors.greenLight,
          textColor: AppColors.blueGreen,
        ),
      ),
    );
  }
}

class _ProgressWizard extends StatelessWidget {
  const _ProgressWizard({
    required int currentPage,
    required int totalPages,
  })  : _currentPage = currentPage,
        _totalPages = totalPages;

  final int _currentPage;
  final int _totalPages;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: (_currentPage + 1) / _totalPages,
        end: (_currentPage + 1) / _totalPages,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: AppColors.greyLight,
          color: AppColors.greenLight,
          minHeight: 2,
        );
      },
    );
  }
}

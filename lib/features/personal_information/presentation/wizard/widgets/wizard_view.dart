import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/widgets/wizard_progress_indicator.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/widgets/wizard_steps.dart';

class WizardView extends StatefulWidget {
  const WizardView({
    super.key,
    required this.profilUser,
    required this.onLocatingChanged,
  });

  final ProfilUser profilUser;
  final ValueChanged<bool> onLocatingChanged;

  @override
  State<WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<WizardView> {
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
    _pseudoController.text = widget.profilUser.userName.getOrElse(() => '');
    _birthdayDateController.text = widget.profilUser.birthdayDate.match(
      () => '',
      (date) => DateFormat('dd/MM/yyyy').format(date),
    );
    _bioController.text = widget.profilUser.bio.getOrElse(() => '');
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _birthdayDateController.dispose();
    _bioController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final formKeys = [
      _formKeyPseudo,
      _formKeyBirthdayDate,
      _formKeyBio,
    ];

    if (_currentPage < formKeys.length) {
      if (formKeys[_currentPage].currentState?.saveAndValidate() ?? false) {
        final updatedUser = widget.profilUser.copyWith(
          newUserName: Option.fromPredicate(
              _pseudoController.text.trim(), (String v) => v.isNotEmpty),
          newBirthdayDate: _birthdayDateController.text.isNotEmpty
              ? Some(
                  DateFormat('dd/MM/yyyy').parse(_birthdayDateController.text))
              : const None(),
          newBio: Option.fromPredicate(
              _bioController.text.trim(), (String v) => v.isNotEmpty),
        );

        context.read<ProfilCubit>().saveProfilUser(updatedUser);

        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    }
  }

  void _onPressedBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _onPressedLocation() {
    widget.onLocatingChanged(true);
    context.read<ProfilCubit>().updateLocation(widget.profilUser.uid);
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
        centerTitle: true,
        leading: _currentPage != 0,
        onPressed: _onPressedBack,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x),
            color: AppColors.greyDark,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WizardProgressIndicator(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                WizardPseudoStep(
                  formKey: _formKeyPseudo,
                  controller: _pseudoController,
                ),
                WizardBirthdayStep(
                  formKey: _formKeyBirthdayDate,
                  controller: _birthdayDateController,
                  profilUser: widget.profilUser,
                ),
                WizardBioStep(
                  formKey: _formKeyBio,
                  controller: _bioController,
                ),
                WizardLocationStep(
                  formKey: _formKeyCity,
                  profilUser: widget.profilUser,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        child: ButtonRounded(
          text: _currentPage == _totalPages - 1 ? 'Me géolocaliser' : 'Suivant',
          onPressed: () => _currentPage == _totalPages - 1
              ? _onPressedLocation()
              : _onNextPressed(),
          bgColor: AppColors.greenLight,
          textColor: AppColors.blueGreen,
        ),
      ),
    );
  }
}

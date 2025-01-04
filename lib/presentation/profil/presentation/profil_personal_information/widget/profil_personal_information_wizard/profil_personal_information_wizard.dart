import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/widget/profil_personal_information_wizard/profil_personal_information_wizard_item.dart';

class ProfilPersonalInformationWizard extends StatefulWidget {
  const ProfilPersonalInformationWizard({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  State<ProfilPersonalInformationWizard> createState() =>
      _ProfilPersonalInformationWizardState();
}

class _ProfilPersonalInformationWizardState
    extends State<ProfilPersonalInformationWizard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _birthdayDateController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final _formKeyPseudo = GlobalKey<FormBuilderState>();
  final _formKeyBirthdayDate = GlobalKey<FormBuilderState>();
  final _formKeyBio = GlobalKey<FormBuilderState>();
  final _formKeyCity = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _pseudoController.text = widget.profilUser.userName;
    _birthdayDateController.text =
        widget.profilUser.birthdayDate.toString().isNotEmpty
            ? DateFormat('dd/MM/yyyy').format(widget.profilUser.birthdayDate)
            : '';
    _bioController.text = widget.profilUser.bio;
    _cityController.text = widget.profilUser.localisation;
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _birthdayDateController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _onPressed({
    required GlobalKey<FormBuilderState> formKey,
    required TextEditingController controller,
    required Function(String) updateUserField,
  }) {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final String value = controller.text;

      if (value.isNotEmpty || _pseudoController.text.isEmpty) {
        updateUserField(value);
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

  Position? currentPosition;
  late bool servicePermission;
  late LocationPermission permission;

  String currentAddress = '';
  String currentCountry = '';

  Future<Position> getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      throw Exception('Service de localisation désactivé');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low, distanceFilter: 10),
        );
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  getCurrentAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);

      Placemark place = p[0];
      setState(() {
        currentAddress = "${place.locality}";
        currentCountry = "${place.country}";
      });
    } catch (e) {
      throw Exception('Erreur de localisation');
    }
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
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Progress Indicator
            TweenAnimationBuilder<double>(
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
            ),
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
                ProfilPersonalInformationWizardItem(
                  formKey: _formKeyPseudo,
                  title: 'Pseudo d\'affichage',
                  description:
                      'Choisissez votre pseudo qui sera visible par les autres utilisateurs.',
                  onPressed: () {
                    _onPressed(
                      formKey: _formKeyPseudo,
                      controller: _pseudoController,
                      updateUserField: (value) {
                        context.read<ProfilCubit>().saveProfilUser(
                              widget.profilUser.copyWith(newUserName: value),
                            );
                      },
                    );
                  },
                  onPressedBack: _onPressedBack,
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
                ProfilPersonalInformationWizardItem(
                  formKey: _formKeyBirthdayDate,
                  title: 'Date d\'anniversaire',
                  description:
                      'Renseignez votre date de naissance pour recevoir des points le jour de votre anniversaire.',
                  onPressed: () {
                    _onPressed(
                      formKey: _formKeyBirthdayDate,
                      controller: _birthdayDateController,
                      updateUserField: (value) {
                        context.read<ProfilCubit>().saveProfilUser(
                              widget.profilUser.copyWith(
                                  newBirthdayDate:
                                      DateFormat('dd/MM/yyyy').parse(value)),
                            );
                      },
                    );
                  },
                  onPressedBack: _onPressedBack,
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
                        : widget.profilUser.birthdayDate,
                    format: DateFormat('dd/MM/yyyy'),
                    //initialEntryMode: DatePickerEntryMode.inputOnly,
                    lastDate: DateTime.now(),
                    decoration: DecorationInput.inputDecoration(
                      hintText: 'Entrez votre date de naissance',
                      labelText: 'Date de naissance',
                      suffixIcon: const Icon(LucideIcons.calendar),
                    ),

                    locale: const Locale('fr', 'FR'),
                    validator: FormBuilderValidators.required(
                        errorText: 'Ce champ est requis'),
                    controller: _birthdayDateController,
                  ),
                ),
                ProfilPersonalInformationWizardItem(
                  title: 'Bio',
                  description: 'Rédigez une courte description de vous.',
                  formKey: _formKeyBio,
                  onPressed: () {
                    _onPressed(
                      formKey: _formKeyBio,
                      controller: _bioController,
                      updateUserField: (value) {
                        context.read<ProfilCubit>().saveProfilUser(
                              widget.profilUser.copyWith(newBio: value),
                            );
                      },
                    );
                  },
                  onPressedBack: _onPressedBack,
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
                ProfilPersonalInformationWizardItem(
                  title: 'Localisation',
                  description:
                      'Votre position sera utilisée pour vous proposer des profils proches de chez vous.',
                  labelButton: 'Me géolocaliser',
                  formKey: _formKeyCity,
                  onPressed: () async {
                    currentPosition = await getCurrentLocation();
                    await getCurrentAddress();
                    setState(() {
                      context.read<ProfilCubit>().saveProfilUser(
                            widget.profilUser.copyWith(
                                newLocalisation: currentAddress,
                                newCountry: currentCountry),
                          );
                    });
                  },
                  onPressedBack: _onPressedBack,
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
    );
  }
}

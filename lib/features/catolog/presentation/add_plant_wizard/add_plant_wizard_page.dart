import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/dialog/dialog_with_image.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/core/widgets/title_with_icon/title_with_icon.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/presentation/add_plant_wizard/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catolog/presentation/util/string_to_enum.dart';
import 'package:plant_match_v2/features/catolog/widget/catalog_upload_image.dart';
import 'package:plant_match_v2/features/catolog/widget/grid_selectable_item.dart';
import 'package:plant_match_v2/features/catolog/widget/item_radio.dart';
import 'package:plant_match_v2/features/catolog/widget/selectable_item.dart';

class AddPlantWizardPage extends StatefulWidget {
  const AddPlantWizardPage({
    super.key,
    required this.catalog,
  });

  final Catalog catalog;

  @override
  State<AddPlantWizardPage> createState() => _AddPlantWizardPageState();
}

class _AddPlantWizardPageState extends State<AddPlantWizardPage> {
  int _currentPage = 0;
  final int _totalPages = 10;
  final PageController _pageController = PageController();
  final int _maxChar = 150;
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantCategoryController =
      TextEditingController();
  final TextEditingController _plantFamilyController = TextEditingController();
  final TextEditingController _plantMaintenanceController =
      TextEditingController();
  final TextEditingController _plantWateringController =
      TextEditingController();
  final TextEditingController _plantLightingController =
      TextEditingController();
  final TextEditingController _plantDescriptionController =
      TextEditingController();

  final TextEditingController _plantOfferTypeController =
      TextEditingController();
  final TextEditingController _plantIsPublishController =
      TextEditingController();

  final _formKeyPlantName = GlobalKey<FormBuilderState>();
  final _formKeyPlantCategory = GlobalKey<FormBuilderState>();
  final _formKeyPlantFamily = GlobalKey<FormBuilderState>();
  final _formKeyPlantMaintenance = GlobalKey<FormBuilderState>();
  final _formKeyPlantWatering = GlobalKey<FormBuilderState>();
  final _formKeyPlantLighting = GlobalKey<FormBuilderState>();
  final _formKeyPlantDescription = GlobalKey<FormBuilderState>();
  final _formKeyPlantImage = GlobalKey<FormBuilderState>();
  final _formKeyPlantOfferType = GlobalKey<FormBuilderState>();
  final _formKeyPlantIsPublish = GlobalKey<FormBuilderState>();

  List<String> selectedValues = [];
  String? selectedValue;
  String? _selectedMaintenance;
  String? _selectedWatering;
  String? _selectedLighting;
  Catalog? _catalog;

  @override
  void initState() {
    super.initState();
    _plantDescriptionController.addListener(() {
      final currentText = _plantDescriptionController.text;
      if (currentText.length > _maxChar) {
        // Si dépassement, tronquer le texte
        _plantDescriptionController.text = currentText.substring(0, _maxChar);
        _plantDescriptionController.selection = TextSelection.fromPosition(
          TextPosition(offset: _maxChar),
        );
      }
    });
  }

  @override
  void dispose() {
    _plantNameController.dispose();
    _plantCategoryController.dispose();
    _plantFamilyController.dispose();
    _plantMaintenanceController.dispose();
    _plantWateringController.dispose();
    _plantLightingController.dispose();
    _plantDescriptionController.dispose();
    _pageController.dispose();
    //_plantImageController.dispose();
    _plantOfferTypeController.dispose();
    _plantIsPublishController.dispose();
    super.dispose();
  }

  void _onPressedNext() {
    _handlePageAction(_currentPage);
  }

  void _onPressedBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() => _currentPage--);
  }

  Future<void> _handlePageAction(int page) async {
    switch (page) {
      case 0:
        if (_formKeyPlantName.currentState?.saveAndValidate() ?? false) {
          final updated = (_catalog ??
              widget.catalog.copyWith(
                newName: _plantNameController.text,
              ));
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantName.currentState?.validate();
        }
        break;

      case 1:
        if (_formKeyPlantCategory.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newEnvironment:
                getEnvironmentFromString(_plantCategoryController.text),
          );
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantCategory.currentState?.validate();
        }
        break;

      case 2:
        if (_formKeyPlantFamily.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newFamily: selectedValues
                .map(getFamilyFromString)
                .whereType<Family>()
                .toList(),
          );
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantFamily.currentState?.validate();
        }
        break;

      case 3:
        if (_formKeyPlantMaintenance.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newLevelMaintenance:
                getLevelMaintenanceFromString(_plantMaintenanceController.text),
          );
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantMaintenance.currentState?.validate();
        }
        break;

      case 4:
        if (_formKeyPlantWatering.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newWatering: getWateringFromString(_plantWateringController.text),
          );
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantWatering.currentState?.validate();
        }
        break;

      case 5:
        if (_formKeyPlantLighting.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newLighting: getLightingFromString(_plantLightingController.text),
          );
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantLighting.currentState?.validate();
        }
        break;

      case 6:
        if (_formKeyPlantDescription.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newDescription: _plantDescriptionController.text,
          );
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantDescription.currentState?.validate();
        }
        break;

      case 7:
        if (_formKeyPlantImage.currentState?.saveAndValidate() ?? false) {
          _onPressedNextPage();
        }
        break;

      case 8:
        if (_formKeyPlantOfferType.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newOfferType:
                getOfferTypeFromString(_plantOfferTypeController.text),
          );
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantOfferType.currentState?.validate();
        }
        break;

      case 9:
        if (_formKeyPlantIsPublish.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newStatus: _plantIsPublishController.text == 'true'
                ? CatalogStatus.published
                : CatalogStatus.draft,
          );
          setState(() => _catalog = updated);

          // Afficher le dialog de chargement
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PopScope(
                  canPop: false,
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.greenLight,
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Création de votre plante...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greyDark,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Veuillez patienter',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.greyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          try {
            final catalogCubit = context.read<CatalogCubit>();

            if (_catalog!.catalogId == null) {
              final result = await catalogCubit.addCatalog(_catalog!).run();
              final id = result.getOrElse((_) => "");
              _catalog = _catalog!.copyWith(newCatalogId: id);
            } else {
              catalogCubit.updateCatalog(_catalog!);
            }

            final localImagePaths = _catalog!.images
                .where((img) => !img.startsWith('http'))
                .toList();
            final existingUrls = _catalog!.images
                .where((img) => img.startsWith('http'))
                .toList();
            final imagesResult = await catalogCubit.uploadCatalogImages(
              catalog: _catalog!,
              catalogId: _catalog!.catalogId!,
              imagePaths: localImagePaths,
              existingImages: existingUrls,
            ).run();

            imagesResult.match(
              (failure) => null,
              (updatedWithImages) {
                setState(() {
                  _catalog = updatedWithImages;
                });
              },
            );

            // Fermer le dialog de chargement
            if (mounted) {
              Navigator.of(context).pop(); // Ferme le dialog
              Navigator.pop(context, true); // Retour à la page précédente
            }
          } catch (e) {
            // Fermer le dialog en cas d'erreur
            if (mounted) {
              Navigator.of(context).pop(); // Ferme le dialog
              // Afficher un message d'erreur
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erreur lors de la création: $e'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        } else {
          _formKeyPlantIsPublish.currentState?.validate();
        }
        break;
    }
  }

  void _onPressedNextPage() {
    FocusScope.of(context).unfocus();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() => _currentPage++);
  }

  void onSelect(String value) {
    setState(() {
      selectedValue = value;
      _plantCategoryController.text = value;
    });
  }

  void onSelectOfferType(String value) {
    setState(() {
      _plantOfferTypeController.text = value;
    });
  }

  void onSelectMultiple(String value) {
    setState(() {
      if (selectedValues.contains(value)) {
        selectedValues.remove(value);
      } else {
        selectedValues.add(value);
      }
    });
  }

  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return const DialogWithImage(
          imagePath: 'assets/images/empty_catalog_filter.png',
          title: 'Quitter sans enregistrer ?',
          text:
              'Les informations saisies seront perdues si tu quittes maintenant.',
        );
      },
    );

    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Ajouter une plante',
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyLight),
        ),
        leading: _currentPage == 0 ? false : true,
        centerTitle: true,
        onPressed: _onPressedBack,
        actions: [
          IconButton(
            onPressed: () async {
              final shouldExit = await _showExitConfirmationDialog();
              if (shouldExit && context.mounted) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(LucideIcons.x),
            color: AppColors.greyDark,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _ProgressWizard(currentPage: _currentPage, totalPages: _totalPages),
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              children: [
                AddPlantWizardItem(
                  formKey: _formKeyPlantName,
                  title: 'Nom de la plante',
                  description: 'Entrez le nom de la plante',
                  child: FormBuilderTextField(
                    name: 'plantName',
                    decoration: DecorationInput.inputDecoration(
                      hintText: 'Nom de la plante',
                      labelText: 'Nom',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _plantNameController,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est requis'),
                    ]),
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantCategory,
                  title: 'Quel environnement ?',
                  description: 'Sélectionner une catégorie pour votre plante',
                  child: FormBuilderField(
                    name: 'category',
                    initialValue: _plantCategoryController.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est requis'),
                    ]),
                    onSaved: (value) =>
                        _plantCategoryController.text = value.toString(),
                    builder: (FormFieldState<dynamic> fieldCategory) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SelectableItem(
                                  icon: LucideIcons.house,
                                  label: "Intérieur",
                                  value: "indoor",
                                  isSelected:
                                      _plantCategoryController.text == "indoor",
                                  onTap: (value) {
                                    onSelect(value);
                                    fieldCategory.didChange(value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SelectableItem(
                                  icon: LucideIcons.trees,
                                  label: "Extérieur",
                                  value: "outdoor",
                                  isSelected: _plantCategoryController.text ==
                                      "outdoor",
                                  onTap: (value) {
                                    onSelect(value);
                                    fieldCategory.didChange(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (fieldCategory.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                fieldCategory.errorText ?? '',
                                style: const TextStyle(
                                    color: AppColors.error, fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantFamily,
                  title: 'Choisir une famille',
                  description: 'Sélectionner une ou des catégorie(s)',
                  child: FormBuilderField(
                    name: 'family',
                    initialValue: selectedValues
                        .map(getFamilyFromString)
                        .whereType<Family>()
                        .toList(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    builder: (FormFieldState<dynamic> fieldFamily) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridSelectableItem(
                              selectedValues: selectedValues,
                              onSelect: (value) {
                                onSelectMultiple(value);
                                fieldFamily.didChange(
                                  selectedValues
                                      .map(getFamilyFromString)
                                      .whereType<Family>()
                                      .toList(),
                                );
                              }),
                          if (fieldFamily.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                fieldFamily.errorText ?? '',
                                style: const TextStyle(
                                    color: AppColors.error, fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(
                            errorText: 'Ce champ est requis'),
                      ],
                    ),
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantMaintenance,
                  title: 'Entretien',
                  description: 'Sélectionner un niveau de difficulté',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleWithIcon(
                        icon: LucideIcons.shovel,
                        title: 'Niveau d\'entretien',
                        bgColor: AppColors.greenDark,
                        iconColor: AppColors.greenLight,
                      ),
                      const SizedBox(height: 20),
                      FormBuilderField(
                        name: 'maintenance',
                        initialValue: _plantMaintenanceController.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (FormFieldState<dynamic> fieldMaintenance) {
                          return Column(
                            children: [
                              ItemRadio(
                                title: 'Facile',
                                subtitle: 'Très résistante, peu d\'arrosage',
                                value: 'low',
                                selectedItem: _selectedMaintenance,
                                onItemSelected: (value) {
                                  setState(() {
                                    _selectedMaintenance = value;
                                    _plantMaintenanceController.text = value;
                                    fieldMaintenance.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Moyen',
                                subtitle: 'Quelques soins réguliers',
                                value: 'medium',
                                selectedItem: _selectedMaintenance,
                                onItemSelected: (value) {
                                  setState(() {
                                    _selectedMaintenance = value;
                                    _plantMaintenanceController.text = value;
                                    fieldMaintenance.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Difficile',
                                subtitle:
                                    'Sensible, besoin de conditions spécifiques.',
                                value: 'high',
                                selectedItem: _selectedMaintenance,
                                onItemSelected: (value) {
                                  setState(() {
                                    _selectedMaintenance = value;
                                    _plantMaintenanceController.text = value;
                                    fieldMaintenance.didChange(value);
                                  });
                                },
                              ),
                              if (fieldMaintenance.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    fieldMaintenance.errorText ?? '',
                                    style: const TextStyle(
                                        color: AppColors.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ce champ est requis'),
                        ]),
                      ),
                    ],
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantWatering,
                  title: 'Arrosage',
                  description: 'Sélectionner le besoin en eau',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleWithIcon(
                        icon: LucideIcons.droplet,
                        title: 'Besoin en eau',
                        bgColor: AppColors.greenDark,
                        iconColor: AppColors.greenLight,
                      ),
                      const SizedBox(height: 20),
                      FormBuilderField(
                        name: 'watering',
                        initialValue: _plantWateringController.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (FormFieldState<dynamic> fieldWatering) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ItemRadio(
                                title: 'Peu d\'eau',
                                value: 'little',
                                selectedItem: _selectedWatering,
                                onItemSelected: (value) {
                                  setState(() {
                                    _selectedWatering = value;
                                    _plantWateringController.text = value;
                                    fieldWatering.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Arrosage régulier',
                                value: 'regularly',
                                selectedItem: _selectedWatering,
                                onItemSelected: (value) {
                                  setState(() {
                                    _selectedWatering = value;
                                    _plantWateringController.text = value;
                                    fieldWatering.didChange(value);
                                  });
                                },
                              ),
                              if (fieldWatering.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    fieldWatering.errorText ?? '',
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ce champ est requis'),
                        ]),
                      ),
                    ],
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantLighting,
                  title: 'Lumière',
                  description: 'Sélectionner le besoin en lumière',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleWithIcon(
                        icon: LucideIcons.sun_medium,
                        title: 'Besoin en lumière',
                        bgColor: AppColors.greenDark,
                        iconColor: AppColors.greenLight,
                      ),
                      const SizedBox(height: 20),
                      FormBuilderField(
                        name: 'lighting',
                        initialValue: _plantLightingController.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (FormFieldState<dynamic> fieldLighting) {
                          return Column(
                            children: [
                              ItemRadio(
                                title: 'Soleil directe',
                                value: 'sun',
                                selectedItem: _selectedLighting,
                                onItemSelected: (value) {
                                  setState(() {
                                    _selectedLighting = value;
                                    _plantLightingController.text = value;
                                    fieldLighting.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Lumière indirecte',
                                value: 'indirectLight',
                                selectedItem: _selectedLighting,
                                onItemSelected: (value) {
                                  setState(() {
                                    _selectedLighting = value;
                                    _plantLightingController.text = value;
                                    fieldLighting.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Ombre',
                                value: 'shade',
                                selectedItem: _selectedLighting,
                                onItemSelected: (value) {
                                  setState(() {
                                    _selectedLighting = value;
                                    _plantLightingController.text = value;
                                    fieldLighting.didChange(value);
                                  });
                                },
                              ),
                              if (fieldLighting.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    fieldLighting.errorText ?? '',
                                    style: const TextStyle(
                                        color: AppColors.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ce champ est requis'),
                        ]),
                      ),
                    ],
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantDescription,
                  title: 'Description',
                  description: 'Ajouter une brève description',
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        maxLines: 4,
                        maxLength: _maxChar,
                        name: 'description',
                        decoration: DecorationInput.inputDecoration(
                          hintText: 'Description de la plante',
                          labelText: 'Description',
                          alignLabelWithHint: true,
                        ),
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: _plantDescriptionController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ce champ est requis'),
                          FormBuilderValidators.maxLength(_maxChar,
                              errorText: 'Maximum $_maxChar caractères'),
                        ]),
                      ),
                    ],
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantImage,
                  title: 'Ajouter une photo',
                  description:
                      'Sélectionner une à trois photos de votre plante',
                  child: FormBuilderField<List<String>>(
                    name: 'plantImage',
                    builder: (FormFieldState<List<String>> fieldImage) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CatalogUploadImage(
                            catalog: _catalog!,
                            field: fieldImage,
                            onCatalogUpdated: (updatedCatalog) {
                              setState(() {
                                _catalog = updatedCatalog;
                              });
                            },
                          ),
                          if (fieldImage.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                fieldImage.errorText ?? '',
                                style: const TextStyle(
                                    color: AppColors.error, fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est requis'),
                    ]),
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantOfferType,
                  title: 'Que souhaitez-vous en faire ?',
                  description: 'Sélectionner une offre pour votre plante',
                  child: FormBuilderField(
                    name: 'offerType',
                    initialValue: _plantOfferTypeController.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est requis'),
                    ]),
                    onSaved: (value) =>
                        _plantOfferTypeController.text = value.toString(),
                    builder: (FormFieldState<dynamic> fieldCategory) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SelectableItem(
                                  icon: LucideIcons.gift,
                                  label: "Donation",
                                  value: "donation",
                                  isSelected: _plantOfferTypeController.text ==
                                      "donation",
                                  onTap: (value) {
                                    onSelectOfferType(value);
                                    fieldCategory.didChange(value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SelectableItem(
                                  icon: LucideIcons.heart_handshake,
                                  label: "Echange",
                                  value: "exchange",
                                  isSelected: _plantOfferTypeController.text ==
                                      "exchange",
                                  onTap: (value) {
                                    onSelectOfferType(value);
                                    fieldCategory.didChange(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (fieldCategory.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                fieldCategory.errorText ?? '',
                                style: const TextStyle(
                                    color: AppColors.error, fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                AddPlantWizardItem(
                  formKey: _formKeyPlantIsPublish,
                  title: 'Publication',
                  description: 'Souhaitez-vous publier votre plante ?',
                  child: FormBuilderSwitch(
                    name: 'isPublish',
                    inactiveTrackColor: AppColors.white,
                    title: const Text('Publier la plante'),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    initialValue: _catalog?.status == CatalogStatus.published,
                    onChanged: (value) {
                      _plantIsPublishController.text = value.toString();
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est requis'),
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        child: ButtonRounded(
          text: _currentPage == _totalPages - 1 ? 'Enregistrer' : 'Suivant',
          onPressed: () {
            if (_currentPage == _totalPages - 1) {
              _handlePageAction(_currentPage);
            } else {
              _onPressedNext();
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
          end: (_currentPage + 1) / _totalPages),
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

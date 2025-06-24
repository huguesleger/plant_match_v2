import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/core/widgets/title_with_icon/title_with_icon.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/add_plant_wizard/add_plant_wizard_item.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/util/string_to_enum.dart';
import 'package:plant_match_v2/presentation/catolog/widget/catalog_upload_image.dart';
import 'package:plant_match_v2/presentation/catolog/widget/selectable_item.dart';

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
  final int _totalPages = 8;
  final PageController _pageController = PageController();

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
  final TextEditingController _plantImageController = TextEditingController();

  final _formKeyPlantName = GlobalKey<FormBuilderState>();
  final _formKeyPlantCategory = GlobalKey<FormBuilderState>();
  final _formKeyPlantFamily = GlobalKey<FormBuilderState>();
  final _formKeyPlantMaintenance = GlobalKey<FormBuilderState>();
  final _formKeyPlantWatering = GlobalKey<FormBuilderState>();
  final _formKeyPlantLighting = GlobalKey<FormBuilderState>();
  final _formKeyPlantDescription = GlobalKey<FormBuilderState>();

  final _formKeyPlantImage = GlobalKey<FormBuilderState>();

  List<String> selectedValues = [];
  String? selectedValue;
  String? _selectedMaintenance;
  String? _selectedWatering;
  String? _selectedLighting;
  Catalog? _catalog;

  @override
  void initState() {
    super.initState();
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
          final updated = (_catalog ?? widget.catalog).copyWith(
              newName: _plantNameController.text,
              newImages: _catalog?.images ?? []);

          if (updated.catalogId == null) {
            final id = await context.read<CatalogCubit>().addCatalog(updated);
            setState(() {
              _catalog = updated.copyWith(newCatalogId: id);
            });
          } else {
            await context.read<CatalogCubit>().updateCatalog(updated);
            setState(() {
              _catalog = updated;
            });
          }

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
            newImages: _catalog!.images,
          );

          context.read<CatalogCubit>().updateCatalog(updated);
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
            newImages: _catalog!.images,
          );
          context.read<CatalogCubit>().updateCatalog(updated);
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantFamily.currentState?.validate();
        }
        break;

      case 3:
        if (_formKeyPlantMaintenance.currentState?.saveAndValidate() ?? false) {
          final updated = _catalog!.copyWith(
            newLevelMaintenance: getLevelMaintenanceFromString(
              _plantMaintenanceController.text,
            ),
            newImages: _catalog!.images,
          );

          context.read<CatalogCubit>().updateCatalog(updated);
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
            newImages: _catalog!.images,
          );

          context.read<CatalogCubit>().updateCatalog(updated);
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
            newImages: _catalog!.images,
          );

          context.read<CatalogCubit>().updateCatalog(updated);
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
            newImages: _catalog!.images,
          );

          context.read<CatalogCubit>().updateCatalog(updated);
          setState(() => _catalog = updated);
          _onPressedNextPage();
        } else {
          _formKeyPlantDescription.currentState?.validate();
        }
        break;

      case 7:
        if (_formKeyPlantImage.currentState?.saveAndValidate() ?? false) {
          Navigator.pop(context, true);
        } else {
          _formKeyPlantImage.currentState?.validate();
        }
        break;
    }
  }

  void _onPressedNextPage() {
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

  void onSelectMultiple(String value) {
    setState(() {
      if (selectedValues.contains(value)) {
        selectedValues.remove(value);
      } else {
        selectedValues.add(value);
      }
    });
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
            onPressed: () => Navigator.pop(context),
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
                                  icon: LucideIcons.fence,
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
                        icon: LucideIcons.shield,
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
                      const TitleWithIcon(
                        icon: LucideIcons.pen,
                        title: 'Description',
                        bgColor: AppColors.greenDark,
                        iconColor: AppColors.greenLight,
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        maxLines: 4,
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
                  child: FormBuilderField<List<File>>(
                    name: 'plantImage',
                    builder: (FormFieldState<List<File>> fieldImage) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CatalogUploadImage(
                            userId: _catalog!.userId,
                            catalogId: _catalog!.catalogId!,
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

class GridSelectableItem extends StatelessWidget {
  final List<String> selectedValues;
  final Function(String) onSelect;

  const GridSelectableItem({
    super.key,
    required this.selectedValues,
    required this.onSelect,
  });

  final List<Map<String, dynamic>> items = const [
    {"label": "Tropicale", "value": "tropical", "icon": LucideIcons.tree_palm},
    {
      "label": "Succulente/Cactée",
      "value": "succulent",
      "icon": LucideIcons.clover
    },
    {"label": "Aquatique", "value": "aquatic", "icon": LucideIcons.waves},
    {"label": "Grimpante", "value": "climbing", "icon": LucideIcons.flower_2},
    {
      "label": "Bonsaï et miniature",
      "value": "bonsai",
      "icon": LucideIcons.sprout
    },
    {"label": "Fleur", "value": "flower", "icon": LucideIcons.flower},
    {"label": "Aromatique", "value": "aromatic", "icon": LucideIcons.leaf},
    {"label": "Médicinale", "value": "medical", "icon": LucideIcons.pill},
    {"label": "Carnivore", "value": "carnivorous", "icon": LucideIcons.ham},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return SelectableItem(
          icon: item["icon"] as IconData,
          label: item["label"] as String,
          value: item["value"] as String,
          isSelected: selectedValues.contains(item["value"]),
          onTap: onSelect,
        );
      },
    );
  }
}

class ItemRadio extends StatelessWidget {
  const ItemRadio({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.selectedItem,
    required this.onItemSelected,
  });

  final String title;
  final String? subtitle;
  final String value;
  final String? selectedItem;
  final Function(String) onItemSelected;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedItem == value;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.greenDark : Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        tileColor: isSelected
            ? AppColors.greenDark.withOpacity(0.1)
            : AppColors.greyUltraLight,
        title: Text(title,
            style: const TextStyle(
                color: AppColors.greyMedium, fontSize: AppTypo.textS)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: const TextStyle(fontSize: AppTypo.textXs)),
        trailing: Radio<String>(
          value: value,
          groupValue: selectedItem,
          onChanged: (String? newValue) {
            if (newValue != null) {
              onItemSelected(newValue);
            }
          },
          activeColor: AppColors.greenDark,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
    );
  }
}

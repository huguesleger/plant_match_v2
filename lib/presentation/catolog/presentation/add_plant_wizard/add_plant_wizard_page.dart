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
import 'package:plant_match_v2/presentation/catolog/widget/selectable_item.dart';

class AddPlantWizardPage extends StatefulWidget {
  const AddPlantWizardPage({
    super.key,
    required this.userId,
    required this.catalog,
  });

  final String userId;
  final Catalog catalog;

  @override
  State<AddPlantWizardPage> createState() => _AddPlantWizardPageState();
}

class _AddPlantWizardPageState extends State<AddPlantWizardPage> {
  int _currentPage = 0;
  final int _totalPages = 8;
  String? selectedValue;
  List<String> selectedValues = [];
  String? selectedItem;
  final PageController _pageController = PageController();
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantImageController = TextEditingController();
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

  //final _formKey = GlobalKey<FormBuilderState>();
  final _formKeyPlantName = GlobalKey<FormBuilderState>();
  final _formKeyPlantImage = GlobalKey<FormBuilderState>();
  final _formKeyPlantCategory = GlobalKey<FormBuilderState>();
  final _formKeyPlantFamily = GlobalKey<FormBuilderState>();
  final _formKeyPlantMaintenance = GlobalKey<FormBuilderState>();
  final _formKeyPlantWatering = GlobalKey<FormBuilderState>();
  final _formKeyPlantLighting = GlobalKey<FormBuilderState>();
  final _formKeyPlantDescription = GlobalKey<FormBuilderState>();

/*  void _onPressedNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    _formKeyPlantName.currentState?.saveAndValidate() ?? false;
  }*/
/*  void _onPressedNext() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }*/
/*  void _onPressedNext() {
    if (_formKeyPlantName.currentState?.saveAndValidate() ?? false) {
      context.read<CatalogCubit>().saveCatalog(
            widget.catalog.copyWith(
              newName: _plantNameController.text,
            ),
          );

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }*/

  void _onPressedNext() {
    // On détermine le formulaire et la validation selon la page actuelle
    switch (_currentPage) {
      case 0: // Page pour nom de la plante
        if (_formKeyPlantName.currentState?.saveAndValidate() ?? false) {
          context.read<CatalogCubit>().saveCatalog(
                widget.catalog.copyWith(
                  name: _plantNameController.text,
                ),
              );
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
        break;
/*      case 1: // Page pour image de la plante
        if (_formKeyPlantImage.currentState?.saveAndValidate() ?? false) {
          print("📸 Image avant enregistrement: ${_plantImageController.text}");

          // Récupérer les images de Firebase via le Cubit et les sauvegarder
          final catalogCubit = context.read<CatalogCubit>();
          final currentState = catalogCubit.state;

          */ /*         List<String> uploadedImages = [_plantImageController.text];

          catalogCubit.updateCatalog(
            catalogId: widget.catalog.uid,
            images: uploadedImages,
          );*/ /*
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
        break;*/
      case 1: // Page pour la catégorie de la plante
        context.read<CatalogCubit>().saveCatalog(
              widget.catalog.copyWith(
                name: _plantNameController.text,
                image: _plantImageController.text,
                environment:
                    getEnvironmentFromString(_plantCategoryController.text),
              ),
            );
/*        final updatedCatalog = widget.catalog.copyWith(
            newEnvironment:
                getEnvironmentFromString(_plantCategoryController.text));*/
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        break;
      case 2: // Page pour la famille de la plante
        context.read<CatalogCubit>().saveCatalog(
              widget.catalog.copyWith(
                name: _plantNameController.text,
                image: _plantImageController.text,
                environment:
                    getEnvironmentFromString(_plantCategoryController.text),
                family: getFamilyFromString(_plantFamilyController.text),
              ),
            );
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        break;
/*      case 4:
        context.read<CatalogCubit>().saveCatalog(
              widget.catalog.copyWith(
                newLevelMaintenance: getLevelMaintenanceFromString(
                    _plantMaintenanceController.text),
              ),
            );
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        break;*/
/*      case 5:
        context.read<CatalogCubit>().saveCatalog(
              widget.catalog.copyWith(
                newWatering:
                    getWateringFromString(_plantWateringController.text),
              ),
            );
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        break;*/
/*      case 6:
        context.read<CatalogCubit>().saveCatalog(
              widget.catalog.copyWith(
                newLighting: getLightingFromString(
                  _plantLightingController.text,
                ),
              ),
            );
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        break;*/
/*      case 7:
        print('toto');
        context.read<CatalogCubit>().saveCatalog(
              widget.catalog.copyWith(
                newName: _plantNameController.value.text,
                newDescription: _plantDescriptionController.text,
              ),
            );
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        break;*/
      default:
        break;
    }
  }

  void _onPressedBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _onPressed({
    required GlobalKey<FormBuilderState> formKey,
    required TextEditingController controller,
    required Function(String) updateCatalogField,
  }) {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final String value = controller.text;
      updateCatalogField(value);
      print('value');

      if (_currentPage < _totalPages - 1) {
        _onPressedNext();
        print('ggg');
      }
    }
  }

/*  Future<void> _handleCatalogPageAction(int currentPage) async {
    switch (currentPage) {
      case 0: // Page for plant name
        _onPressed(
          formKey: _formKeyPlantName,
          controller: _plantNameController,
          updateCatalogField: (value) {
            context.read<CatalogCubit>().saveCatalog(
                  widget.catalog.copyWith(
                    newName: value,
                  ),
                );
          },
        );
        break;
      default:
        break;
    }
  }*/

  void onSelect(String value) {
    setState(() {
      selectedValue = value;
      print(selectedValue);
      _plantCategoryController.text = value;
      print(_plantCategoryController.text);
    });
  }

  void onSelectMultiple(String value) {
    setState(() {
      if (selectedValues.contains(value)) {
        selectedValues.remove(value);
        print(selectedValues);
      } else {
        selectedValues.add(value);
        print(selectedValues);
      }
    });
  }

  void _onItemSelected(String? value) {
    setState(() {
      selectedItem = value;
      print(selectedItem);
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
            _ProgressWizard(currentPage: _currentPage, totalPages: _totalPages),
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
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
                /*AddPlantWizardItem(
                  formKey: _formKeyPlantImage,
                  title: 'Ajouter une photo',
                  description:
                      'Sélectionner ou ajouter une photo de votre plante',
                  child: FormBuilderField<List<File>>(
                    name: 'plantImage',
                    builder: (FormFieldState<List<File>> field) {
                      return Expanded(
                        child: CatalogUploadImage(
                          userId: widget.userId,
                          catalogId: widget.userId,
                          field: field,
                        ),
                      );
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est requis'),
                    ]),
                  ),
                ),*/
                AddPlantWizardItem(
                  title: 'Quel environnement ?',
                  description: 'Sélectionner une catégorie pour votre plante',
                  child: FormBuilderField(
                    name: 'category',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Ce champ est requis'),
                    ]),
                    onSaved: (value) {
                      _plantCategoryController.text = value.toString();
                      print(_plantCategoryController.text);
                    },
                    builder: (FormFieldState<dynamic> field) {
                      return Row(
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
                                field.didChange(value);
                                print(_plantCategoryController.text);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SelectableItem(
                              icon: LucideIcons.fence,
                              label: "Extérieur",
                              value: "outdoor",
                              isSelected:
                                  _plantCategoryController.text == "outdoor",
                              onTap: (value) {
                                onSelect(value);
                                field.didChange(value);
                                print(_plantCategoryController.text);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                AddPlantWizardItem(
                  title: 'Choisir une famille',
                  description: 'Sélectionner une ou des catégorie(s)',
                  child: FormBuilderField(
                    name: 'family',
                    builder: (FormFieldState<dynamic> field) {
                      return GridSelectableItem(
                        selectedValues: selectedValues,
                        onSelect: onSelectMultiple,
                      );
                    },
                  ),
                ),
                AddPlantWizardItem(
                  title: 'Entretien',
                  description: 'Sélectionner un niveau de difficulté',
                  child: Column(
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
                        builder: (FormFieldState<dynamic> field) {
                          return Column(
                            children: [
                              ItemRadio(
                                title: 'Facile',
                                subtitle: 'Très résistante, peu d\'arrosage',
                                value: 'low',
                                onItemSelected: _onItemSelected,
                                selectedItem: selectedItem,
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Moyen',
                                subtitle: 'Quelques soins réguliers',
                                value: 'medium',
                                onItemSelected: _onItemSelected,
                                selectedItem: selectedItem,
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Difficile',
                                subtitle:
                                    'Sensible, besoin de conditions spécifiques.',
                                value: 'high',
                                onItemSelected: _onItemSelected,
                                selectedItem: selectedItem,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AddPlantWizardItem(
                  title: 'Arrosage',
                  description: 'Sélectionner le besoin en eau',
                  child: Column(
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
                        builder: (FormFieldState<dynamic> field) {
                          return Column(
                            children: [
                              ItemRadio(
                                title: 'Peu d\'eau',
                                value: 'little',
                                onItemSelected: _onItemSelected,
                                selectedItem: selectedItem,
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Arrosage régulier',
                                value: 'regularly',
                                onItemSelected: _onItemSelected,
                                selectedItem: selectedItem,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AddPlantWizardItem(
                  title: 'Lumière',
                  description: 'Sélectionner le besoin en lumière',
                  child: Column(
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
                        builder: (FormFieldState<dynamic> field) {
                          return Column(
                            children: [
                              ItemRadio(
                                title: 'Soleil direct',
                                value: 'sun',
                                onItemSelected: _onItemSelected,
                                selectedItem: selectedItem,
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Lumière indirecte',
                                value: 'indirectLight',
                                onItemSelected: _onItemSelected,
                                selectedItem: selectedItem,
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Ombre',
                                value: 'shade',
                                onItemSelected: _onItemSelected,
                                selectedItem: selectedItem,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AddPlantWizardItem(
                  title: 'Description',
                  description: 'Note personnelle ou détails spécifiques',
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'Description',
                        decoration: DecorationInput.inputDecoration(
                          hintText: 'Ajoutez une description',
                          labelText: 'Description',
                          alignLabelWithHint: true,
                        ),
                        minLines: 3,
                        maxLines: 5,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        child: ButtonRounded(
          text: _currentPage == _totalPages - 1 ? 'Enregistrer' : 'Suivant',
          onPressed: () {
            _onPressedNext();
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

class GridSelectableItem extends StatelessWidget {
  final List<String> selectedValues;
  final Function(String) onSelect;

  GridSelectableItem({
    super.key,
    required this.selectedValues,
    required this.onSelect,
  });

  final List<Map<String, dynamic>> items = [
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
  final Function(String?) onItemSelected;

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
            ? AppColors.greenDark.withValues(alpha: 0.1)
            : AppColors.greyUltraLight,
        title: Text(
          title,
          style: const TextStyle(
              color: AppColors.greyMedium, fontSize: AppTypo.textS),
        ),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: const TextStyle(fontSize: AppTypo.textXs)),
        trailing: Radio<String>(
          value: value,
          groupValue: selectedItem,
          onChanged: (String? newValue) {
            onItemSelected(newValue);
          },
          activeColor: AppColors.greenDark,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}

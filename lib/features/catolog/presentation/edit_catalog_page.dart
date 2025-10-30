import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catolog/presentation/util/string_to_enum.dart';
import 'package:plant_match_v2/features/catolog/widget/catalog_upload_image.dart';
import 'package:plant_match_v2/features/catolog/widget/grid_selectable_item.dart';
import 'package:plant_match_v2/features/catolog/widget/item_radio.dart';
import 'package:plant_match_v2/features/catolog/widget/selectable_item.dart';

class EditCatalogPage extends StatefulWidget {
  final Catalog catalog;

  const EditCatalogPage({super.key, required this.catalog});

  @override
  State<EditCatalogPage> createState() => _EditCatalogPageState();
}

class _EditCatalogPageState extends State<EditCatalogPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKeyPlantName = GlobalKey<FormBuilderState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  String? _environment;
  List<String> _selectedFamilies = [];
  String? _maintenance;
  String? _watering;
  String? _lighting;
  late List<String> _updatedImages;
  bool? _isPublish;

  bool _isSaving = false;

  final int _maxChar = 150;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.catalog.name);
    _descriptionController =
        TextEditingController(text: widget.catalog.description);

    _environment = widget.catalog.environment.name;
    _selectedFamilies = widget.catalog.family.map((f) => f.name).toList();
    _maintenance = widget.catalog.levelMaintenance.name;
    _watering = widget.catalog.watering.name;
    _lighting = widget.catalog.lighting.name;
    _updatedImages = List.from(widget.catalog.images);
    _isPublish = widget.catalog.isPublish;
  }

  void _save() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      final catalogCubit = context.read<CatalogCubit>();
      final catalog = widget.catalog;
      final localImages =
          _updatedImages.where((img) => !img.startsWith('http')).toList();
      final existingImages =
          _updatedImages.where((img) => img.startsWith('http')).toList();

      Catalog updatedCatalog = catalog;

      if (localImages.isNotEmpty) {
        final result = await catalogCubit.uploadCatalogImages(
          catalog: catalog,
          imagePaths: localImages,
          catalogId: catalog.catalogId ?? '',
          existingImages: existingImages,
        );

        if (result == null) {
          setState(() {
            _isSaving = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Erreur lors de l’upload des images"),
              ),
            );
          }
          return;
        }

        updatedCatalog = result;
      } else {
        updatedCatalog = catalog.copyWith(newImages: _updatedImages);
      }

      final fullyUpdated = updatedCatalog.copyWith(
        newCatalogId: catalog.catalogId,
        newName: _nameController.text,
        newDescription: _descriptionController.text,
        newEnvironment: getEnvironmentFromString(_environment ?? 'indoor'),
        newFamily: _selectedFamilies
            .map(getFamilyFromString)
            .whereType<Family>()
            .toList(),
        newLevelMaintenance:
            getLevelMaintenanceFromString(_maintenance ?? 'low'),
        newWatering: getWateringFromString(_watering ?? 'little'),
        newLighting: getLightingFromString(_lighting ?? 'sun'),
        newIsPublish: _isPublish ?? false,
      );

      await catalogCubit.updateCatalog(fullyUpdated);

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        Navigator.pop(context, true);
      }
    }
  }

  void onSelectMultiple(String value) {
    setState(() {
      if (_selectedFamilies.contains(value)) {
        _selectedFamilies.remove(value);
      } else {
        _selectedFamilies.add(value);
      }
    });
  }

  void onSelect(String value) {
    setState(() {
      _environment = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Modifier ${widget.catalog.name}',
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.greyLight,
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
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBuilderTextField(
                        key: _formKeyPlantName,
                        name: 'plantName',
                        controller: _nameController,
                        decoration: DecorationInput.inputDecoration(
                          hintText: 'Nom de la plante',
                          labelText: 'Nom',
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                            'Sélectionner une catégorie pour votre plante'),
                      ),
                      FormBuilderField(
                        name: 'category',
                        initialValue: _environment,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ce champ est requis'),
                        ]),
                        onSaved: (val) => setState(() => _environment = val),
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
                                      isSelected: _environment == "indoor",
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
                                      isSelected: _environment == "outdoor",
                                      onTap: (value) {
                                        onSelect(value);
                                        fieldCategory.didChange(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Sélectionner une ou des catégorie(s)'),
                      ),
                      FormBuilderField(
                        name: 'family',
                        initialValue: _selectedFamilies
                            .map(getFamilyFromString)
                            .whereType<Family>()
                            .toList(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (FormFieldState<dynamic> fieldFamily) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridSelectableItem(
                                  selectedValues: _selectedFamilies,
                                  onSelect: (value) {
                                    onSelectMultiple(value);
                                    fieldFamily.didChange(
                                      _selectedFamilies
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
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Sélectionner un niveau de difficulté'),
                      ),
                      FormBuilderField(
                        name: 'maintenance',
                        initialValue: _maintenance,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (FormFieldState<dynamic> fieldMaintenance) {
                          return Column(
                            children: [
                              ItemRadio(
                                title: 'Facile',
                                subtitle: 'Très résistante, peu d\'arrosage',
                                value: 'low',
                                selectedItem: _maintenance,
                                onItemSelected: (value) {
                                  setState(() {
                                    _maintenance = value;
                                    fieldMaintenance.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Moyen',
                                subtitle: 'Quelques soins réguliers',
                                value: 'medium',
                                selectedItem: _maintenance,
                                onItemSelected: (value) {
                                  setState(() {
                                    _maintenance = value;
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
                                selectedItem: _maintenance,
                                onItemSelected: (value) {
                                  setState(() {
                                    _maintenance = value;
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
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Sélectionner le besoin en eau'),
                      ),
                      FormBuilderField(
                        name: 'watering',
                        initialValue: _watering,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (FormFieldState<dynamic> fieldWatering) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ItemRadio(
                                title: 'Peu d\'eau',
                                value: 'little',
                                selectedItem: _watering,
                                onItemSelected: (value) {
                                  setState(() {
                                    _watering = value;
                                    fieldWatering.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Arrosage régulier',
                                value: 'regularly',
                                selectedItem: _watering,
                                onItemSelected: (value) {
                                  setState(() {
                                    _watering = value;
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
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Sélectionner le besoin en lumière'),
                      ),
                      FormBuilderField(
                        name: 'lighting',
                        initialValue: _lighting,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (FormFieldState<dynamic> fieldLighting) {
                          return Column(
                            children: [
                              ItemRadio(
                                title: 'Soleil directe',
                                value: 'sun',
                                selectedItem: _lighting,
                                onItemSelected: (value) {
                                  setState(() {
                                    _lighting = value;
                                    fieldLighting.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Lumière indirecte',
                                value: 'indirectLight',
                                selectedItem: _lighting,
                                onItemSelected: (value) {
                                  setState(() {
                                    _lighting = value;
                                    fieldLighting.didChange(value);
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ItemRadio(
                                title: 'Ombre',
                                value: 'shade',
                                selectedItem: _lighting,
                                onItemSelected: (value) {
                                  setState(() {
                                    _lighting = value;
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
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Ajouter une brève description'),
                      ),
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
                        controller: _descriptionController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ce champ est requis'),
                          FormBuilderValidators.maxLength(_maxChar,
                              errorText: 'Maximum $_maxChar caractères'),
                        ]),
                      ),
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                            'Sélectionner une à trois photos de votre plante'),
                      ),
                      FormBuilderField<List<String>>(
                        name: 'images',
                        initialValue: _updatedImages,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(1,
                              errorText:
                                  'Veuillez sélectionner au moins une image'),
                        ]),
                        builder: (FormFieldState<List<String>> fieldImage) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CatalogUploadImage(
                                catalog: widget.catalog.copyWith(
                                    newImages: fieldImage.value ?? []),
                                field: fieldImage,
                                onCatalogUpdated: (updatedCatalog) {
                                  setState(() {
                                    _updatedImages = updatedCatalog.images;
                                    fieldImage.didChange(_updatedImages);
                                  });
                                },
                              ),
                              if (fieldImage.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    fieldImage.errorText ?? '',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Souhaitez-vous publier votre plante ?'),
                      ),
                      FormBuilderSwitch(
                        name: 'isPublish',
                        inactiveTrackColor: AppColors.white,
                        title: const Text('Publier la plante'),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        initialValue: _isPublish,
                        onChanged: (value) {
                          setState(() {
                            _isPublish = value ?? false;
                          });
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ce champ est requis'),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomBar(
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonRoundedWithIcon(
                        text: 'Enregistrer',
                        onPressed: _save,
                        bgColor: AppColors.greenLight,
                        textColor: AppColors.blueGreen,
                        iconAlignment: IconAlignment.start,
                        icon: const Icon(LucideIcons.upload,
                            color: AppColors.blueGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

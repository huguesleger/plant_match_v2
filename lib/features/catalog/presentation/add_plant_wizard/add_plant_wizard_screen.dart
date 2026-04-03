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
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/util/string_to_enum.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_upload_image.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/grid_selectable_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/selectable_item.dart';
import 'package:plant_match_v2/features/user_points/presentation/cubit/user_points_cubit.dart';

class AddPlantWizardScreen extends StatefulWidget {
  const AddPlantWizardScreen({super.key, required this.catalog});
  final Catalog catalog;

  @override
  State<AddPlantWizardScreen> createState() => _AddPlantWizardScreenState();
}

class _AddPlantWizardScreenState extends State<AddPlantWizardScreen> {
  int _currentPage = 0;
  final int _totalPages = 10;
  final PageController _pageController = PageController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _offerTypeController = TextEditingController();
  final TextEditingController _isPublishController =
      TextEditingController(text: 'true');

  final _formKeyName = GlobalKey<FormBuilderState>();
  final _formKeyCategory = GlobalKey<FormBuilderState>();
  final _formKeyFamily = GlobalKey<FormBuilderState>();
  final _formKeyMaintenance = GlobalKey<FormBuilderState>();
  final _formKeyWatering = GlobalKey<FormBuilderState>();
  final _formKeyLighting = GlobalKey<FormBuilderState>();
  final _formKeyDescription = GlobalKey<FormBuilderState>();
  final _formKeyImage = GlobalKey<FormBuilderState>();
  final _formKeyOfferType = GlobalKey<FormBuilderState>();
  final _formKeyIsPublish = GlobalKey<FormBuilderState>();

  final List<String> _selectedFamilies = [];
  String? _selectedMaintenance;
  String? _selectedWatering;
  String? _selectedLighting;
  late Catalog _wizardCatalog;

  @override
  void initState() {
    super.initState();
    _wizardCatalog = widget.catalog;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _offerTypeController.dispose();
    _isPublishController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Ajouter une plante',
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        onPressed: _onBack,
        leading: _currentPage != 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _onExit,
            icon: const Icon(LucideIcons.x, color: AppColors.greyDark),
          ),
        ],
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(color: AppColors.greyLight),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildProgress(),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _buildSteps(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        child: ButtonRounded(
          text: _currentPage == _totalPages - 1 ? 'Terminer' : 'Suivant',
          onPressed: _onNextPressed,
          bgColor: AppColors.greenLight,
          textColor: AppColors.blueGreen,
        ),
      ),
    );
  }

  Widget _buildProgress() => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: LinearProgressIndicator(
          value: (_currentPage + 1) / _totalPages,
          backgroundColor: AppColors.greyLight,
          color: AppColors.greenLight,
          minHeight: 2,
        ),
      );

  List<Widget> _buildSteps() => [
        _StepName(formKey: _formKeyName, controller: _nameController),
        _StepCategory(
            formKey: _formKeyCategory, controller: _categoryController),
        _StepFamily(
            formKey: _formKeyFamily,
            selectedValues: _selectedFamilies,
            onSelect: (v) => setState(() {
                  if (_selectedFamilies.contains(v)) {
                    _selectedFamilies.remove(v);
                  } else {
                    _selectedFamilies.add(v);
                  }
                })),
        _StepMaintenance(
            formKey: _formKeyMaintenance,
            selected: _selectedMaintenance,
            onSelect: (v) => setState(() => _selectedMaintenance = v)),
        _StepWatering(
            formKey: _formKeyWatering,
            selected: _selectedWatering,
            onSelect: (v) => setState(() => _selectedWatering = v)),
        _StepLighting(
            formKey: _formKeyLighting,
            selected: _selectedLighting,
            onSelect: (v) => setState(() => _selectedLighting = v)),
        _StepDescription(
            formKey: _formKeyDescription, controller: _descriptionController),
        _StepImage(
            formKey: _formKeyImage,
            catalog: _wizardCatalog,
            onUpdate: (c) => setState(() => _wizardCatalog = c)),
        _StepOfferType(
            formKey: _formKeyOfferType,
            controller: _offerTypeController,
            onSelect: (v) => setState(() => _offerTypeController.text = v)),
        _StepPublish(
            formKey: _formKeyIsPublish,
            controller: _isPublishController,
            onToggle: (v) =>
                setState(() => _isPublishController.text = v.toString())),
      ];

  void _onNextPressed() {
    final keys = [
      _formKeyName,
      _formKeyCategory,
      _formKeyFamily,
      _formKeyMaintenance,
      _formKeyWatering,
      _formKeyLighting,
      _formKeyDescription,
      _formKeyImage,
      _formKeyOfferType,
      _formKeyIsPublish
    ];
    if (keys[_currentPage].currentState?.saveAndValidate() ?? false) {
      if (_currentPage < _totalPages - 1) {
        _onNext();
      } else {
        _onSave();
      }
    }
  }

  void _onNext() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      _currentPage++;
    });
  }

  void _onBack() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      _currentPage--;
    });
  }

  void _onExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => const DialogWithImage(
        imagePath: 'assets/images/empty_catalog_filter.png',
        title: 'Quitter sans enregistrer ?',
        text: 'Les informations saisies seront perdues.',
      ),
    );
    if (shouldExit == true && mounted) Navigator.pop(context);
  }

  void _onSave() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _LoadingDialog());
    try {
      final cubit = context.read<CatalogCubit>();
      final finalCatalog = _wizardCatalog.copyWith(
        newName: _nameController.text,
        newDescription: _descriptionController.text,
        newEnvironment: getEnvironmentFromString(_categoryController.text),
        newFamily: _selectedFamilies
            .map(getFamilyFromString)
            .whereType<Family>()
            .toList(),
        newLevelMaintenance:
            getLevelMaintenanceFromString(_selectedMaintenance ?? 'low'),
        newWatering: getWateringFromString(_selectedWatering ?? 'little'),
        newLighting: getLightingFromString(_selectedLighting ?? 'sun'),
        newOfferType: getOfferTypeFromString(_offerTypeController.text),
        newStatus: _isPublishController.text == 'true'
            ? CatalogStatus.published
            : CatalogStatus.draft,
      );

      final saveRes = await cubit.addCatalog(finalCatalog).run();
      final (id, isFirst) = saveRes.getOrElse((_) => ("", false));

      final localImages =
          finalCatalog.images.where((img) => !img.startsWith('http')).toList();
      if (localImages.isNotEmpty) {
        await cubit.uploadCatalogImages(
            catalog: finalCatalog,
            catalogId: id,
            imagePaths: localImages,
            existingImages: []).run();
      }

      if (isFirst && mounted) {
        context
            .read<UserPointsCubit>()
            .updateUserPoints(finalCatalog.userId, 25);
      }

      if (mounted) {
        Navigator.pop(context); // loading
        Navigator.pop(context, true); // catalog
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }
}

class _StepName extends StatelessWidget {
  const _StepName({required this.formKey, required this.controller});
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Nom de la plante',
      description: 'Entrez le nom de la plante',
      child: FormBuilderTextField(
        name: 'name',
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration:
            DecorationInput.inputDecoration(hintText: 'Nom', labelText: 'Nom'),
        validator:
            FormBuilderValidators.required(errorText: 'Ce champ est requis'),
      ));
}

class _StepCategory extends StatelessWidget {
  const _StepCategory({required this.formKey, required this.controller});
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Quel environnement ?',
      description: 'Sélectionnez une catégorie',
      child: FormBuilderField(
          name: 'cat',
          initialValue: controller.text,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: SelectableItem(
                            icon: LucideIcons.house,
                            label: 'Intérieur',
                            value: 'indoor',
                            isSelected: controller.text == 'indoor',
                            onTap: (v) {
                              controller.text = v;
                              field.didChange(v);
                              field.validate();
                            })),
                    const SizedBox(width: 10),
                    Expanded(
                        child: SelectableItem(
                            icon: LucideIcons.trees,
                            label: 'Extérieur',
                            value: 'outdoor',
                            isSelected: controller.text == 'outdoor',
                            onTap: (v) {
                              controller.text = v;
                              field.didChange(v);
                              field.validate();
                            })),
                  ]),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              )));
}

class _StepFamily extends StatelessWidget {
  const _StepFamily(
      {required this.formKey,
      required this.selectedValues,
      required this.onSelect});
  final GlobalKey<FormBuilderState> formKey;
  final List<String> selectedValues;
  final Function(String) onSelect;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Choisir une famille',
      description: 'Sélectionnez une ou des catégorie(s)',
      child: FormBuilderField(
          name: 'fam',
          initialValue: selectedValues,
          validator: FormBuilderValidators.minLength(1,
              errorText: 'Ce champ est requis'),
          builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridSelectableItem(
                      selectedValues: selectedValues,
                      onSelect: (v) {
                        onSelect(v);
                        field.didChange(selectedValues);
                        field.validate();
                      }),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              )));
}

class _StepMaintenance extends StatelessWidget {
  const _StepMaintenance(
      {required this.formKey, required this.selected, required this.onSelect});
  final GlobalKey<FormBuilderState> formKey;
  final String? selected;
  final Function(String) onSelect;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Entretien',
      description: 'Niveau de difficulté',
      child: FormBuilderField(
          name: 'maint',
          initialValue: selected,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    const TitleWithIcon(
                        icon: LucideIcons.shovel,
                        title: 'Difficulté',
                        bgColor: AppColors.greenDark,
                        iconColor: AppColors.greenLight),
                    const SizedBox(height: 10),
                    ItemRadio(
                        title: 'Facile',
                        value: 'low',
                        selectedItem: selected,
                        onItemSelected: (v) {
                          onSelect(v);
                          field.didChange(v);
                          field.validate();
                        }),
                    const SizedBox(height: 10),
                    ItemRadio(
                        title: 'Moyen',
                        value: 'medium',
                        selectedItem: selected,
                        onItemSelected: (v) {
                          onSelect(v);
                          field.didChange(v);
                          field.validate();
                        }),
                    const SizedBox(height: 10),
                    ItemRadio(
                        title: 'Difficile',
                        value: 'high',
                        selectedItem: selected,
                        onItemSelected: (v) {
                          onSelect(v);
                          field.didChange(v);
                          field.validate();
                        }),
                  ]),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              )));
}

class _StepWatering extends StatelessWidget {
  const _StepWatering(
      {required this.formKey, required this.selected, required this.onSelect});
  final GlobalKey<FormBuilderState> formKey;
  final String? selected;
  final Function(String) onSelect;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Arrosage',
      description: 'Besoin en eau',
      child: FormBuilderField(
          name: 'wat',
          initialValue: selected,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    const TitleWithIcon(
                        icon: LucideIcons.droplet,
                        title: 'Eau',
                        bgColor: AppColors.greenDark,
                        iconColor: AppColors.greenLight),
                    const SizedBox(height: 10),
                    ItemRadio(
                        title: 'Peu d\'eau',
                        value: 'little',
                        selectedItem: selected,
                        onItemSelected: (v) {
                          onSelect(v);
                          field.didChange(v);
                          field.validate();
                        }),
                    const SizedBox(height: 10),
                    ItemRadio(
                        title: 'Régulier',
                        value: 'regularly',
                        selectedItem: selected,
                        onItemSelected: (v) {
                          onSelect(v);
                          field.didChange(v);
                          field.validate();
                        }),
                  ]),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              )));
}

class _StepLighting extends StatelessWidget {
  const _StepLighting(
      {required this.formKey, required this.selected, required this.onSelect});
  final GlobalKey<FormBuilderState> formKey;
  final String? selected;
  final Function(String) onSelect;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Lumière',
      description: 'Besoin en lumière',
      child: FormBuilderField(
          name: 'light',
          initialValue: selected,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    const TitleWithIcon(
                        icon: LucideIcons.sun,
                        title: 'Lumière',
                        bgColor: AppColors.greenDark,
                        iconColor: AppColors.greenLight),
                    const SizedBox(height: 10),
                    ItemRadio(
                        title: 'Soleil',
                        value: 'sun',
                        selectedItem: selected,
                        onItemSelected: (v) {
                          onSelect(v);
                          field.didChange(v);
                        }),
                    const SizedBox(height: 10),
                    ItemRadio(
                        title: 'Indirecte',
                        value: 'indirectLight',
                        selectedItem: selected,
                        onItemSelected: (v) {
                          onSelect(v);
                          field.didChange(v);
                          field.validate();
                        }),
                    const SizedBox(height: 10),
                    ItemRadio(
                        title: 'Ombre',
                        value: 'shade',
                        selectedItem: selected,
                        onItemSelected: (v) {
                          onSelect(v);
                          field.didChange(v);
                          field.validate();
                        }),
                  ]),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              )));
}

class _StepDescription extends StatelessWidget {
  const _StepDescription({required this.formKey, required this.controller});
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Description',
      description: 'Ajouter une brève description',
      child: FormBuilderTextField(
        name: 'desc',
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: 4,
        maxLength: 150,
        decoration: DecorationInput.inputDecoration(
            hintText: 'Description',
            labelText: 'Description',
            alignLabelWithHint: true),
        validator:
            FormBuilderValidators.required(errorText: 'Ce champ est requis'),
      ));
}

class _StepImage extends StatelessWidget {
  const _StepImage(
      {required this.formKey, required this.catalog, required this.onUpdate});
  final GlobalKey<FormBuilderState> formKey;
  final Catalog catalog;
  final Function(Catalog) onUpdate;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Ajouter une photo',
      description: 'Sélectionner une à trois photos de votre plante',
      child: FormBuilderField<List<String>>(
          name: 'imgs',
          initialValue: catalog.images,
          validator: FormBuilderValidators.minLength(1,
              errorText: 'Ce champ est requis'),
          builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CatalogUploadImage(
                      catalog: catalog,
                      field: field,
                      onCatalogUpdated: (c) {
                        onUpdate(c);
                        field.didChange(c.images);
                        field.validate();
                      }),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              )));
}

class _StepOfferType extends StatelessWidget {
  const _StepOfferType(
      {required this.formKey,
      required this.controller,
      required this.onSelect});
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  final Function(String) onSelect;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Offre',
      description: 'Que faire de votre plante ?',
      child: FormBuilderField(
          name: 'offer',
          initialValue: controller.text,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: SelectableItem(
                            icon: LucideIcons.gift,
                            label: 'Donation',
                            value: 'donation',
                            isSelected: controller.text == 'donation',
                            onTap: (v) {
                              onSelect(v);
                              field.didChange(v);
                              field.validate();
                            })),
                    const SizedBox(width: 10),
                    Expanded(
                        child: SelectableItem(
                            icon: LucideIcons.heart_handshake,
                            label: 'Echange',
                            value: 'exchange',
                            isSelected: controller.text == 'exchange',
                            onTap: (v) {
                              onSelect(v);
                              field.didChange(v);
                              field.validate();
                            })),
                  ]),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              )));
}

class _StepPublish extends StatelessWidget {
  const _StepPublish(
      {required this.formKey,
      required this.controller,
      required this.onToggle});
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  final Function(bool) onToggle;
  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
      formKey: formKey,
      title: 'Publication',
      description: 'Publier maintenant ?',
      child: FormBuilderSwitch(
        name: 'pub',
        title: const Text('Publier la plante'),
        initialValue: controller.text == 'true',
        onChanged: (v) => onToggle(v ?? false),
      ));
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.greenLight),
            SizedBox(height: 24),
            Text('Création...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/util/string_to_enum.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_upload_image.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/grid_selectable_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/selectable_item.dart';

class EditCatalogScreen extends StatefulWidget {
  final Catalog catalog;
  const EditCatalogScreen({super.key, required this.catalog});

  @override
  State<EditCatalogScreen> createState() => _EditCatalogScreenState();
}

class _EditCatalogScreenState extends State<EditCatalogScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  String? _environment;
  String? _offerType;
  List<String> _selectedFamilies = [];
  String? _maintenance;
  String? _watering;
  String? _lighting;
  late List<String> _updatedImages;
  bool? _isPublish;
  bool _isSaving = false;

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
    _offerType = widget.catalog.offerType.name;
    _isPublish = widget.catalog.status == CatalogStatus.published;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Modifier ${widget.catalog.name}',
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        onPressed: () => Navigator.pop(context),
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(color: AppColors.greyLight),
        ),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
      bottomNavigationBar: _isSaving ? null : _buildBottomBar(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingAll,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildEnvironmentSection(),
            const SizedBox(height: 25),
            _buildFamilySection(),
            const SizedBox(height: 25),
            _buildMaintenanceSection(),
            const SizedBox(height: 25),
            _buildWateringSection(),
            const SizedBox(height: 25),
            _buildLightingSection(),
            const SizedBox(height: 25),
            _buildDescriptionField(),
            const SizedBox(height: 25),
            _buildImageSection(),
            const SizedBox(height: 25),
            _buildOfferTypeSection(),
            const SizedBox(height: 25),
            _buildPublishSwitch(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() => FormBuilderTextField(
        name: 'plantName',
        controller: _nameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: DecorationInput.inputDecoration(
            hintText: 'Nom de la plante', labelText: 'Nom'),
        validator:
            FormBuilderValidators.required(errorText: 'Ce champ est requis'),
      );

  Widget _buildEnvironmentSection() => _FormSection(
        title: 'Sélectionner une catégorie pour votre plante',
        child: FormBuilderField(
          name: 'category',
          initialValue: _environment,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SelectableItem(
                      icon: LucideIcons.house,
                      label: "Intérieur",
                      value: "indoor",
                      isSelected: _environment == "indoor",
                      onTap: (val) => setState(() {
                        _environment = val;
                        field.didChange(val);
                        field.validate();
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableItem(
                      icon: LucideIcons.trees,
                      label: "Extérieur",
                      value: "outdoor",
                      isSelected: _environment == "outdoor",
                      onTap: (val) => setState(() {
                        _environment = val;
                        field.didChange(val);
                        field.validate();
                      }),
                    ),
                  ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildFamilySection() => _FormSection(
        title: 'Sélectionner une ou des catégorie(s)',
        child: FormBuilderField(
          name: 'family',
          initialValue: _selectedFamilies,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridSelectableItem(
                selectedValues: _selectedFamilies,
                onSelect: (val) => setState(() {
                  if (_selectedFamilies.contains(val)) {
                    _selectedFamilies.remove(val);
                  } else {
                    _selectedFamilies.add(val);
                  }
                  field.didChange(_selectedFamilies);
                  field.validate();
                }),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildMaintenanceSection() => _FormSection(
        title: 'Sélectionner un niveau de difficulté',
        child: FormBuilderField(
          name: 'maintenance',
          initialValue: _maintenance,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ItemRadio(
                    title: 'Facile',
                    subtitle: 'Très résistante, peu d\'arrosage',
                    value: 'low',
                    selectedItem: _maintenance,
                    onItemSelected: (val) => setState(() {
                      _maintenance = val;
                      field.didChange(val);
                      field.validate();
                    }),
                  ),
                  const SizedBox(height: 20),
                  ItemRadio(
                    title: 'Moyen',
                    subtitle: 'Quelques soins réguliers',
                    value: 'medium',
                    selectedItem: _maintenance,
                    onItemSelected: (val) => setState(() {
                      _maintenance = val;
                      field.didChange(val);
                      field.validate();
                    }),
                  ),
                  const SizedBox(height: 20),
                  ItemRadio(
                    title: 'Difficile',
                    subtitle: 'Sensible, besoin de conditions spécifiques.',
                    value: 'high',
                    selectedItem: _maintenance,
                    onItemSelected: (val) => setState(() {
                      _maintenance = val;
                      field.didChange(val);
                      field.validate();
                    }),
                  ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildWateringSection() => _FormSection(
        title: 'Sélectionner le besoin en eau',
        child: FormBuilderField(
          name: 'watering',
          initialValue: _watering,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ItemRadio(
                    title: 'Peu d\'eau',
                    value: 'little',
                    selectedItem: _watering,
                    onItemSelected: (val) => setState(() {
                      _watering = val;
                      field.didChange(val);
                      field.validate();
                    }),
                  ),
                  const SizedBox(height: 20),
                  ItemRadio(
                    title: 'Arrosage régulier',
                    value: 'regularly',
                    selectedItem: _watering,
                    onItemSelected: (val) => setState(() {
                      _watering = val;
                      field.didChange(val);
                      field.validate();
                    }),
                  ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildLightingSection() => _FormSection(
        title: 'Sélectionner le besoin en lumière',
        child: FormBuilderField(
          name: 'lighting',
          initialValue: _lighting,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ItemRadio(
                    title: 'Soleil directe',
                    value: 'sun',
                    selectedItem: _lighting,
                    onItemSelected: (val) => setState(() {
                      _lighting = val;
                      field.didChange(val);
                    }),
                  ),
                  const SizedBox(height: 20),
                  ItemRadio(
                    title: 'Lumière indirecte',
                    value: 'indirectLight',
                    selectedItem: _lighting,
                    onItemSelected: (val) => setState(() {
                      _lighting = val;
                      field.didChange(val);
                      field.validate();
                    }),
                  ),
                  const SizedBox(height: 20),
                  ItemRadio(
                    title: 'Ombre',
                    value: 'shade',
                    selectedItem: _lighting,
                    onItemSelected: (val) => setState(() {
                      _lighting = val;
                      field.didChange(val);
                      field.validate();
                    }),
                  ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildDescriptionField() => _FormSection(
        title: 'Ajouter une brève description',
        child: FormBuilderTextField(
          maxLines: 4,
          maxLength: 150,
          name: 'description',
          controller: _descriptionController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: DecorationInput.inputDecoration(
              hintText: 'Description de la plante',
              labelText: 'Description',
              alignLabelWithHint: true),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Ce champ est requis'),
            FormBuilderValidators.maxLength(150,
                errorText: 'Maximum 150 caractères'),
          ]),
        ),
      );

  Widget _buildImageSection() => _FormSection(
        title: 'Sélectionner une à trois photos de votre plante',
        child: FormBuilderField<List<String>>(
          name: 'images',
          initialValue: _updatedImages,
          validator: FormBuilderValidators.minLength(1,
              errorText: 'Ce champ est requis'),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CatalogUploadImage(
                catalog: widget.catalog.copyWith(newImages: field.value ?? []),
                field: field,
                onCatalogUpdated: (updatedCatalog) => setState(() {
                  _updatedImages = updatedCatalog.images;
                  field.didChange(_updatedImages);
                  field.validate();
                }),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildOfferTypeSection() => _FormSection(
        title: 'Que souhaitez-vous faire de votre plante ?',
        child: FormBuilderField(
          name: 'offerType',
          initialValue: _offerType,
          validator:
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SelectableItem(
                      icon: LucideIcons.gift,
                      label: "Donation",
                      value: "donation",
                      isSelected: _offerType == "donation",
                      onTap: (val) => setState(() {
                        _offerType = val;
                        field.didChange(val);
                        field.validate();
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableItem(
                      icon: LucideIcons.heart_handshake,
                      label: "Echange",
                      value: "exchange",
                      isSelected: _offerType == "exchange",
                      onTap: (val) => setState(() {
                        _offerType = val;
                        field.didChange(val);
                        field.validate();
                      }),
                    ),
                  ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildPublishSwitch() => FormBuilderSwitch(
        name: 'isPublish',
        inactiveTrackColor: AppColors.white,
        title: const Text('Publier la plante'),
        decoration: const InputDecoration(border: InputBorder.none),
        initialValue: _isPublish,
        onChanged: (val) => setState(() => _isPublish = val ?? false),
      );

  Widget _buildBottomBar() => BottomBar(
        child: ButtonRoundedWithIcon(
          text: 'Enregistrer',
          onPressed: _save,
          bgColor: AppColors.greenLight,
          textColor: AppColors.blueGreen,
          iconAlignment: IconAlignment.start,
          icon: const Icon(LucideIcons.upload, color: AppColors.blueGreen),
        ),
      );

  void _save() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isSaving = true);
      final cubit = context.read<CatalogCubit>();
      final catalog = widget.catalog;

      final localImages =
          _updatedImages.where((img) => !img.startsWith('http')).toList();
      final existingImages =
          _updatedImages.where((img) => img.startsWith('http')).toList();

      Catalog updated = catalog;
      if (localImages.isNotEmpty) {
        final res = await cubit
            .uploadCatalogImages(
              catalog: catalog,
              imagePaths: localImages,
              catalogId: catalog.catalogId ?? '',
              existingImages: existingImages,
            )
            .run();

        final uploaded = res.match((failure) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur upload: ${failure.message}")));
          return null;
        }, (c) => c);
        if (uploaded == null) return;
        updated = uploaded;
      } else {
        updated = catalog.copyWith(newImages: _updatedImages);
      }

      final fullyUpdated = updated.copyWith(
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
        newOfferType: getOfferTypeFromString(_offerType ?? 'exchange'),
        newStatus:
            _isPublish == true ? CatalogStatus.published : CatalogStatus.draft,
      );

      cubit.updateCatalog(fullyUpdated);
      if (mounted) {
        setState(() => _isSaving = false);
        Navigator.pop(context, true);
      }
    }
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(title)),
        child,
      ],
    );
  }
}

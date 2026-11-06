import 'package:fpdart/fpdart.dart' hide State;
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/name_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/environment_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/family_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/maintenance_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/watering_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/lighting_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/description_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/image_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/offer_type_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/field/publish_field.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/bottom_bar_action.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_state.dart';

class CatalogEditScreen extends StatefulWidget {
  final Catalog catalog;
  const CatalogEditScreen({super.key, required this.catalog});

  @override
  State<CatalogEditScreen> createState() => _CatalogEditScreenState();
}

class _CatalogEditScreenState extends State<CatalogEditScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  late Environment _environment;
  late OfferType _offerType;
  List<Family> _selectedFamilies = [];
  late LevelMaintenance _maintenance;
  late Watering _watering;
  late Lighting _lighting;
  late List<String> _updatedImages;
  late bool _isPublish;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.catalog.name);
    _descriptionController =
        TextEditingController(text: widget.catalog.description);
    _environment = widget.catalog.environment;
    _selectedFamilies = List.from(widget.catalog.family);
    _maintenance = widget.catalog.levelMaintenance;
    _watering = widget.catalog.watering;
    _lighting = widget.catalog.lighting;
    _updatedImages = List.from(widget.catalog.images);
    _offerType = widget.catalog.offerType;
    _isPublish = widget.catalog.status == CatalogStatus.published;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) => switch (state) {
        CatalogLoading() => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        CatalogError(:final failure) => Scaffold(
            body: ErrorPage(
              failure: failure,
              onRetry: () =>
                  context.read<CatalogCubit>().emitLoaded([], widget.catalog),
            ),
          ),
        CatalogInitial() || CatalogLoaded() => Scaffold(
            appBar: AppBarTemplate(
              title:
                  Some(t.catalog.edit.modifier_with_name(name: widget.catalog.name)),
              centerTitle: true,
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              onPressed: Some(() => Navigator.pop(context)),
              styleIconButton: Some(IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: AppColors.greyLight),
              )),
            ),
            body: SingleChildScrollView(
              padding: AppSpacing.paddingAll,
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NameField(controller: _nameController),
                    const SizedBox(height: 16),
                    EnvironmentField(
                      selectedEnvironment: _environment,
                      onChanged: (val) => setState(() => _environment = val),
                    ),
                    const SizedBox(height: 25),
                    FamilyField(
                      selectedFamilies: _selectedFamilies,
                      onSelect: (val) => setState(() {
                        if (_selectedFamilies.contains(val)) {
                          _selectedFamilies.remove(val);
                        } else {
                          _selectedFamilies.add(val);
                        }
                      }),
                    ),
                    const SizedBox(height: 25),
                    MaintenanceField(
                      selectedMaintenance: _maintenance,
                      onChanged: (val) => setState(() => _maintenance = val),
                    ),
                    const SizedBox(height: 25),
                    WateringField(
                      selectedWatering: _watering,
                      onChanged: (val) => setState(() => _watering = val),
                    ),
                    const SizedBox(height: 25),
                    LightingField(
                      selectedLighting: _lighting,
                      onChanged: (val) => setState(() => _lighting = val),
                    ),
                    const SizedBox(height: 25),
                    DescriptionField(controller: _descriptionController),
                    const SizedBox(height: 25),
                    ImageField(
                      catalog: widget.catalog,
                      updatedImages: _updatedImages,
                      onCatalogUpdated: (updatedCatalog) => setState(() {
                        _updatedImages = updatedCatalog.images;
                      }),
                    ),
                    const SizedBox(height: 25),
                    OfferTypeField(
                      selectedOfferType: _offerType,
                      onChanged: (val) => setState(() => _offerType = val),
                    ),
                    const SizedBox(height: 25),
                    PublishField(
                      isPublish: _isPublish,
                      onChanged: (val) => setState(() => _isPublish = val),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomBarAction(onSave: _save),
          ),
      },
    );
  }

  Future<void> _save() async {
    if (!Option.fromNullable(_formKey.currentState)
        .match(() => false, (s) => s.saveAndValidate())) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = await context
        .read<CatalogCubit>()
        .saveEditedCatalog(original: widget.catalog, edited: _editedCatalog())
        .run();
    if (!mounted) return;
    result.match<void>(
      (failure) => messenger.showSnackBar(SnackBar(
          content: Text(failure.errorContent.message))),
      (_) => navigator.pop(true),
    );
  }

  Catalog _editedCatalog() => widget.catalog.copyWith(
        newImages: Some(_updatedImages),
        newName: Some(_nameController.text),
        newDescription: Some(_descriptionController.text),
        newEnvironment: Some(_environment),
        newFamily: Some(_selectedFamilies),
        newLevelMaintenance: Some(_maintenance),
        newWatering: Some(_watering),
        newLighting: Some(_lighting),
        newOfferType: Some(_offerType),
        newStatus:
            Some(_isPublish ? CatalogStatus.published : CatalogStatus.draft),
      );
}

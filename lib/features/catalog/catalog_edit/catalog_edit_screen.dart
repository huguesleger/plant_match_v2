import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/util/string_to_enum.dart';
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

  String? _environment;
  String? _offerType;
  List<String> _selectedFamilies = [];
  String? _maintenance;
  String? _watering;
  String? _lighting;
  late List<String> _updatedImages;
  bool? _isPublish;

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
    return BlocListener<CatalogCubit, CatalogState>(
      listener: (context, state) {
        if (state is CatalogLoaded && mounted) {
          Navigator.pop(context, true);
        }
      },
      child: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) => switch (state) {
          CatalogLoading() => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          CatalogError(:final message) => Scaffold(
              body: ErrorPage(
                errorMessage: message,
                onRetry: () =>
                    context.read<CatalogCubit>().emitLoaded([], widget.catalog),
              ),
            ),
          CatalogInitial() || CatalogLoaded() => Scaffold(
              appBar: AppBarTemplate(
                title: 'Modifier ${widget.catalog.name}',
                centerTitle: true,
                backgroundColor: AppColors.white,
                surfaceTintColor: AppColors.white,
                onPressed: () => Navigator.pop(context),
                styleIconButton: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: const BorderSide(color: AppColors.greyLight),
                ),
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
                        isPublish: _isPublish ?? false,
                        onChanged: (val) => setState(() => _isPublish = val),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomBarAction(onSave: _save),
            ),
        },
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
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
              catalogId: catalog.catalogId.getOrElse(() => ''),
              existingImages: existingImages,
            )
            .run();

        final uploaded = res.match((failure) {
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
    }
  }
}

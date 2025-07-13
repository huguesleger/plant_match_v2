import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/util/string_to_enum.dart';
import 'package:plant_match_v2/presentation/catolog/widget/catalog_upload_image.dart';
import 'package:plant_match_v2/presentation/catolog/widget/selectable_item.dart';

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

  List<Family> getAllFamilies() {
    return [
      Family.flower,
      Family.aquatic,
      Family.aromatic,
      Family.bonsai,
      Family.carnivorous,
      Family.climbing,
      Family.medical,
      Family.succulent,
      Family.tropical
    ];
  }

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
  }

  void _save() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final updatedCatalog = widget.catalog.copyWith(
        newCatalogId: widget.catalog.catalogId,
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
        newImages: _updatedImages,
      );

      await context.read<CatalogCubit>().updateCatalog(updatedCatalog);
      if (mounted) Navigator.pop(context, true);
    }
  }

  Widget _buildDropdown({
    required String name,
    required String label,
    required List<String> options,
    required String? initialValue,
    required void Function(String?) onChanged,
  }) {
    return FormBuilderDropdown<String>(
      name: name,
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      items: options
          .map((val) => DropdownMenuItem(value: val, child: Text(val)))
          .toList(),
      onChanged: onChanged,
      validator: FormBuilderValidators.required(),
    );
  }

  void onSelect(String value) {
    setState(() {
      _environment = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la plante'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
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
/*              _buildDropdown(
                name: 'environment',
                label: 'Environnement',
                options: ['indoor', 'outdoor'],
                initialValue: _environment,
                onChanged: (val) => setState(() => _environment = val),
              ),*/
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
                              icon: LucideIcons.fence,
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
              const SizedBox(height: 16),
              FormBuilderFilterChips<String>(
                name: 'families',
                initialValue: _selectedFamilies,
                options: getAllFamilies()
                    .map((f) => FormBuilderChipOption(
                        value: f.name, child: Text(f.name)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Famille(s)'),
                onChanged: (val) =>
                    setState(() => _selectedFamilies = val ?? []),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                name: 'maintenance',
                label: 'Entretien',
                options: ['low', 'medium', 'high'],
                initialValue: _maintenance,
                onChanged: (val) => setState(() => _maintenance = val),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                name: 'watering',
                label: 'Arrosage',
                options: ['little', 'regularly'],
                initialValue: _watering,
                onChanged: (val) => setState(() => _watering = val),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                name: 'lighting',
                label: 'Lumière',
                options: ['sun', 'indirectLight', 'shade'],
                initialValue: _lighting,
                onChanged: (val) => setState(() => _lighting = val),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'description',
                controller: _descriptionController,
                maxLines: 4,
                maxLength: 150,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(150),
                ]),
              ),
              const SizedBox(height: 24),

              // 📷 IMAGE MODIFIER
              CatalogUploadImage(
                userId: widget.catalog.userId,
                catalogId: widget.catalog.catalogId!,
                catalog: widget.catalog,
                onCatalogUpdated: (updatedCatalog) {
                  setState(() {
                    _updatedImages = updatedCatalog.images;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_draft.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_description.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_environment.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_family.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_image.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_lighting.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_maintenance.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_name.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_offer_type.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_publish.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_watering.dart';

class AddPlantWizardPages extends StatelessWidget {
  const AddPlantWizardPages({
    super.key,
    required this.pageController,
    required this.page,
    required this.formKeys,
    required this.nameController,
    required this.descriptionController,
    required this.draft,
    required this.onDraftChanged,
  });

  static const int count = 10;

  final PageController pageController;
  final int page;
  final List<GlobalKey<FormBuilderState>> formKeys;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final AddPlantDraft draft;
  final ValueChanged<AddPlantDraft> onDraftChanged;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          LinearProgressIndicator(
            value: (page + 1) / count,
            backgroundColor: AppColors.greyLight,
            color: AppColors.greenLight,
            minHeight: 2,
          ),
          const SizedBox(height: 18),
          Expanded(child: _pages()),
        ],
      );

  Widget _pages() => PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          StepName(formKey: formKeys[0], controller: nameController),
          StepEnvironment(
            formKey: formKeys[1],
            selected: draft.environment,
            onSelect: (v) => onDraftChanged(draft.copyWith(environment: Some(v))),
          ),
          StepFamily(
            formKey: formKeys[2],
            selectedValues: draft.families,
            onSelect: (v) => onDraftChanged(draft.toggleFamily(v)),
          ),
          StepMaintenance(
            formKey: formKeys[3],
            selected: draft.maintenance,
            onSelect: (v) => onDraftChanged(draft.copyWith(maintenance: Some(v))),
          ),
          StepWatering(
            formKey: formKeys[4],
            selected: draft.watering,
            onSelect: (v) => onDraftChanged(draft.copyWith(watering: Some(v))),
          ),
          StepLighting(
            formKey: formKeys[5],
            selected: draft.lighting,
            onSelect: (v) => onDraftChanged(draft.copyWith(lighting: Some(v))),
          ),
          StepDescription(
            formKey: formKeys[6],
            controller: descriptionController,
          ),
          StepImage(
            formKey: formKeys[7],
            catalog: draft.catalog,
            onUpdate: (c) => onDraftChanged(draft.copyWith(catalog: Some(c))),
          ),
          StepOfferType(
            formKey: formKeys[8],
            selected: draft.offerType,
            onSelect: (v) => onDraftChanged(draft.copyWith(offerType: Some(v))),
          ),
          StepPublish(
            formKey: formKeys[9],
            value: draft.publish,
            onToggle: (v) => onDraftChanged(draft.copyWith(publish: Some(v))),
          ),
        ],
      );
}

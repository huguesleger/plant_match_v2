import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/dialog/dialog_with_image.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/util/string_to_enum.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_environment.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_description.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_family.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_image.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_lighting.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_maintenance.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_name.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_offer_type.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_publish.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/steps/step_watering.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/loading_dialog.dart';

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
  final TextEditingController _environmentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _offerTypeController = TextEditingController();
  final TextEditingController _isPublishController =
      TextEditingController(text: 'true');

  final _formKeyName = GlobalKey<FormBuilderState>();
  final _formKeyEnvironment = GlobalKey<FormBuilderState>();
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
    _environmentController.dispose();
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
        StepName(formKey: _formKeyName, controller: _nameController),
        StepEnvironment(
            formKey: _formKeyEnvironment, controller: _environmentController),
        StepFamily(
            formKey: _formKeyFamily,
            selectedValues: _selectedFamilies,
            onSelect: (v) => setState(() {
                  if (_selectedFamilies.contains(v)) {
                    _selectedFamilies.remove(v);
                  } else {
                    _selectedFamilies.add(v);
                  }
                })),
        StepMaintenance(
            formKey: _formKeyMaintenance,
            selected: _selectedMaintenance,
            onSelect: (v) => setState(() => _selectedMaintenance = v)),
        StepWatering(
            formKey: _formKeyWatering,
            selected: _selectedWatering,
            onSelect: (v) => setState(() => _selectedWatering = v)),
        StepLighting(
            formKey: _formKeyLighting,
            selected: _selectedLighting,
            onSelect: (v) => setState(() => _selectedLighting = v)),
        StepDescription(
            formKey: _formKeyDescription, controller: _descriptionController),
        StepImage(
            formKey: _formKeyImage,
            catalog: _wizardCatalog,
            onUpdate: (c) => setState(() => _wizardCatalog = c)),
        StepOfferType(
            formKey: _formKeyOfferType,
            controller: _offerTypeController,
            onSelect: (v) => setState(() => _offerTypeController.text = v)),
        StepPublish(
            formKey: _formKeyIsPublish,
            controller: _isPublishController,
            onToggle: (v) =>
                setState(() => _isPublishController.text = v.toString())),
      ];

  void _onNextPressed() {
    final keys = [
      _formKeyName,
      _formKeyEnvironment,
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
        imagePath: 'res/images/empty_catalog_filter.png',
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
        builder: (_) => const LoadingDialog());
    try {
      final cubit = context.read<CatalogCubit>();
      final finalCatalog = _wizardCatalog.copyWith(
        newName: _nameController.text,
        newDescription: _descriptionController.text,
        newEnvironment: getEnvironmentFromString(_environmentController.text),
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

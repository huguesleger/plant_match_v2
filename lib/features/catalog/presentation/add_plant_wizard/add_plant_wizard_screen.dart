import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_draft.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_pages.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_app_bar.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/loading_overlay.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';

class AddPlantWizardScreen extends StatefulWidget {
  const AddPlantWizardScreen({super.key, required this.catalog});
  final Catalog catalog;

  @override
  State<AddPlantWizardScreen> createState() => _AddPlantWizardScreenState();
}

class _AddPlantWizardScreenState extends State<AddPlantWizardScreen> {
  static const _lastPage = AddPlantWizardPages.count - 1;
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKeys = List.generate(
    AddPlantWizardPages.count,
    (_) => GlobalKey<FormBuilderState>(),
  );
  late AddPlantDraft _draft = AddPlantDraft(catalog: widget.catalog);
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AddPlantWizardAppBar(
          canGoBack: _page != 0,
          onBack: () => _goTo(_page - 1),
        ),
        body: SafeArea(
          child: AddPlantWizardPages(
            pageController: _pageController,
            page: _page,
            formKeys: _formKeys,
            nameController: _nameController,
            descriptionController: _descriptionController,
            draft: _draft,
            onDraftChanged: (draft) => setState(() => _draft = draft),
          ),
        ),
        bottomNavigationBar: BottomBar(
          child: ButtonRounded(
            text: _page == _lastPage
                ? t.catalog.wizard.finish
                : t.catalog.wizard.next,
            onPressed: Some(_onNextPressed),
            bgColor: AppColors.greenLight,
            textColor: AppColors.blueGreen,
          ),
        ),
      );

  void _goTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() => _page = page);
  }

  void _onNextPressed() {
    final valid = Option.fromNullable(_formKeys[_page].currentState)
        .match(() => false, (form) => form.saveAndValidate());
    if (!valid) return;
    _page < _lastPage ? _goTo(_page + 1) : _onSave();
  }

  Future<void> _onSave() async {
    final cubit = context.read<CatalogCubit>();
    LoadingOverlay.show(context);
    final result = await cubit
        .publishNewCatalog(_draft.toCatalog(
          name: _nameController.text,
          description: _descriptionController.text,
        ))
        .run();
    if (!mounted) return;
    Navigator.pop(context);
    result.match(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.catalog.wizard.error_generic(error: failure.message)),
      )),
      (_) => Navigator.pop(context, true),
    );
  }
}

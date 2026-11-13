import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/dialog/confirm_dialog.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_state.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/wizard_step.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/widgets/wizard_view.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';

class DetailWizardScreen extends StatelessWidget {
  const DetailWizardScreen({
    super.key,
    required this.profilUser,
    this.step = const None(),
  });

  final ProfilUser profilUser;
  final Option<WizardStep> step;

  @override
  Widget build(BuildContext context) {
    final profilCubit = context.read<ProfilCubit>();

    return BlocProvider(
      create: (_) => DetailWizardCubit(
        profilUser: profilUser,
        steps: step.match(() => WizardStep.all, (only) => [only]),
        saveProfilUser: profilCubit.saveProfilUser,
        updateLocation: profilCubit.updateLocation,
      ),
      child: BlocConsumer<DetailWizardCubit, DetailWizardState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _onStatusChanged,
        builder: (context, state) => PopScope(
          canPop: state.isFirstStep && !state.hasChanges && !state.isBusy,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _onBack(context, state);
          },
          child: WizardView(
            state: state,
            onClose: () => _close(context, state),
          ),
        ),
      ),
    );
  }

  void _onStatusChanged(BuildContext context, DetailWizardState state) {
    switch (state.status) {
      case WizardSaved():
        Navigator.pop(context);
      case WizardFailed(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.errorContent.message)),
        );
      case WizardEditing() || WizardSaving() || WizardLocating():
        break;
    }
  }

  void _onBack(BuildContext context, DetailWizardState state) {
    if (state.isBusy) return;
    state.isFirstStep
        ? _close(context, state)
        : context.read<DetailWizardCubit>().previous();
  }

  Future<void> _close(BuildContext context, DetailWizardState state) async {
    if (state.isBusy) return;
    final navigator = Navigator.of(context);
    final leave = !state.hasChanges ||
        await showConfirmDialog(
          context,
          title: t.personalInformation.wizard.leave.title,
          content: Text(t.personalInformation.wizard.leave.content),
          confirmLabel: t.personalInformation.wizard.leave.confirm,
          destructive: true,
        );
    if (leave) navigator.pop();
  }
}

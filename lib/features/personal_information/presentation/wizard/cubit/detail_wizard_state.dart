import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/wizard_step.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class WizardStatus {
  const WizardStatus();
}

final class WizardEditing extends WizardStatus {
  const WizardEditing();
}

final class WizardSaving extends WizardStatus {
  const WizardSaving();
}

final class WizardLocating extends WizardStatus {
  const WizardLocating();
}

final class WizardSaved extends WizardStatus {
  const WizardSaved();
}

final class WizardFailed extends WizardStatus {
  const WizardFailed(this.failure);

  final Failure failure;
}

final class DetailWizardState {
  const DetailWizardState({
    required this.initial,
    required this.draft,
    required this.steps,
    required this.stepIndex,
    required this.status,
  });

  final ProfilUser initial;
  final ProfilUser draft;
  final List<WizardStep> steps;
  final int stepIndex;
  final WizardStatus status;

  WizardStep get currentStep => steps[stepIndex];

  bool get isFirstStep => stepIndex == 0;

  bool get isLastStep => stepIndex == steps.length - 1;

  bool get isSingleStep => steps.length == 1;

  bool get isBusy => switch (status) {
        WizardSaving() || WizardLocating() => true,
        WizardEditing() || WizardSaved() || WizardFailed() => false,
      };

  bool get hasChanges =>
      draft.userName != initial.userName ||
      draft.birthdayDate != initial.birthdayDate ||
      draft.bio != initial.bio;

  DetailWizardState copyWith({
    Option<ProfilUser> initial = const None(),
    Option<ProfilUser> draft = const None(),
    Option<int> stepIndex = const None(),
    Option<WizardStatus> status = const None(),
  }) =>
      DetailWizardState(
        initial: initial.getOrElse(() => this.initial),
        draft: draft.getOrElse(() => this.draft),
        steps: steps,
        stepIndex: stepIndex.getOrElse(() => this.stepIndex),
        status: status.getOrElse(() => this.status),
      );
}

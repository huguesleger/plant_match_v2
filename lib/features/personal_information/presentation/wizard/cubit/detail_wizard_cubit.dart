import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_state.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/wizard_step.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class DetailWizardCubit extends SafeCubit<DetailWizardState> {
  DetailWizardCubit({
    required ProfilUser profilUser,
    required List<WizardStep> steps,
    required this.saveProfilUser,
    required this.updateLocation,
  }) : super(DetailWizardState(
          initial: profilUser,
          draft: profilUser,
          steps: steps,
          stepIndex: 0,
          status: const WizardEditing(),
        ));

  final TaskEither<Failure, Unit> Function(ProfilUser) saveProfilUser;
  final TaskEither<Failure, ProfilUser> Function(String uid) updateLocation;

  void updatePseudo(String value) =>
      _edit(state.draft.copyWith(newUserName: Some(_nonEmpty(value))));

  void updateBirthday(Option<DateTime> value) =>
      _edit(state.draft.copyWith(newBirthdayDate: Some(value)));

  void updateBio(String value) =>
      _edit(state.draft.copyWith(newBio: Some(_nonEmpty(value))));

  void next() => state.isLastStep ? finish() : _goTo(state.stepIndex + 1);

  void previous() =>
      Option.of(state.stepIndex - 1).filter((index) => index >= 0).map(_goTo);

  void skip() {
    _edit(_resetCurrentStep());
    next();
  }

  void finish() => state.hasChanges
      ? _save()
      : emit(state.copyWith(status: const Some(WizardSaved())));

  void locate() {
    emit(state.copyWith(status: const Some(WizardLocating())));
    updateLocation(state.draft.uid)
        .match(
          (failure) => state.copyWith(status: Some(WizardFailed(failure))),
          (located) => state.copyWith(
            initial: Some(_withLocation(state.initial, located)),
            draft: Some(_withLocation(state.draft, located)),
            status: const Some(WizardEditing()),
          ),
        )
        .map(emit)
        .run();
  }

  void _save() {
    emit(state.copyWith(status: const Some(WizardSaving())));
    saveProfilUser(state.draft)
        .match(
          (failure) => state.copyWith(status: Some(WizardFailed(failure))),
          (_) => state.copyWith(status: const Some(WizardSaved())),
        )
        .map(emit)
        .run();
  }

  void _edit(ProfilUser draft) => emit(state.copyWith(
        draft: Some(draft),
        status: const Some(WizardEditing()),
      ));

  void _goTo(int index) => emit(state.copyWith(
        stepIndex: Some(index),
        status: const Some(WizardEditing()),
      ));

  ProfilUser _resetCurrentStep() => switch (state.currentStep) {
        WizardStepPseudo() =>
          state.draft.copyWith(newUserName: Some(state.initial.userName)),
        WizardStepBirthday() => state.draft
            .copyWith(newBirthdayDate: Some(state.initial.birthdayDate)),
        WizardStepBio() =>
          state.draft.copyWith(newBio: Some(state.initial.bio)),
        WizardStepLocation() => state.draft,
      };

  ProfilUser _withLocation(ProfilUser user, ProfilUser located) =>
      user.copyWith(
        newLocalisation: Some(located.localisation),
        newZipCode: Some(located.zipCode),
        newCountry: Some(located.country),
        newLatitude: Some(located.latitude),
        newLongitude: Some(located.longitude),
      );

  Option<String> _nonEmpty(String text) =>
      Option.of(text.trim()).filter((value) => value.isNotEmpty);
}

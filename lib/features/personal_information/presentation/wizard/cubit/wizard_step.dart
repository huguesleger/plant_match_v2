sealed class WizardStep {
  const WizardStep();

  static const all = <WizardStep>[
    WizardStepPseudo(),
    WizardStepBirthday(),
    WizardStepBio(),
    WizardStepLocation(),
  ];
}

final class WizardStepPseudo extends WizardStep {
  const WizardStepPseudo();
}

final class WizardStepBirthday extends WizardStep {
  const WizardStepBirthday();
}

final class WizardStepBio extends WizardStep {
  const WizardStepBio();
}

final class WizardStepLocation extends WizardStep {
  const WizardStepLocation();
}

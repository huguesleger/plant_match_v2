sealed class PasswordStatus {
  const PasswordStatus();
}

class PasswordSet extends PasswordStatus {
  const PasswordSet();
}

class PasswordMissing extends PasswordStatus {
  const PasswordMissing(this.email);

  final String email;
}

class PasswordUnavailable extends PasswordStatus {
  const PasswordUnavailable();
}

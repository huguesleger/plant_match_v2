sealed class NotificationPromptState {
  const NotificationPromptState();
}

class NotificationPromptIdle extends NotificationPromptState {
  const NotificationPromptIdle();
}

class NotificationPromptChecking extends NotificationPromptState {
  const NotificationPromptChecking();
}

class NotificationPromptVisible extends NotificationPromptState {
  const NotificationPromptVisible();
}

class NotificationPromptAwaitingSettings extends NotificationPromptState {
  const NotificationPromptAwaitingSettings();
}

class NotificationPromptDone extends NotificationPromptState {
  const NotificationPromptDone();
}

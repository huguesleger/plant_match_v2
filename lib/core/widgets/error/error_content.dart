import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';

sealed class ErrorAction {
  const ErrorAction();
}

class RetryAction extends ErrorAction {
  const RetryAction();
}

class ReconnectAction extends ErrorAction {
  const ReconnectAction();
}

class NoAction extends ErrorAction {
  const NoAction();
}

class ErrorContent {
  const ErrorContent({
    required this.title,
    required this.message,
    required this.action,
  });

  final String title;
  final String message;
  final ErrorAction action;
}

extension FailureErrorContent on Failure {
  ErrorContent get errorContent => switch (this) {
        NetworkFailure() => ErrorContent(
            title: t.widgets.error.network.title,
            message: t.widgets.error.network.message,
            action: const RetryAction(),
          ),
        ServerFailure() => ErrorContent(
            title: t.widgets.error.server.title,
            message: t.widgets.error.server.message,
            action: const RetryAction(),
          ),
        PermissionFailure() => ErrorContent(
            title: t.widgets.error.permission.title,
            message: t.widgets.error.permission.message,
            action: const NoAction(),
          ),
        SessionExpiredFailure() => ErrorContent(
            title: t.widgets.error.session.title,
            message: t.widgets.error.session.message,
            action: const ReconnectAction(),
          ),
        AuthInvalidCredentialsFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.invalidCredentials,
            action: const NoAction(),
          ),
        AuthInvalidEmailFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.invalidEmail,
            action: const NoAction(),
          ),
        AuthUserDisabledFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.userDisabled,
            action: const NoAction(),
          ),
        AuthEmailAlreadyInUseFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.emailAlreadyInUse,
            action: const NoAction(),
          ),
        AuthAccountExistsWithDifferentCredentialFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.accountExistsWithDifferentCredential,
            action: const NoAction(),
          ),
        AuthWeakPasswordFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.weakPassword,
            action: const NoAction(),
          ),
        AuthTooManyRequestsFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.tooManyRequests,
            action: const NoAction(),
          ),
        AuthCancelledFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.cancelled,
            action: const RetryAction(),
          ),
        AuthProviderFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.provider,
            action: const RetryAction(),
          ),
        AuthEmailAlreadyVerifiedFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.emailAlreadyVerified,
            action: const NoAction(),
          ),
        AuthEmailNotVerifiedFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.emailNotVerified,
            action: const RetryAction(),
          ),
        AuthProfileMissingFailure() => ErrorContent(
            title: t.widgets.error.auth.title,
            message: t.widgets.error.auth.profileMissing,
            action: const NoAction(),
          ),
        NotFoundFailure() => ErrorContent(
            title: t.widgets.error.notFound.title,
            message: t.widgets.error.notFound.message,
            action: const NoAction(),
          ),
        LocationServiceDisabledFailure() => ErrorContent(
            title: t.widgets.error.location.title,
            message: t.widgets.error.location.disabled,
            action: const RetryAction(),
          ),
        LocationPermissionDeniedFailure() => ErrorContent(
            title: t.widgets.error.location.title,
            message: t.widgets.error.location.denied,
            action: const RetryAction(),
          ),
        LocationUnavailableFailure() => ErrorContent(
            title: t.widgets.error.location.title,
            message: t.widgets.error.location.unavailable,
            action: const RetryAction(),
          ),
        ValidationFailure(:final userMessage) => ErrorContent(
            title: t.widgets.error.validation.title,
            message: userMessage,
            action: const NoAction(),
          ),
        UnexpectedFailure() => ErrorContent(
            title: t.widgets.error.unexpected.title,
            message: t.widgets.error.unexpected.message,
            action: const RetryAction(),
          ),
      };
}

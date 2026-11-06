import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:plant_match_v2/core/failures/failure.dart';

Failure mapError(Object error) => switch (error) {
      Failure() => error,
      SocketException() || TimeoutException() => NetworkFailure('$error'),
      FirebaseException(:final code) => _mapFirebaseCode(code, '$error'),
      Object() => UnexpectedFailure('$error'),
    };

Failure _mapFirebaseCode(String code, String message) => switch (code) {
      'unavailable' ||
      'deadline-exceeded' ||
      'network-request-failed' =>
        NetworkFailure(message),
      'permission-denied' || 'unauthorized' => PermissionFailure(message),
      'unauthenticated' ||
      'user-token-expired' ||
      'requires-recent-login' =>
        SessionExpiredFailure(message),
      'not-found' || 'object-not-found' => NotFoundFailure(message),
      'internal' ||
      'resource-exhausted' ||
      'aborted' ||
      'data-loss' ||
      'unknown' =>
        ServerFailure(message),
      _ => UnexpectedFailure(message),
    };

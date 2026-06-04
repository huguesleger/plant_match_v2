import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/notifications/domain/repositories/notification_repository.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_state.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockRepository;
  late NotificationCubit cubit;

  setUp(() {
    mockRepository = MockNotificationRepository();
    cubit = NotificationCubit(notificationRepository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('NotificationCubit initialize', () {
    blocTest<NotificationCubit, NotificationState>(
      'emits state with errors when local notifications initialization fails',
      build: () {
        when(() => mockRepository.initializeLocalNotifications())
            .thenReturn(TaskEither.left(const UnexpectedFailure('Init error')));
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const NotificationError('Init error'),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'does not emit error when local notifications initialization succeeds',
      build: () {
        when(() => mockRepository.initializeLocalNotifications())
            .thenReturn(TaskEither.right(unit));
        when(() => mockRepository.onNotificationReceived)
            .thenAnswer((_) => const Stream.empty());
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [],
    );
  });

  group('requestPermissionAndSaveToken', () {
    blocTest<NotificationCubit, NotificationState>(
      'emits NotificationPermissionDenied when permission is not granted',
      build: () {
        when(() => mockRepository.requestPermission())
            .thenReturn(TaskEither.right(false));
        return cubit;
      },
      act: (cubit) => cubit.requestPermissionAndSaveToken('user_id'),
      expect: () => [
        const NotificationPermissionDenied(),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'emits NotificationPermissionGranted when permission is granted and token is saved successfully',
      build: () {
        when(() => mockRepository.requestPermission())
            .thenReturn(TaskEither.right(true));
        when(() => mockRepository.getFCMToken())
            .thenReturn(TaskEither.right(const Some('fcm_token_123')));
        when(() => mockRepository.saveTokenToUser('user_id', 'fcm_token_123'))
            .thenReturn(TaskEither.right(unit));
        return cubit;
      },
      act: (cubit) => cubit.requestPermissionAndSaveToken('user_id'),
      expect: () => [
        const NotificationPermissionGranted('fcm_token_123'),
      ],
    );

    blocTest<NotificationCubit, NotificationState>(
      'emits NotificationError when saveTokenToUser fails',
      build: () {
        when(() => mockRepository.requestPermission())
            .thenReturn(TaskEither.right(true));
        when(() => mockRepository.getFCMToken())
            .thenReturn(TaskEither.right(const Some('fcm_token_123')));
        when(() => mockRepository.saveTokenToUser('user_id', 'fcm_token_123'))
            .thenReturn(TaskEither.left(const FirebaseFailure('Save failed')));
        return cubit;
      },
      act: (cubit) => cubit.requestPermissionAndSaveToken('user_id'),
      expect: () => [
        const NotificationError('Save failed'),
      ],
    );
  });
}

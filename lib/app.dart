import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_theme.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/auth/data/firebase_auth_repository.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_page_route.dart';
import 'package:plant_match_v2/features/get_started/presentation/get_started_page_route.dart';
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/level_awarded_page_route.dart';
import 'package:plant_match_v2/features/notifications/data/datasources/fcm_remote_datasource.dart';
import 'package:plant_match_v2/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authRepository = FirebaseAuthRepository();
  final userPointsRepository = FirebaseUserPoints();
  final notificationRepository = NotificationRepositoryImpl(
    remoteDataSource: FcmRemoteDataSource(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(
            authRepository: authRepository,
            userPointsRepository: userPointsRepository,
          )..checkCurrentUser(),
        ),
        BlocProvider(
          create: (context) =>
              UserPointsCubit(repository: userPointsRepository),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(
            notificationRepository: notificationRepository,
          )..initialize(),
        ),
      ],
      child: const _MyAppBody(),
    );
  }
}

class _MyAppBody extends StatefulWidget {
  const _MyAppBody();

  @override
  State<_MyAppBody> createState() => _MyAppBodyState();
}

class _MyAppBodyState extends State<_MyAppBody> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      _setUserOffline();
    }
  }

  Future<void> _setUserOffline() async {
    try {
      final userId = context.read<AuthCubit>().userId;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'isOnline': false,
        });
      }
    } catch (e) {
      debugPrint("Erreur lors de la mise hors ligne automatique : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Match',
      theme: AppTheme.defaultTheme,
      color: AppTheme.defaultTheme.primaryColor,
      locale: TranslationProvider.of(context).locale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, authState) {
              if (authState is Authenticated) {
                context.read<NotificationCubit>().requestPermissionAndSaveToken(authState.user.uid);
                if (authState.isFirstTime) {
                  context.read<UserPointsCubit>().addUserPoints(
                        authState.user.uid,
                        25,
                        1,
                        isFromRegistration: true,
                      );
                }
              }
            },
          ),
          BlocListener<UserPointsCubit, UserPointsState>(
            listener: (context, pointsState) {
              if (pointsState is UserPointsAwarded && pointsState.points > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LevelAwardedPageRoute(
                      userId: pointsState.userId,
                      userPoints: pointsState.userPoints,
                      isFromRegistration: pointsState.isFromRegistration,
                    ),
                    fullscreenDialog: true,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            return Scaffold(
              body: switch (authState) {
                AuthInitial() || AuthLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                Authenticated() => const TemplatePage(),
                Unauthenticated() => const GetStartedPageRoute(),
                AuthError() => ErrorPage(
                    errorMessage: authState.message,
                    onRetry: () {
                      context.read<AuthCubit>().checkCurrentUser();
                    },
                  ),
                AuthEmailVerificationSent(user: var u) ||
                AuthFinalizing(user: var u) =>
                  EmailVerificationPageRoute(user: u),
              },
            );
          },
        ),
      ),
    );
  }
}

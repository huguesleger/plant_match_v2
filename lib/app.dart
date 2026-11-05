import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_theme.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/auth/data/firebase_auth_repository.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_page_route.dart';
import 'package:plant_match_v2/features/get_started/presentation/get_started_page_route.dart';
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/reward_listener.dart';
import 'package:plant_match_v2/features/notifications/data/datasources/fcm_remote_datasource.dart';
import 'package:plant_match_v2/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:plant_match_v2/features/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';
import 'package:plant_match_v2/core/services/location/location_service.dart';

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
        BlocProvider(
          create: (context) => ProfilCubit(
            profilRepository: FirebaseProfilRepo(),
            storageRepository: FirebaseStorageRepository(),
            locationService: LocationServiceImpl(),
          ),
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
  void didChangeAppLifecycleState(AppLifecycleState state) => switch (state) {
        AppLifecycleState.resumed => _setUserOnline(true),
        AppLifecycleState.paused ||
        AppLifecycleState.detached =>
          _setUserOnline(false),
        AppLifecycleState.inactive ||
        AppLifecycleState.hidden =>
          Future<void>.value(),
      };

  Future<void> _setUserOnline(bool isOnline) async {
    try {
      await context.read<AuthCubit>().userId.match(
            () => Future<void>.value(),
            (userId) => FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({
              'isOnline': isOnline,
            }),
          );
    } catch (e) {
      debugPrint("Erreur lors de la mise à jour du statut en ligne : $e");
    }
  }

  void _resetUserSession(BuildContext context) {
    context.read<ProfilCubit>().reset();
    context.read<UserPointsCubit>().reset();
    DistanceHelper.maxDistance = 15.0;
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
            listenWhen: (previous, current) => previous is! AuthError,
            listener: (context, authState) {
              if (authState is Unauthenticated) {
                _resetUserSession(context);
              }
              if (authState is Authenticated) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                context
                    .read<NotificationCubit>()
                    .requestPermissionAndSaveToken(authState.user.uid);
                context.read<ProfilCubit>().getProfilUser(authState.user.uid);
                authState.isFirstTime
                    ? context
                        .read<UserPointsCubit>()
                        .addUserPoints(authState.user.uid, 0, 1)
                    : context
                        .read<UserPointsCubit>()
                        .fetchUserPoints(authState.user.uid);
              }
            },
          ),
        ],
        child: RewardListener(
          child: BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (previous, current) => current is! AuthError,
            builder: (context, authState) {
              return Scaffold(
                body: switch (authState) {
                  AuthInitial() || AuthLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  Authenticated() => const TemplatePage(),
                  Unauthenticated() ||
                  AuthError() =>
                    const GetStartedPageRoute(),
                  AuthEmailVerificationSent(user: var u) ||
                  AuthFinalizing(user: var u) =>
                    EmailVerificationPageRoute(user: u),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

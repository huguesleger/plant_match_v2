import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plant_match_v2/core/theme/app_theme.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/auth/data/firebase_auth_repository.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_page_route.dart';
import 'package:plant_match_v2/features/get_started/presentation/get_started_page.dart';
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';
import 'package:plant_match_v2/features/level/presentation/level_awarded_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final authRepository = FirebaseAuthRepository();
  final userPointsRepository = FirebaseUserPoints();

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
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
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
      ],
      child: MaterialApp(
        title: 'Plant Match',
        theme: AppTheme.defaultTheme,
        color: AppTheme.defaultTheme.primaryColor,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr')],
        home: MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(
              listener: (context, authState) {
                if (authState is Authenticated && authState.isFirstTime) {
                  context.read<UserPointsCubit>().addUserPoints(
                        authState.user.uid,
                        25,
                        1,
                        isFromRegistration: true,
                      );
                }
              },
            ),
            BlocListener<UserPointsCubit, UserPointsState>(
              listener: (context, pointsState) {
                if (pointsState is UserPointsAwarded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelAwardedScreen(
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
                  Unauthenticated() => const GetStartedPage(),
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
      ),
    );
  }
}

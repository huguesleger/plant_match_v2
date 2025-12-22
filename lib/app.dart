import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plant_match_v2/core/theme/app_theme.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/around_me_map/data/firebase_around_me.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/auth/data/firebase_auth_service.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/features/auth/presentation/email_verification/email_verification_page.dart';
import 'package:plant_match_v2/features/catolog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/get_started/presentation/get_started_page.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/unread_messages_cubit.dart';
import 'package:plant_match_v2/features/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';
import 'package:plant_match_v2/features/user/data/firebase_user.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user_points/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/user_points/presentation/cubit/user_points_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final authRepository = FirebaseAuthService();
  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();
  final userPointsRepository = FirebaseUserPoints();
  final aroundMeRepository = FirebaseAroundMe();
  final catalogRepository = FirebaseCatalogRepository();
  final userRepository = FirebaseUser();
  final chatPlantRepository = FirebaseChatPlant();

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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'isOnline': false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(
              authRepository: authRepository,
              userPointsRepository: userPointsRepository)
            ..checkCurrentUser(),
        ),
        BlocProvider(
          create: (context) => ProfilCubit(
            profilRepository: profilRepository,
            storageRepository: storageRepository,
          ),
        ),
        BlocProvider(
          create: (context) =>
              UserPointsCubit(repository: userPointsRepository),
        ),
        BlocProvider(
          create: (context) => AroundMeCubit(
            aroundMeRepository: aroundMeRepository,
            profilRepository: profilRepository,
            catalogRepository: catalogRepository,
          ),
        ),
        BlocProvider(
          create: (context) => UserCubit(
            userRepository: userRepository,
            catalogRepository: catalogRepository,
            userPointsRepository: userPointsRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CatalogCubit(
            catalogRepository: catalogRepository,
            storageRepository: storageRepository,
          ),
        ),
        BlocProvider(
          create: (_) => UnreadMessagesCubit(
            repository: chatPlantRepository,
          )..listen(user!.uid),
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
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            return Scaffold(
              body: switch (authState) {
                AuthInitial() || AuthLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                Authenticated() => const TemplatePage(),
                Unauthenticated() => const GetStartedPage(),
                AuthError() => ErrorPage(errorMessage: authState.message),
                AuthEmailVerificationSent() =>
                  EmailVerificationPage(user: authState.user),
              },
            );
          },
        ),
      ),
    );
  }
}

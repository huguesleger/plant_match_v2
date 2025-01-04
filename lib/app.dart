import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plant_match_v2/core/theme/app_theme.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/presentation/auth/data/firebase_auth_service.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/presentation/get_started/presentation/get_started_page.dart';

import 'presentation/profil/data/firebase_profil_repo.dart';
import 'presentation/profil/presentation/cubit/profil_cubit.dart';
import 'presentation/storage/data/firebase_storage_repository.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepository = FirebaseAuthService();
  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepository: authRepository)..checkCurrentUser(),
        ),
        BlocProvider(
          create: (context) => ProfilCubit(
            profilRepository: profilRepository,
            storageRepository: storageRepository,
          ),
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
            print(authState);
            return Scaffold(
              body: switch (authState) {
                AuthInitial() || AuthLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                Authenticated() => const TemplatePage(),
                Unauthenticated() => const GetStartedPage(),
                AuthError() => ErrorPage(errorMessage: authState.message),
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_dynamic_header.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/auth/data/firebase_auth_service.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/presentation/auth/presentation/sign_in/presentation/form_sign_in.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key, required this.toggleSignInOrRegister});

  final void Function() toggleSignInOrRegister;
  final authRepository = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is Authenticated) {
          print('sign in page');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TemplatePage(),
            ),
          );
        }
        if (authState is AuthError) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(errorMessage: authState.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: SizedBox(
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return Scaffold(
          body: AppBarDynamicHeader(
            height: MediaQuery.of(context).size.height > 700 ? 345 : 250,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: AppColors.white,
              ),
              icon: const Icon(LucideIcons.chevron_left,
                  color: AppColors.greyDark),
            ),
            titlePadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height > 700 ? 140 : 70,
                top: 50),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: TitlePage(
                        title: 'Hey! Bienvenue',
                      ),
                    ),
                    FormSignIn(toggleSignInOrRegister: toggleSignInOrRegister),
                  ],
                ),
              ),
            ),
            backgroundAppBar: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/auth/login.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

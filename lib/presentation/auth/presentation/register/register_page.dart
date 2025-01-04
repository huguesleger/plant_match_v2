import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/presentation/auth/presentation/register/form_register.dart';
import 'package:plant_match_v2/presentation/home/presentation/home_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
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
          appBar: AppBarTemplate(
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            styleIconButton: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(color: AppColors.greyLight),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          body: const SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TitlePage(
                      title: 'Créer un compte',
                    ),
                  ),
                  SizedBox(height: 50),
                  FormRegister(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

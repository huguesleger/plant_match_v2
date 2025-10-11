import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/sign_in/presentation/sign_in_page.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();

  bool showSignIn = true;

  void toggleSignInOrRegister() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  void onPressed() async {
    final String email = _emailController.text;
    final authCubit = context.read<AuthCubit>();

    try {
      await authCubit.sendPasswordResetEmail(email: email);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  SignInPage(toggleSignInOrRegister: toggleSignInOrRegister)),
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              'Un e-mail de réinitialisation a été envoyé sur $email',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
    _formKey.currentState?.saveAndValidate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SvgPicture.asset('assets/logo/logo_color.svg'),
                ),
              ),
              const SizedBox(height: 20),
              const TitlePage(
                title: 'Mot de passe oublié ?',
                fontSize: AppTypo.textXl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                    'Entrez votre e-mail pour réinitialiser le mot de passe'),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height > 700 ? 45 : 25),
              SizedBox(
                height: MediaQuery.of(context).size.height > 700 ? 373 : 280,
                child: Image.asset('assets/images/auth/forgot_password.png'),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  SafeArea(
                    child: FormBuilder(
                      key: _formKey,
                      child: FormBuilderTextField(
                        name: 'email',
                        decoration: DecorationInput.inputDecoration(
                          hintText: 'Entrez votre e-mail',
                          labelText: 'E-mail',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Ce champ est requis'),
                          FormBuilderValidators.email(
                              errorText: 'Entrez un e-mail valide'),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonRounded(
                      text: 'Envoyer',
                      bgColor: AppColors.greenLight,
                      textColor: AppColors.blueGreen,
                      onPressed: onPressed,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonOutlinedRounded(
                      text: 'Retour',
                      borderColor: AppColors.greyLight,
                      textColor: AppColors.blueGreen,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

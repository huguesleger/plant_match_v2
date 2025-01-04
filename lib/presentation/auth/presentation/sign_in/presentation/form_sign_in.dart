import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/sign_in/presentation/sign_in_with_social.dart';

class FormSignIn extends StatefulWidget {
  const FormSignIn({super.key, required this.toggleSignInOrRegister});

  final void Function() toggleSignInOrRegister;

  @override
  State<FormSignIn> createState() => _FormSignInState();
}

class _FormSignInState extends State<FormSignIn> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  void onPressedSignIn() {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.signInWithEmailAndPassword(email: email, password: password);
    } else {
/*      toastification.show(
        context: context,
        title: const Text('Veuillez remplir tous les champs'),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        showProgressBar: false,
      );*/
    }
    _formKey.currentState?.saveAndValidate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'email',
            decoration: DecorationInput.inputDecoration(
              hintText: 'Entrez votre e-mail',
              labelText: 'E-mail',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _emailController,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
              FormBuilderValidators.email(errorText: 'Entrez un e-mail valide'),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          FormBuilderTextField(
            name: 'password',
            decoration: DecorationInput.inputDecoration(
              hintText: 'Entrez votre mot de passe',
              labelText: 'Mot de passe',
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? LucideIcons.eye : LucideIcons.eye_off,
                  color: AppColors.greyDark,
                ),
                onPressed: () {
                  setState(
                    () {
                      _isPasswordVisible = !_isPasswordVisible;
                    },
                  );
                },
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordController,
            obscureText: _isPasswordVisible,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Ce champ est requis'),
              FormBuilderValidators.password(
                  errorText: 'Entrez un mot de passe valide'),
            ]),
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                onPressedSignIn();
              },
              child: const Text("S'identifier"),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              /*              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage(),
              ),
            );*/
            },
            child: Center(
              child: RichText(
                text: const TextSpan(
                  text: 'Mot de passe oublié ?',
                  style: TextStyle(
                    color: AppColors.blueGreen,
                    decoration: TextDecoration.underline,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: RichText(
              text: TextSpan(
                text: 'Pas encore de compte ? ',
                style: const TextStyle(color: AppColors.greyDark, fontSize: 11),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        widget.toggleSignInOrRegister();
                      },
                    text: 'Créer un compte',
                    style: const TextStyle(
                        color: AppColors.blueGreen,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
          const SignInWithSocial(),
        ],
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/auth/presentation/register/cgu_checkbox_field.dart';
import 'package:plant_match_v2/presentation/auth/presentation/register/password_field.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isPasswordVisible = true;
  bool isChecked = false;

  void onPressedRegister() {
    final String fullName = _fullNameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String passwordConfirm = _passwordConfirmController.text;

    final authCubit = context.read<AuthCubit>();

    if (fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        passwordConfirm.isNotEmpty &&
        isChecked) {
      authCubit.registerWithEmailAndPassword(
          email: email, password: password, fullName: fullName);
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
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FormBuilderTextField(
              name: 'email',
              controller: _emailController,
              decoration: DecorationInput.inputDecoration(
                hintText: 'Entrez votre e-mail',
                labelText: 'E-mail',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Ce champ est requis'),
                FormBuilderValidators.email(
                    errorText: 'Entrez un e-mail valide'),
              ]),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FormBuilderTextField(
              name: 'fullName',
              decoration: DecorationInput.inputDecoration(
                hintText: 'Entrez votre prénom et nom',
                labelText: 'Prénom et nom',
              ),
              validator: FormBuilderValidators.required(
                  errorText: 'Ce champ est requis'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _fullNameController,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PasswordField(
              controller: _passwordController,
              obscureText: _isPasswordVisible,
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FormBuilderTextField(
              name: 'passwordConfirm',
              decoration: DecorationInput.inputDecoration(
                hintText: 'Entrez le mot de passe',
                labelText: 'Confirmez le mot de passe',
              ),
              controller: _passwordConfirmController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Ce champ est requis'),
                (val) {
                  if (val != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ]),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FormBuilderField<bool>(
              name: 'acceptTerms',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                (value) {
                  if (value == null || value == false) {
                    return 'Ce champ est requis';
                  }
                  return null;
                },
              ]),
              builder: (FormFieldState<bool?> field) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InputDecorator(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        errorText: isChecked == false ? field.errorText : null),
                    child: Transform(
                      transform: Matrix4.translationValues(-22, 0.0, 0.0),
                      child: CguCheckboxField(
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked = newValue ?? false;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton(
                onPressed: () {
                  onPressedRegister();
                },
                child: const Text("Créer un compte"),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: RichText(
              text: TextSpan(
                text: 'Vous avez déjà un compte ? ',
                style: const TextStyle(color: AppColors.greyDark, fontSize: 11),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    text: 'S\'identifier',
                    style: const TextStyle(
                        color: AppColors.blueGreen,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

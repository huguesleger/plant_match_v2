import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in/sign_in_page_route.dart';

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
      authCubit.sendPasswordResetEmail(email: email);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  SignInPageRoute(toggleSignInOrRegister: toggleSignInOrRegister)),
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              t.auth.forgotPassword.emailSent(email: email),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: AppSpacing.paddingHorizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Assets.res.logo.logoColor.svg(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TitlePage(
                        title: t.auth.forgotPassword.title,
                        fontSize: AppTypo.textXl,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Text(
                          t.auth.forgotPassword.description,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                        ),
                        child: Assets.res.images.auth.forgotPassword.image(
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          FormBuilder(
                            key: _formKey,
                            child: FormBuilderTextField(
                              name: 'email',
                              decoration: DecorationInput.inputDecoration(
                                hintText: t.auth.common.email.hint,
                                labelText: t.auth.common.email.label,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _emailController,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: t.auth.common.email.required),
                                FormBuilderValidators.email(
                                    errorText: t.auth.common.email.invalid),
                              ]),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ButtonRounded(
                              text: t.auth.forgotPassword.send,
                              bgColor: AppColors.greenLight,
                              textColor: AppColors.blueGreen,
                              onPressed: onPressed,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ButtonOutlinedRounded(
                              text: t.auth.common.back,
                              borderColor: AppColors.greyLight,
                              textColor: AppColors.blueGreen,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

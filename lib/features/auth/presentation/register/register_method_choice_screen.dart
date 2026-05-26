import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/register/register_page_route.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in/widgets/sign_in_with_social.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in_or_register.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_footer_links.dart';

class RegisterMethodChoiceScreen extends StatelessWidget {
  const RegisterMethodChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.black,
        leading: false,
        title: t.auth.register.title,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TitlePage(
                title: t.auth.register_choice.title,
                fontSize: AppTypo.textL,
              ),
              const SizedBox(height: 16),
              Text(t.auth.register_choice.description),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ButtonRoundedWithIcon(
                  bgColor: AppColors.greenLight,
                  textColor: AppColors.blueGreen,
                  iconAlignment: IconAlignment.start,
                  icon: const Icon(LucideIcons.mail),
                  text: t.auth.register_choice.email,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPageRoute(),
                      ),
                    );
                  },
                ),
              ),
              const FormBuilder(
                child: SignInWithSocial(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AuthFooterLinks(
            mainText: t.auth.register.alreadyHaveAccount,
            actionText: t.auth.register.signIn,
            onActionTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInOrRegister(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

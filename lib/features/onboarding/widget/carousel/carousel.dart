import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/features/auth/presentation/register/register_page_route.dart';
import 'package:plant_match_v2/features/auth/presentation/sign_in_or_register.dart';
import 'package:plant_match_v2/features/onboarding/widget/carousel/carousel_item.dart';
import 'package:plant_match_v2/features/onboarding/widget/carousel/dots.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _controller,
          children: [
            CarouselItem(
              title: t.onboarding.title_1,
              description: t.onboarding.description_1,
              image: Assets.res.images.onboarding.onboarding1.path,
            ),
            CarouselItem(
              title: t.onboarding.title_2,
              description: t.onboarding.description_2,
              image: Assets.res.images.onboarding.onboarding2.path,
            ),
            CarouselItem(
              title: t.onboarding.title_3,
              description: t.onboarding.description_3,
              image: Assets.res.images.onboarding.onboarding3.path,
            ),
            CarouselItem(
              title: t.onboarding.title_4,
              description: t.onboarding.description_4,
              image: Assets.res.images.onboarding.onboarding4.path,
            ),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInOrRegister(),
                  ),
                );
              },
              label: Text(t.onboarding.skip),
              iconAlignment: IconAlignment.end,
              icon: const Icon(LucideIcons.chevron_right,
                  color: AppColors.blueGreen),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 180,
          child: Center(
            child: Dots(controller: _controller),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Column(
            children: [
              Padding(
                padding: AppSpacing.paddingHorizontal,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPageRoute(),
                        ),
                      );
                    },
                    child: Text(t.onboarding.register),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: AppSpacing.paddingHorizontal,
                child: SizedBox(
                  width: double.infinity,
                  child: SizedBox(
                    width: double.infinity,
                    child: ButtonOutlinedRounded(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInOrRegister(),
                          ),
                        );
                      },
                      borderColor: AppColors.greyLight,
                      textColor: AppColors.blueGreen,
                      text: t.onboarding.login,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

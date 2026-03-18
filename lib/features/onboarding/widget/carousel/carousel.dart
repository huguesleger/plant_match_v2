import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
          children: const [
            CarouselItem(
              title: 'Catalogue de Plantes\nPersonnalisé',
              description:
                  'Créez et gérez votre propre collection de plantes. Ajoutez des photos, des descriptions, et recevez des rappels pour l’entretien de vos plantes.',
              image: 'assets/images/onboarding/onboarding_1.png',
            ),
            CarouselItem(
              title: 'Échange de Plantes\net Boutures',
              description:
                  'Découvrez et échangez des plantes ou boutures avec d\'autres passionnés près de chez vous. Utilisez la géolocalisation pour trouver facilement des échanges.',
              image: 'assets/images/onboarding/onboarding_2.png',
            ),
            CarouselItem(
              title: 'Messagerie\nIntégrée',
              description:
                  'Communiquez facilement avec d\'autres utilisateurs pour organiser des échanges de plantes, poser des questions, ou simplement partager des conseils.',
              image: 'assets/images/onboarding/onboarding_3.png',
            ),
            CarouselItem(
              title: 'Aide et Conseils\nCommunautaires',
              description:
                  'Posez des questions et obtenez des conseils personnalisés de la part de la communauté pour mieux prendre soin de vos plantes ou résoudre des problèmes.',
              image: 'assets/images/onboarding/onboarding_4.png',
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
              label: const Text('Passer'),
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
                    child: const Text('S\'enregistrer'),
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
                      text: 'S\'identifier',
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

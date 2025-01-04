import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/auth/presentation/register/register_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/sign_in_or_register.dart';
import 'package:plant_match_v2/presentation/onboarding/widget/carousel/carousel_item.dart';
import 'package:plant_match_v2/presentation/onboarding/widget/carousel/dots.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Dots(controller: _controller),
          PageView(
            controller: _controller,
            onPageChanged: (int page) {
              setState(() {
                _isLastPage = (page == 3);
              });
            },
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
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height > 700 ? 60 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        _isLastPage
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              )
                            : _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                      },
                      child: Text(_isLastPage ? 'S\'enregistrer' : 'Suivant'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _isLastPage
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInOrRegister(),
                                  ),
                                )
                              : _controller.jumpToPage(3);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.greyLight),
                        ),
                        child: Text(
                          _isLastPage ? 'S\'identifier' : 'Passer',
                          style: const TextStyle(color: AppColors.blueGreen),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

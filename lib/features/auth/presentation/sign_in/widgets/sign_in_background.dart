import 'package:flutter/material.dart';
import '../sign_in_screen.dart';

class SignInBackground extends StatelessWidget {
  const SignInBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    
    // Calcul de la progression t (1.0 = étendu, 0.0 = réduit)
    final t = settings == null 
        ? 1.0 
        : ((settings.currentExtent - settings.minExtent) /
            (settings.maxExtent - settings.minExtent))
                .clamp(0.0, 1.0);

    // Progression accélérée pour la courbe (la transition se termine à la moitié du scroll)
    final tCurve = (t * 2.0 - 1.0).clamp(0.0, 1.0);

    // La courbe varie de 60 à 0
    final curveHeight = 60.0 * tCurve;

    return ClipPath(
      clipper: BottomRoundedClipper(
        curveHeight: curveHeight,
        progress: tCurve,
      ),
      child: Image.asset(
        'assets/images/auth/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

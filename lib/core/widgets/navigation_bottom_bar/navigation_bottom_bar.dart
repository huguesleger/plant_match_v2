import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class NavigationBottomBar extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavigationBottomBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 15.0,
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.house),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.heart_handshake),
              label: 'Echanges',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.map_pin),
              label: 'A promixité',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.message_square_text),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              label: 'Mon profil',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedFontSize: AppTypo.textXxs,
          unselectedFontSize: AppTypo.textXxs,
          backgroundColor: AppColors.white,
        ),
      ),
    );
  }
}

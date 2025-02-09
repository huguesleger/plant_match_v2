import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/navigation_bottom_bar/navigation_bottom_bar.dart';
import 'package:plant_match_v2/presentation/around_me_map/presentation/around_me_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/home/presentation/home_page.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_page.dart';

class TemplatePage extends StatefulWidget {
  final int initialIndex;

  const TemplatePage({super.key, this.initialIndex = 0});

  @override
  TemplatePageState createState() => TemplatePageState();
}

class TemplatePageState extends State<TemplatePage> {
  late int _currentIndex;
  late final String uid;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex; // Initialise l'index avec le paramètre

    final user = context.read<AuthCubit>().currentUser;
    uid = user?.uid ?? '';

    _pages = [
      const HomePage(),
      const Center(child: Text('Search Page Content')),
      AroundMePage(uid: uid),
      const Center(child: Text('Message Page Content')),
      ProfilPage(uid: uid),
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBottomBar(
      body: _pages[_currentIndex], // Contenu spécifique de la page
      currentIndex: _currentIndex, // Index actuel
      onTap: _onPageChanged, // Callback pour changer de page
    );
  }
}

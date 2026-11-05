import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_screen.dart';

class ProfilPageRoute extends StatelessWidget {
  const ProfilPageRoute({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) => ProfilScreen(userId: uid);
}

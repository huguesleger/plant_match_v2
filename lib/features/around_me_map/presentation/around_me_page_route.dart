import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/around_me_screen.dart';

class AroundMePageRoute extends StatelessWidget {
  const AroundMePageRoute({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) => AroundMeScreen(uid: uid);
}

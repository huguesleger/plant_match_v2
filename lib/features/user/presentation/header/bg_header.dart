import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';

class BgHeader extends StatelessWidget {
  const BgHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.res.images.bgUserScreen.image(
      fit: BoxFit.cover,
    );
  }
}

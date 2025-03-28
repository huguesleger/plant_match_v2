import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/add_plant_wizard/add_plant_wizard_page.dart';
import 'package:plant_match_v2/presentation/catolog/widget/catalog_card_is_empty.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, required this.uid, required this.catalog});

  final String uid;
  final List<Catalog> catalog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHeaderImage(
        image: const Image(
          image: AssetImage('assets/images/header_catalog.jpg'),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddPlantWizardPage(userId: uid, catalog: catalog),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: AppColors.greenLight,
        child: const Icon(LucideIcons.plus, color: AppColors.blueGreen),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TitlePage(
                title: 'Mes plantes',
                subtitle: 'Mon catalague de plantes à partager',
              ),
            ),
            SizedBox(height: 90),
            Row(
              children: [
                Expanded(
                  child: CatalogCardIsEmpty(),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Ton catalogue est vide. Ajoute ta première plante pour commencer.',
            ),
          ],
        ),
      ),
    );
  }
}

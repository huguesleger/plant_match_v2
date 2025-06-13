import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/add_plant_wizard/add_plant_wizard_page.dart';
import 'package:plant_match_v2/presentation/catolog/widget/catalog_card_is_empty.dart';
import 'package:uuid/uuid.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({
    super.key,
    required this.uid,
    required this.catalogs,
  });

  final String uid;
  final List<Catalog> catalogs;

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
        onPressed: () async {
          const uuid = Uuid();
          final generatedId = uuid.v4();

          final newCatalog = Catalog(
            uid: '',
            userId: uid,
            name: '',
            image: '',
            description: '',
            environment: Environment.indoor,
            family: Family.aquatic,
            levelMaintenance: LevelMaintenance.medium,
            watering: Watering.little,
            lighting: Lighting.indirectLight,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPlantWizardPage(
                userId: uid,
                catalog: newCatalog,
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        backgroundColor: AppColors.greenLight,
        child: const Icon(LucideIcons.plus, color: AppColors.blueGreen),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: catalogs.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TitlePage(
                      title: 'Mes plantes',
                      subtitle: 'Mon catalogue de plantes à partager',
                    ),
                  ),
                  SizedBox(height: 90),
                  Row(
                    children: [
                      Expanded(child: CatalogCardIsEmpty()),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Ton catalogue est vide. Ajoute ta première plante pour commencer.',
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TitlePage(
                      title: 'Mes plantes',
                      subtitle: 'Mon catalogue de plantes à partager',
                    ),
                  ),
                  const SizedBox(height: 20),
/*            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 20, bottom: 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: catalogs.length,
                itemBuilder: (context, index) {
                  final catalog = catalogs[index];
                  return CatalogCardItem(catalog: catalog);
                },
              ),
            ),*/
                ],
              ),
      ),
    );
  }
}

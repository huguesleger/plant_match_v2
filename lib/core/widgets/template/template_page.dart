import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/navigation_bottom_bar/navigation_bottom_bar.dart';
import 'package:plant_match_v2/features/catolog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/presentation/add_plant_wizard/add_plant_wizard_page.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/unread_exhange_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/around_me_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/home_page.dart';
import 'package:plant_match_v2/features/message/presentation/message_page.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/unread_messages_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_page.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';

// Index du bouton "Ajouter" dans la nav bar
const int _addButtonIndex = 2;

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

    _currentIndex = widget.initialIndex;

    final user = context.read<AuthCubit>().currentUser;
    uid = user?.uid ?? '';

    _pages = [
      const HomePage(),
      AroundMePage(uid: uid),
      const SizedBox.shrink(), // placeholder pour l'index "Ajouter"
      MessagesPage(),
      ProfilPage(uid: uid),
    ];

    context.read<UnreadMessagesCubit>().listen(uid);
    context.read<UnreadExchangesCubit>().listen(uid);
  }

  void _onPageChanged(int index) {
    if (index == _addButtonIndex) {
      _openAddPlantWizard();
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _openAddPlantWizard() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => CatalogCubit(
            catalogRepository: FirebaseCatalogRepository(),
            storageRepository: FirebaseStorageRepository(),
          ),
          child: AddPlantWizardPage(
            catalog: Catalog.empty(uid),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBottomBar(
      body: _pages[_currentIndex],
      currentIndex: _currentIndex,
      onTap: _onPageChanged,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/navigation_bottom_bar/navigation_bottom_bar.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_page_route.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/around_me_page_route.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/home_page_route.dart';
import 'package:plant_match_v2/features/message/presentation/message_page_route.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/unread_messages_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_page_route.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/unread_exhange_cubit.dart';
import 'package:plant_match_v2/features/donation/data/firebase_donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/unread_donation_cubit.dart';

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
  final chatRepository = FirebaseChatPlant();
  final exchangeRepository = FirebaseExchange();

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    final user = context.read<AuthCubit>().currentUser;
    uid = user?.uid ?? '';

    _pages = [
      const HomePageRoute(),
      AroundMePageRoute(uid: uid),
      const SizedBox.shrink(),
      MessagesPageRoute(),
      ProfilPageRoute(uid: uid),
    ];
  }

  void onPageChanged(int index) {
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
        builder: (_) => AddPlantWizardPageRoute(
          catalog: Catalog.empty(uid),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UnreadMessagesCubit(
            repository: chatRepository,
          )..listen(uid),
        ),
        BlocProvider(
          create: (_) => UnreadExchangesCubit(
            repository: exchangeRepository,
          )..listen(uid),
        ),
        BlocProvider(
          create: (_) => UnreadDonationsCubit(
            repository: FirebaseDonation(),
          )..listen(uid),
        ),
      ],
      child: NavigationBottomBar(
        body: _pages[_currentIndex],
        currentIndex: _currentIndex,
        onTap: onPageChanged,
      ),
    );
  }
}

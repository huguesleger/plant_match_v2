import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/user/data/firebase_user.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/user_screen.dart';

class UserPageRoute extends StatelessWidget {
  UserPageRoute({super.key, required this.uid});

  final userRepository = FirebaseUser();
  final catalogRepository = FirebaseCatalogRepository();
  final userPointsRepository = FirebaseUserPoints();
  final exchangeRepository = FirebaseExchange();
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(
        userRepository: userRepository,
        catalogRepository: catalogRepository,
        userPointsRepository: userPointsRepository,
        exchangeRepository: exchangeRepository,
      )..fetchUser(uid),
      child: UserScreen(uid: uid),
    );
  }
}

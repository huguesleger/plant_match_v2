import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/donation/data/firebase_donation.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_cubit.dart';
import 'package:plant_match_v2/features/history/presentation/history_screen.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class HistoryPageRoute extends StatelessWidget {
  const HistoryPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().userId ?? '';

    return BlocProvider(
      create: (context) => HistoryCubit(
        exchangeRepository: FirebaseExchange(),
        donationRepository: FirebaseDonation(),
        userId: currentUserId,
      )..load(),
      child: HistoryScreen(currentUserId: currentUserId),
    );
  }
}

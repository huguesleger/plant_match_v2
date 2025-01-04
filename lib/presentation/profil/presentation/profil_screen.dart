import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/presentation/profil/presentation/widget/profil_header.dart';
import 'package:plant_match_v2/presentation/profil/presentation/widget/profil_list_card.dart';
import 'package:plant_match_v2/presentation/profil/presentation/widget/profil_list_item_category/profil_list_item_category.dart';
import 'package:plant_match_v2/presentation/storage/data/firebase_storage_repository.dart';

class ProfilScreen extends StatelessWidget {
  ProfilScreen({super.key, required this.profilUser, required this.userId});

  final ProfilUser profilUser;
  final String userId;
  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilCubit(
          profilRepository: profilRepository,
          storageRepository: storageRepository)
        ..getProfilUser(userId),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfilCubit, ProfilState>(
            builder: (context, state) {
              if (state is ProfilLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfilLoaded) {
                final profilUser = state.profilUser;
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ProfilHeader(profilUser: profilUser),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      height: 216,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ProfilListCard(),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: AppColors.greyUltraLight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          child: ProfilListItemCategory(profilUser: profilUser),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is ProfilError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}

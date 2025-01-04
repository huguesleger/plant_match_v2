import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/presentation/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/presentation/profil_personal_detail/profil_personal_detail_page.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/presentation/profil_personal_name_and_email/profil_personal_name_and_email.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/presentation/profil_personal_upload_avatar/profil_personal_upload_avatar.dart';
import 'package:plant_match_v2/presentation/storage/data/firebase_storage_repository.dart';

class ProfilPersonalInformationPage extends StatelessWidget {
  ProfilPersonalInformationPage(
      {super.key, required this.profilUser, required this.userId});

  final String userId;

  final ProfilUser profilUser;
  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Informations personnelles',
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyLight),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (buildContext) => BlocProvider.value(
                value: BlocProvider.of<ProfilCubit>(buildContext),
                child: const TemplatePage(
                  initialIndex: 4,
                ),
              ),
            ),
          );
        },
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ProfilCubit(
              profilRepository: profilRepository,
              storageRepository: storageRepository)
            ..getProfilUser(userId),
          child: BlocBuilder<ProfilCubit, ProfilState>(
            builder: (context, state) {
              return Column(
                children: [
                  switch (state) {
                    ProfilLoading() || ProfilInitial() => const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ProfilLoaded() => Expanded(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                ProfilPersonalUploadAvatar(
                                    profilUser: state.profilUser),
                                ProfilPersonalNameAndEmail(
                                    profilUser: state.profilUser),
                                const SizedBox(height: 30),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: ProfilPersonalDetailPage(
                                      profilUser: state.profilUser),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ProfilError() => ErrorPage(
                        errorMessage: state.message,
                      )
                  }
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

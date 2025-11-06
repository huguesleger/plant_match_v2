import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image_with_content.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/profil/data/firebase_profil_repo.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_personal_information/presentation/profil_personal_detail/profil_personal_detail_page.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_personal_information/presentation/profil_personal_name_and_email/profil_personal_name_and_email.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_personal_information/presentation/profil_personal_upload_avatar/profil_personal_upload_avatar.dart';
import 'package:plant_match_v2/features/storage/data/firebase_storage_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilPersonalInformationPage extends StatelessWidget {
  ProfilPersonalInformationPage({
    super.key,
    required this.userId,
    required this.profilUser,
  });

  final String userId;
  final ProfilUser profilUser;

  final profilRepository = FirebaseProfilRepo();
  final storageRepository = FirebaseStorageRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilCubit(
        profilRepository: profilRepository,
        storageRepository: storageRepository,
      )..getProfilUser(userId),
      child: BlocBuilder<ProfilCubit, ProfilState>(
        builder: (context, state) {
          final profilUserState = switch (state) {
            ProfilLoaded(:final profilUser) => profilUser,
            _ => profilUser,
          };

          return Scaffold(
            appBar: AppBarHeaderImageWithContent(
              headerHeight: 350,
              title: 'Informations personnelles',
              titleColor: AppColors.white,
              image: const Image(
                image: AssetImage('assets/images/bg_header_profil.jpg'),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (buildContext) => BlocProvider.value(
                      value: BlocProvider.of<ProfilCubit>(buildContext),
                      child: const TemplatePage(initialIndex: 4),
                    ),
                  ),
                );
              },
              styleIconButton: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColors.white,
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      switch (state) {
                        ProfilInitial() || ProfilLoading() => Column(
                            children: [
                              ProfilPersonalUploadAvatar(
                                profilUser: profilUserState,
                              ),
                              ProfilPersonalNameAndEmail(
                                profilUser: profilUserState,
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ProfilImageUploading() => Column(
                            children: [
                              const Skeletonizer(
                                enabled: true,
                                child: Bone.circle(size: 120),
                              ),
                              ProfilPersonalNameAndEmail(
                                profilUser: profilUser,
                              ),
                            ],
                          ),
                        ProfilLoaded() => Column(
                            children: [
                              ProfilPersonalUploadAvatar(
                                profilUser: profilUserState,
                              ),
                              ProfilPersonalNameAndEmail(
                                profilUser: profilUserState,
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ProfilError(:final message) => ErrorPage(
                            errorMessage: message,
                          ),
                      },
                    ],
                  ),
                ),
              ),
            ),
            body: switch (state) {
              ProfilInitial() || ProfilLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              ProfilError(:final message) => ErrorPage(errorMessage: message),
              _ => SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: AppSpacing.paddingHorizontal,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ProfilPersonalDetailPage(
                            profilUser: profilUserState,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            },
          );
        },
      ),
    );
  }
}

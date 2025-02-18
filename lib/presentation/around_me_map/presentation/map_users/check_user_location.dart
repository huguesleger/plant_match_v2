import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/presentation/around_me_map/presentation/map_users/map_users.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_personal_information/widget/profil_personal_detail_location.dart';

class CheckUserLocation extends StatelessWidget {
  const CheckUserLocation({
    super.key,
    required this.currentUser,
    required this.users,
  });

  final ProfilUser currentUser;
  final List<ProfilUser> users;

  @override
  Widget build(BuildContext context) {
    final bool hasValidLocation = currentUser.latitude != null &&
        currentUser.longitude != null &&
        currentUser.latitude != 0 &&
        currentUser.longitude != 0;

    return hasValidLocation
        ? _MapView(users: users, currentUser: currentUser)
        : _NoLocation(currentUser);
  }
}

class _MapView extends StatelessWidget {
  const _MapView({required this.users, required this.currentUser});

  final List<ProfilUser> users;
  final ProfilUser currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TitlePage(
            title: 'A proximité',
            fontSize: AppTypo.textXl,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
              'Trouvez des utilisateurs autour de vous pour partager, échanger ...'),
        ),
        Expanded(
          child: MapUsers(users: users, currentUser: currentUser),
        ),
      ],
    );
  }
}

class _NoLocation extends StatelessWidget {
  const _NoLocation(this.profilUser);

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const TitlePage(
            title: 'Oups ! vous n\'êtes pas localisé',
            fontSize: AppTypo.textXl,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text(
                'Veuillez activer votre localisation pour voir les utilisateurs autour de vous',
                textAlign: TextAlign.center),
          ),
          SizedBox(height: MediaQuery.of(context).size.height > 700 ? 45 : 25),
          SizedBox(
            height: MediaQuery.of(context).size.height > 700 ? 373 : 280,
            child: Image.asset('assets/images/illu_location.png'),
          ),
          SizedBox(height: MediaQuery.of(context).size.height > 700 ? 45 : 25),
          SizedBox(
            width: double.infinity,
            child: ButtonRounded(
              onPressed: () async {
                await _updateLocationAndSave(context, profilUser);
              },
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
              text: 'Me géolocaliser',
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _updateLocationAndSave(
    BuildContext context, ProfilUser profilUser) async {
  try {
    currentPosition = await getCurrentLocation();
    await getCurrentAddress();

    final updatedUser = profilUser.copyWith(
      newLocalisation: currentAddress,
      newCountry: currentCountry,
      newLatitude: currentLatitude,
      newLongitude: currentLongitude,
    );

    if (context.mounted) {
      final aroundMeCubit = context.read<AroundMeCubit>();
      aroundMeCubit.updateUserLocation(updatedUser);
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erreur lors de la mise à jour de la localisation')),
      );
    }
  }
}

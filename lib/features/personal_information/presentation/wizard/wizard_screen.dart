import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/level_awarded_page_route.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/widgets/wizard_view.dart';

class DetailWizardScreen extends StatefulWidget {
  const DetailWizardScreen({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  State<DetailWizardScreen> createState() => _DetailWizardScreenState();
}

class _DetailWizardScreenState extends State<DetailWizardScreen> {
  bool _isLocating = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfilCubit, ProfilState>(
      listener: (context, state) {
        if (state is ProfilLoaded && state.leavesGained > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LevelAwardedPageRoute(
                leavesGained: state.leavesGained,
                title: state.rewardMessage ?? 'Félicitations !',
                description: 'Vous venez d\'obtenir des feuilles bonus pour vos interactions.',
              ),
              fullscreenDialog: true,
            ),
          );
        }
        
        switch (state) {
          case ProfilLoaded() when _isLocating:
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          case ProfilError(:final message) when _isLocating:
            setState(() => _isLocating = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          default:
            break;
        }
      },
      child: Stack(
        children: [
          WizardView(
            profilUser: widget.profilUser,
            onLocatingChanged: (locating) =>
                setState(() => _isLocating = locating),
          ),
          BlocBuilder<ProfilCubit, ProfilState>(
            builder: (context, state) => switch (state) {
              ProfilLoading() when _isLocating => Container(
                  color: AppColors.black.withValues(alpha: 0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenLight,
                    ),
                  ),
                ),
              ProfilInitial() ||
              ProfilLoading() ||
              ProfilLoaded() ||
              ProfilError() ||
              ProfilImageUploading() =>
                const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

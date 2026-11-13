import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/wizard_step.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/wizard_screen.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';

Future<void> openDetailWizard(
  BuildContext context, {
  required ProfilUser profilUser,
  Option<WizardStep> step = const None(),
}) {
  final profilCubit = context.read<ProfilCubit>();

  return Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: profilCubit,
        child: DetailWizardScreen(profilUser: profilUser, step: step),
      ),
    ),
  );
}

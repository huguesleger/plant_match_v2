import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/utils/detail_plant_loader.dart';

sealed class DetailPlantState {
  const DetailPlantState();
}

class DetailPlantInitial extends DetailPlantState {
  const DetailPlantInitial();
}

class DetailPlantLoading extends DetailPlantState {
  final Catalog catalog;
  final DetailPlantData boneMock;

  DetailPlantLoading({required this.catalog})
      : boneMock = DetailPlantData(
          catalog: catalog,
          owner: ProfilUser.boneMock(),
          currentUser: const None(),
        );
}

class DetailPlantLoaded extends DetailPlantState {
  final DetailPlantData data;

  const DetailPlantLoaded({required this.data});
}

class DetailPlantError extends DetailPlantState {
  final Failure failure;

  const DetailPlantError(this.failure);
}

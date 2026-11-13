import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/task_either_minimal_delay/task_either_minimal_delay.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/core/widgets/skeleton/skeleton_effect.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/cubit/detail_plant_state.dart';
import 'package:plant_match_v2/features/user/detail_plant/utils/detail_plant_loader.dart';

class DetailPlantCubit extends SafeCubit<DetailPlantState> {
  final Catalog catalog;
  final Option<ProfilUser> owner;
  final String currentUserId;

  DetailPlantCubit({
    required this.catalog,
    required this.owner,
    required this.currentUserId,
  }) : super(const DetailPlantInitial());

  void incrementViews() =>
      DetailPlantLoader.incrementViews(catalog, currentUserId).run();

  void load() {
    emit(DetailPlantLoading(catalog: catalog));
    DetailPlantLoader.load(
      catalog: catalog,
      owner: owner,
      currentUserId: currentUserId,
    )
        .withMinimalDelay(SkeletonEffect.shimmerMinimumDelay)
        .match<DetailPlantState>(
          (failure) => DetailPlantError(failure),
          (data) => DetailPlantLoaded(data: data),
        )
        .map(emit)
        .run();
  }
}

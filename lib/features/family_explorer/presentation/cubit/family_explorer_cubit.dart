import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/cubit/family_explorer_state.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class FamilyExplorerCubit extends SafeCubit<FamilyExplorerState> {
  FamilyExplorerCubit({required Family family})
      : super(FamilyExplorerState(family: family, filter: CatalogFilter.all));

  void selectFilter(CatalogFilter filter) =>
      emit(state.copyWith(filter: Some(filter)));
}

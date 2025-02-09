import 'package:plant_match_v2/presentation/around_me_map/domain/entity/around_me.dart';

abstract class AroundMeRepository {
  Future<List<AroundMe>> getPlacesAroundMe(
      String uid, double latitude, double longitude);

  Future<List<AroundMe>> getAllUsers(String uid);
}

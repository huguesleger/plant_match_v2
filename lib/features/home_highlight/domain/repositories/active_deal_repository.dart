import 'package:plant_match_v2/features/home_highlight/domain/entities/active_deal.dart';

abstract class ActiveDealRepository {
  Stream<List<ActiveDeal>> watchActiveExchanges(String uid);

  Stream<List<ActiveDeal>> watchActiveDonations(String uid);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/home_highlight/data/mappers/active_deal_mapper.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/active_deal.dart';
import 'package:plant_match_v2/features/home_highlight/domain/repositories/active_deal_repository.dart';

class ActiveDealRepositoryImpl implements ActiveDealRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> _activeStatuses = [
    'pending',
    'accepted',
    'waitingValidation',
  ];

  @override
  Stream<List<ActiveDeal>> watchActiveExchanges(String uid) => _watch(
        'plant_exchanges',
        uid,
        (id, data) => Exchange.fromJson(id, data).toActiveDeal(),
      );

  @override
  Stream<List<ActiveDeal>> watchActiveDonations(String uid) => _watch(
        'plant_donations',
        uid,
        (id, data) => Donation.fromJson(id, data).toActiveDeal(),
      );

  Stream<List<ActiveDeal>> _watch(
    String collection,
    String uid,
    Option<ActiveDeal> Function(String id, Map<String, dynamic> data) toDeal,
  ) =>
      _firestore
          .collection(collection)
          .where(Filter.and(
            Filter.or(
              Filter('ownerId', isEqualTo: uid),
              Filter('requestedBy', isEqualTo: uid),
            ),
            Filter('status', whereIn: _activeStatuses),
          ))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .expand((doc) => toDeal(doc.id, doc.data()).match(
                    () => const <ActiveDeal>[],
                    (deal) => [deal],
                  ))
              .toList());
}

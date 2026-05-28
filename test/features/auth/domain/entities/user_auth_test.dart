import 'package:flutter_test/flutter_test.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  const tUid = 'testUid123';
  const tEmail = 'test@example.com';
  const tFirstName = 'John';
  const tLastName = 'Doe';
  const tFullName = 'John Doe';

  final tUserAuth = UserAuth(
    uid: tUid,
    email: const Some(tEmail),
    firstName: tFirstName,
    lastName: tLastName,
  );

  group('UserAuth Entity', () {
    test('devrait être instancié correctement avec les bonnes variables', () {
      expect(tUserAuth.uid, tUid);
      expect(tUserAuth.email, const Some(tEmail));
      expect(tUserAuth.firstName, tFirstName);
      expect(tUserAuth.lastName, tLastName);
      expect(tUserAuth.fullName, tFullName);
    });

    test('toJson devrait retourner une Map contenant les bonnes données', () {
      final expectedMap = {
        'uid': tUid,
        'email': tEmail,
        'firstName': tFirstName,
        'lastName': tLastName,
      };

      final result = tUserAuth.toJson();

      expect(result, expectedMap);
    });

    test('fromJson devrait retourner un objet UserAuth valide à partir dune Map', () {
      final map = {
        'uid': tUid,
        'email': tEmail,
        'firstName': tFirstName,
        'lastName': tLastName,
      };

      final result = UserAuth.fromJson(map);

      expect(result.uid, tUserAuth.uid);
      expect(result.email, tUserAuth.email);
      expect(result.firstName, tUserAuth.firstName);
      expect(result.lastName, tUserAuth.lastName);
      expect(result.fullName, tUserAuth.fullName);
    });

    test('fromJson devrait faire un fallback sur fullName si firstName et lastName sont absents', () {
      final map = {
        'uid': tUid,
        'email': tEmail,
        'fullName': tFullName,
      };

      final result = UserAuth.fromJson(map);

      expect(result.uid, tUserAuth.uid);
      expect(result.email, tUserAuth.email);
      expect(result.firstName, tFirstName);
      expect(result.lastName, tLastName);
      expect(result.fullName, tFullName);
    });
  });
}

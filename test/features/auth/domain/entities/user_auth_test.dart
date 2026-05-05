import 'package:flutter_test/flutter_test.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  const tUid = 'testUid123';
  const tEmail = 'test@example.com';
  const tFullName = 'John Doe';

  final tUserAuth = UserAuth(
    uid: tUid,
    email: const Some(tEmail),
    fullName: tFullName,
  );

  group('UserAuth Entity', () {
    test('devrait être instancié correctement avec les bonnes variables', () {
      expect(tUserAuth.uid, tUid);
      expect(tUserAuth.email, const Some(tEmail));
      expect(tUserAuth.fullName, tFullName);
    });

    test('toJson devrait retourner une Map contenant les bonnes données', () {
      final expectedMap = {
        'uid': tUid,
        'email': tEmail,
        'fullName': tFullName,
      };

      final result = tUserAuth.toJson();

      expect(result, expectedMap);
    });

    test('fromJson devrait retourner un objet UserAuth valide à partir dune Map', () {
      final map = {
        'uid': tUid,
        'email': tEmail,
        'fullName': tFullName,
      };

      final result = UserAuth.fromJson(map);

      expect(result.uid, tUserAuth.uid);
      expect(result.email, tUserAuth.email);
      expect(result.fullName, tUserAuth.fullName);
    });
  });
}

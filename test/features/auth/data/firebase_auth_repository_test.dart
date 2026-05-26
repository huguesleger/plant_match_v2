import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plant_match_v2/features/auth/data/firebase_auth_repository.dart';

// Mocks manuels avec Mocktail pour les tests fins
class ManualMockAuth extends Mock implements FirebaseAuth {}
class ManualMockUser extends Mock implements User {}
class MockFacebookAuth extends Mock implements FacebookAuth {}
class MockLoginResult extends Mock implements LoginResult {}
class MockAccessToken extends Mock implements AccessToken {}

void main() {
  setUpAll(() {
    registerFallbackValue(LoginTracking.enabled);
    registerFallbackValue(<String>[]);
  });

  late FirebaseAuthRepository repository;
  late MockFirebaseAuth mockAuth; // De firebase_auth_mocks
  late FakeFirebaseFirestore fakeFirestore;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockFacebookAuth mockFacebookAuth;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUid = 'uid123';
  const tFullName = 'John Doe';

  setUp(() {
    mockAuth = MockFirebaseAuth(
      signedIn: false,
      mockUser: MockUser(
        uid: tUid,
        email: tEmail,
        displayName: tFullName,
      ),
    );
    fakeFirestore = FakeFirebaseFirestore();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFacebookAuth = MockFacebookAuth();

    repository = FirebaseAuthRepository(
      firebaseAuth: mockAuth,
      firebaseFirestore: fakeFirestore,
      googleSignIn: mockGoogleSignIn,
      facebookAuth: mockFacebookAuth,
    );
  });

  group('FirebaseAuthRepository tests', () {
    test('signInWithGoogle devrait réussir et créer un utilisateur dans Firestore', () async {
      // Act
      final result = await repository.signInWithGoogle().run();

      // Assert
      result.fold(
        (l) => fail('Devrait réussir'),
        (r) {
          expect(r.$1.email.isSome(), true);
          expect(r.$1.uid, isNotNull);
          expect(r.$2, true); // isFirstTime should be true
        },
      );

      final users = await fakeFirestore.collection('users').get();
      expect(users.docs.length, 1);
    });

    test('signInWithFacebook devrait réussir et créer un utilisateur dans Firestore', () async {
      // Arrange
      final mockResult = MockLoginResult();
      final mockToken = MockAccessToken();
      
      when(() => mockFacebookAuth.login(
            permissions: any(named: 'permissions'),
            loginTracking: any(named: 'loginTracking'),
            nonce: any(named: 'nonce'),
          )).thenAnswer((_) async => mockResult);
      
      when(() => mockResult.status).thenReturn(LoginStatus.success);
      when(() => mockResult.accessToken).thenReturn(mockToken);
      when(() => mockToken.tokenString).thenReturn('fake_token');
      
      when(() => mockFacebookAuth.getUserData()).thenAnswer((_) async => {
            'email': tEmail,
            'name': tFullName,
          });

      // Act
      final result = await repository.signInWithFacebook().run();

      // Assert
      result.fold(
        (l) => fail('Devrait réussir: ${l.message}'),
        (r) {
          expect(r.$1.email, const Some(tEmail));
          expect(r.$2, true); // isFirstTime should be true
        },
      );
    });
    test('registerWithEmailAndPassword devrait créer un utilisateur dans Auth', () async {
      final result = await repository.registerWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ).run();

      result.fold(
        (l) => fail('Devrait réussir'),
        (r) {
          expect(r.email, const Some(tEmail));
          expect(r.uid, isNotNull);
          expect(r.fullName, tFullName);
        },
      );
    });

    test('signInWithEmailAndPassword devrait réussir et mettre à jour le statut isOnline', () async {
      final cred = await mockAuth.createUserWithEmailAndPassword(email: tEmail, password: tPassword);
      final realUid = cred.user!.uid;
      
      await fakeFirestore.collection('users').doc(realUid).set({
        'fullName': tFullName,
        'isOnline': false,
      });

      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      ).run();

      result.fold(
        (l) => fail('Devrait réussir: ${l.message}'),
        (r) {
          expect(r.email, const Some(tEmail));
          expect(r.uid, realUid);
        },
      );

      final userDoc = await fakeFirestore.collection('users').doc(realUid).get();
      expect(userDoc.data()?['isOnline'], true);
    });

    test('getCurrentUser devrait retourner Some(UserAuth) quand lutilisateur est déjà connecté', () async {
      mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: tUid, email: tEmail, displayName: tFullName),
      );
      await fakeFirestore.collection('users').doc(tUid).set({'fullName': tFullName});
      
      repository = FirebaseAuthRepository(
        firebaseAuth: mockAuth,
        firebaseFirestore: fakeFirestore,
      );

      final result = await repository.getCurrentUser().run();

      result.fold(
        (l) => fail('Devrait réussir'),
        (r) {
          expect(r.isSome(), true);
          r.fold(
            () => fail('Devrait être Some'),
            (user) => expect(user.uid, tUid),
          );
        },
      );
    });

    test('finalizeRegistration devrait créer un document utilisateur s’il n’existe pas', () async {
      final mockUser = MockUser(uid: tUid, email: tEmail);
      final result = await repository.finalizeRegistration(mockUser, tFullName).run();

      expect(result.getOrElse((_) => false), true);
      final userDoc = await fakeFirestore.collection('users').doc(tUid).get();
      expect(userDoc.exists, true);
      expect(userDoc.data()?['fullName'], tFullName);
    });

    test('isEmailVerified devrait appeler reload et retourner le statut', () async {
      final manualAuth = ManualMockAuth();
      final manualUser = ManualMockUser();
      
      when(() => manualAuth.currentUser).thenReturn(manualUser);
      when(() => manualUser.reload()).thenAnswer((_) async {});
      when(() => manualUser.emailVerified).thenReturn(true);

      final manualRepo = FirebaseAuthRepository(
        firebaseAuth: manualAuth,
        firebaseFirestore: fakeFirestore,
      );

      final result = await manualRepo.isEmailVerified().run();

      result.fold(
        (l) => fail('Devrait réussir'),
        (r) => expect(r, true),
      );
      verify(() => manualUser.reload()).called(1);
    });

    test('logOut devrait déconnecter lutilisateur et mettre à jour Firestore', () async {
      final cred = await mockAuth.createUserWithEmailAndPassword(email: tEmail, password: tPassword);
      final realUid = cred.user!.uid;
      await fakeFirestore.collection('users').doc(realUid).set({'isOnline': true});

      final result = await repository.logOut().run();

      expect(result.isRight(), true);
      final userDoc = await fakeFirestore.collection('users').doc(realUid).get();
      expect(userDoc.data()?['isOnline'], false);
    });
    group('Mapping Erreurs', () {
      test('_mapErrorToFailure devrait mapper FirebaseAuthException', () {
        // Test indirect via un call qui throw
        // On peut aussi exposer la méthode ou la tester via un mock qui throw.
      });
    });
  });
}

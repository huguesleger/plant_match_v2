import 'package:plant_match_v2/core/util/json_reader.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/core/firebase/cloud_function.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class FirebaseChatPlant implements ChatPlantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _chats =>
      _firestore.collection('plant_chats');

  CollectionReference<Map<String, dynamic>> _messages(String chatId) =>
      _chats.doc(chatId).collection('messages');

  Future<(String, String)> _ownerInfo(String plantOwnerId) async {
    final ownerDoc =
        await _firestore.collection('users').doc(plantOwnerId).get();
    return Option.fromNullable(ownerDoc.data()).match(
      () => ('Propriétaire', ''),
      (ownerData) {
        final profilUser = ProfilUser.fromJson({
          ...ownerData,
          'uid': ownerDoc.id,
        });
        return (
          profilUser.userName
              .alt(() => Some(profilUser.firstName))
              .filter((s) => s.trim().isNotEmpty)
              .getOrElse(() => 'Propriétaire'),
          profilUser.profilImg,
        );
      },
    );
  }

  @override
  TaskEither<Failure, String> getOrCreatePlantChat({
    required String currentUserId,
    required String plantOwnerId,
    required String plantId,
    required String plantName,
    required String plantDescription,
    required String plantImage,
    required OfferType plantExchangeType,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (currentUserId.isEmpty || plantOwnerId.isEmpty || plantId.isEmpty) {
          throw const UnexpectedFailure('Invalid chat parameters');
        }

        final (plantOwnerName, plantOwnerAvatar) =
            await _ownerInfo(plantOwnerId);

        final ids = [currentUserId, plantOwnerId]..sort();
        final chatId = '${plantId}_${ids[0]}_${ids[1]}';

        final chatRef = _chats.doc(chatId);
        final chatDoc = await chatRef.get();

        final chatData = {
          'participants': [currentUserId, plantOwnerId],
          'plantId': plantId,
          'plantName': plantName,
          'plantDescription': plantDescription,
          'plantImage': plantImage,
          'plantExchangeType': plantExchangeType.name,
          'plantOwnerId': plantOwnerId,
          'plantOwnerName': plantOwnerName,
          'plantOwnerAvatar': plantOwnerAvatar,
        };

        if (!chatDoc.exists) {
          await chatRef.set({
            ...chatData,
            'createdAt': FieldValue.serverTimestamp(),
            'lastMessageAt': FieldValue.serverTimestamp(),
            'unreadCount': {
              currentUserId: 0,
              plantOwnerId: 0,
            },
          });
        } else {
          await chatRef.update({
            'plantOwnerName': plantOwnerName,
            'plantOwnerAvatar': plantOwnerAvatar,
          });
        }
        return chatId;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  Stream<List<types.Message>> messagesStream(String chatId) {
    if (chatId.isEmpty) {
      throw const UnexpectedFailure('Invalid chatId');
    }
    return _messages(chatId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .where(
            (doc) => Option<dynamic>.fromNullable(
              doc.data()['timestamp'],
            ).isSome(),
          )
              .map(
            (doc) {
              final data = doc.data();
              final messageType = Option<dynamic>.fromNullable(
                data['messageType'],
              ).map((type) => type as String);

              final status =
                  Option<dynamic>.fromNullable(data['readAt']).isSome()
                      ? types.Status.seen
                      : types.Status.sent;

              if (messageType
                  .filter(
                    (type) =>
                        type == ChatMessageType.plantExchange.name ||
                        type == ChatMessageType.plantDonation.name,
                  )
                  .isSome()) {
                return types.CustomMessage(
                  id: doc.id,
                  author: types.User(id: doc['senderId']),
                  status: status,
                  createdAt: (doc['timestamp'] as Timestamp)
                      .toDate()
                      .millisecondsSinceEpoch,
                  metadata: {
                    'readAt': data['readAt'],
                    'messageType': messageType.toNullable(),
                    'plantId': data['plantId'],
                    'plantName': data['plantName'],
                    'plantImage': data['plantImage'],
                  },
                );
              }

              return types.TextMessage(
                id: doc.id,
                author: types.User(id: doc['senderId']),
                status: status,
                createdAt: (doc['timestamp'] as Timestamp)
                    .toDate()
                    .millisecondsSinceEpoch,
                text: data['text'],
                metadata: {
                  'readAt': data['readAt'],
                },
              );
            },
          ).toList(),
        );
  }

  Future<void> _ensureChatExists(
    String chatId,
    String senderId,
    String receiverId,
  ) async {
    final chatDoc = await _chats.doc(chatId).get();
    if (chatDoc.exists) return;

    final parts = chatId.split('_');
    if (parts.length < 3) throw const UnexpectedFailure('Invalid chatId');
    final plantId = parts[0];

    final plantDoc = await _firestore.collection('catalogs').doc(plantId).get();
    final plantData = Option.fromNullable(plantDoc.data())
        .getOrElse(() => throw const NotFoundFailure('Plant not found'));

    final plantOwnerId = Option<dynamic>.fromNullable(plantData['userId'])
        .map((id) => id as String)
        .getOrElse(() => receiverId);

    final (plantOwnerName, plantOwnerAvatar) = await _ownerInfo(plantOwnerId);

    final plantImage = Option<dynamic>.fromNullable(plantData['images'])
        .map((images) => images as List)
        .filter((images) => images.isNotEmpty)
        .map((images) => images.first as String)
        .getOrElse(() => '');

    await _chats.doc(chatId).set({
      'participants': [senderId, receiverId]..sort(),
      'plantId': plantId,
      'plantName':
          Option<dynamic>.fromNullable(plantData['name']).getOrElse(() => ''),
      'plantDescription': Option<dynamic>.fromNullable(plantData['description'])
          .getOrElse(() => ''),
      'plantImage': plantImage,
      'plantExchangeType': Option<dynamic>.fromNullable(plantData['offerType'])
          .getOrElse(() => 'exchange'),
      'plantOwnerId': plantOwnerId,
      'plantOwnerName': plantOwnerName,
      'plantOwnerAvatar': plantOwnerAvatar,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessageAt': FieldValue.serverTimestamp(),
      'unreadCount': {
        senderId: 0,
        receiverId: 0,
      },
    });
  }

  @override
  TaskEither<Failure, Unit> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (chatId.isEmpty || senderId.isEmpty || receiverId.isEmpty) {
          throw const UnexpectedFailure('Invalid message parameters');
        }

        await _ensureChatExists(chatId, senderId, receiverId);

        final chatRef = _chats.doc(chatId);

        await _messages(chatId).add({
          'senderId': senderId,
          'receiverId': receiverId,
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'readAt': const Option<Timestamp>.none().toNullable(),
        });

        await chatRef.update({
          'lastMessage': text,
          'lastMessageAt': FieldValue.serverTimestamp(),
          'unreadCount.$receiverId': FieldValue.increment(1),
          'deletedFor': FieldValue.arrayRemove([senderId, receiverId]),
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  Stream<List<ChatPlant>> chatsForUser(String uid) {
    return _chats
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.where((doc) {
        final data = doc.data();
        final deletedFor = data.listOf<String>('deletedFor');
        return !deletedFor.contains(uid) &&
            Option<dynamic>.fromNullable(data['lastMessage']).isSome();
      }).map((doc) {
        final data = doc.data();

        return ChatPlant(
          chatId: doc.id,
          plantId: data['plantId'],
          plantName: data['plantName'],
          plantDescription: data['plantDescription'],
          plantImage: data['plantImage'],
          plantExchangeType:
              Option<dynamic>.fromNullable(data['plantExchangeType']).match(
            () => OfferType.exchange,
            (type) => OfferType.values.byName(type as String),
          ),
          plantOwnerId: data['plantOwnerId'],
          plantOwnerName: data['plantOwnerName'],
          plantOwnerAvatar: data.read<String>('plantOwnerAvatar'),
          participants: List<String>.from(data['participants']),
          lastMessage: data.read<String>('lastMessage'),
          lastMessageAt: Option<dynamic>.fromNullable(data['lastMessageAt'])
              .map((at) => (at as Timestamp).toDate()),
          unreadCount: Map<String, int>.from(
            Option<dynamic>.fromNullable(data['unreadCount'])
                .getOrElse(() => <String, int>{}),
          ),
          otherUserId: (List<String>.from(data['participants']))
              .firstWhere((id) => id != uid, orElse: () => ''),
          hasUnreadExchange: false,
          isExchangeCompleted: data.boolean('isExchangeCompleted'),
          acceptedExchangeId: data.read<String>('acceptedExchangeId'),
          hasUnreadDonation: false,
          isDonationCompleted: data.boolean('isDonationCompleted'),
          acceptedDonationId: data.read<String>('acceptedDonationId'),
          isOtherUserOnline: false,
        );
      }).toList();
    });
  }

  @override
  TaskEither<Failure, Unit> resetUnread(String chatId, String uid) {
    return TaskEither.tryCatch(
      () async {
        if (chatId.isEmpty || uid.isEmpty) return unit;
        await _chats.doc(chatId).update({'unreadCount.$uid': 0});
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  Stream<int> unreadCount(String uid) {
    if (uid.isEmpty) {
      throw const SessionExpiredFailure('Empty uid');
    }
    return _chats
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      int total = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final deletedFor = data.listOf<String>('deletedFor');

        if (!deletedFor.contains(uid)) {
          total += Option<dynamic>.fromNullable(data['unreadCount'])
              .flatMap((counts) => Option<dynamic>.fromNullable(counts[uid]))
              .getOrElse(() => 0) as int;
        }
      }
      return total;
    });
  }

  @override
  TaskEither<Failure, Unit> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (chatId.isEmpty || currentUserId.isEmpty) return unit;

        final chatRef = _chats.doc(chatId);

        final unreadMessages = await _messages(chatId)
            .where('receiverId', isEqualTo: currentUserId)
            .where('readAt', isNull: true)
            .get();

        final batch = _firestore.batch();

        for (final doc in unreadMessages.docs) {
          batch.update(doc.reference, {
            'readAt': FieldValue.serverTimestamp(),
          });
        }

        batch.update(chatRef, {
          'unreadCount.$currentUserId': 0,
        });

        await batch.commit();
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, bool> chatExists(String chatId) => TaskEither.tryCatch(
        () async => (await _chats.doc(chatId).get()).exists,
        (error, _) => mapError(error),
      );

  @override
  TaskEither<Failure, int> payFirstContact({
    required String chatId,
    required String senderId,
    required String receiverId,
  }) =>
      TaskEither<Failure, Unit>.tryCatch(
        () => _ensureChatExists(chatId, senderId, receiverId).then((_) => unit),
        (error, _) => mapError(error),
      )
          .flatMap(
            (_) => CloudFunction.call('payFirstContact', {'chatId': chatId}),
          )
          .map(
            (result) => Option<dynamic>.fromNullable(result['cost'])
                .map((cost) => cost as int)
                .getOrElse(() => 0),
          );

  @override
  TaskEither<Failure, List<String>> getParticipants(String chatId) {
    return TaskEither.tryCatch(
      () async {
        if (chatId.isEmpty) {
          throw const UnexpectedFailure('Invalid chatId');
        }

        final doc = await _chats.doc(chatId).get();
        final data = Option.fromNullable(doc.data())
            .getOrElse(() => throw const NotFoundFailure('Chat not found'));

        return List<String>.from(data['participants']);
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> softDeleteChat({
    required String chatId,
    required String userId,
  }) {
    return TaskEither.tryCatch(
      () async {
        final doc = _firestore.collection('plant_chats').doc(chatId);

        await doc.set({
          'deletedFor': FieldValue.arrayUnion([userId])
        }, SetOptions(merge: true));
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> sendPlantExchangeMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String plantId,
    required String plantName,
    required String plantImage,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (chatId.isEmpty || senderId.isEmpty || receiverId.isEmpty) {
          throw const UnexpectedFailure('Invalid message parameters');
        }

        await _ensureChatExists(chatId, senderId, receiverId);

        final chatRef = _chats.doc(chatId);

        await _messages(chatId).add({
          'senderId': senderId,
          'receiverId': receiverId,
          'messageType': ChatMessageType.plantExchange.name,
          'plantId': plantId,
          'plantName': plantName,
          'plantImage': plantImage,
          'text': 'Proposition d\'échange',
          'timestamp': FieldValue.serverTimestamp(),
          'readAt': const Option<Timestamp>.none().toNullable(),
        });

        await chatRef.update({
          'lastMessage': 'Proposition d\'échange',
          'lastMessageAt': FieldValue.serverTimestamp(),
          'unreadCount.$receiverId': FieldValue.increment(1),
          'deletedFor': FieldValue.arrayRemove([senderId, receiverId]),
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> sendPlantDonationMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String plantId,
    required String plantName,
    required String plantImage,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (chatId.isEmpty || senderId.isEmpty || receiverId.isEmpty) {
          throw const UnexpectedFailure('Invalid message parameters');
        }

        await _ensureChatExists(chatId, senderId, receiverId);

        final chatRef = _chats.doc(chatId);

        await _messages(chatId).add({
          'senderId': senderId,
          'receiverId': receiverId,
          'messageType': ChatMessageType.plantDonation.name,
          'plantId': plantId,
          'plantName': plantName,
          'plantImage': plantImage,
          'text': 'Demande de donation',
          'timestamp': FieldValue.serverTimestamp(),
          'readAt': const Option<Timestamp>.none().toNullable(),
        });

        await chatRef.update({
          'lastMessage': 'Demande de donation',
          'lastMessageAt': FieldValue.serverTimestamp(),
          'unreadCount.$receiverId': FieldValue.increment(1),
          'deletedFor': FieldValue.arrayRemove([senderId, receiverId]),
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> reportChat({
    required String chatId,
    required String reporterUserId,
    required String reportedUserId,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _firestore.collection('reports').add({
          'chatId': chatId,
          'reporterUserId': reporterUserId,
          'reportedUserId': reportedUserId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> blockUser({
    required String blockerUserId,
    required String blockedUserId,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _firestore
            .collection('users')
            .doc(blockerUserId)
            .collection('blocked_users')
            .doc(blockedUserId)
            .set({
          'blockedAt': FieldValue.serverTimestamp(),
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> unblockUser({
    required String blockerUserId,
    required String blockedUserId,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _firestore
            .collection('users')
            .doc(blockerUserId)
            .collection('blocked_users')
            .doc(blockedUserId)
            .delete();
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  Stream<BlockStatus> blockStatusStream({
    required String currentUserId,
    required String otherUserId,
  }) {
    Stream<bool> blockedBy(String blocker, String blocked) => _firestore
        .collection('users')
        .doc(blocker)
        .collection('blocked_users')
        .doc(blocked)
        .snapshots()
        .map((doc) => doc.exists);

    final latest = <Option<bool>>[const None(), const None()];
    final subscriptions = <StreamSubscription<bool>>[];
    late final StreamController<BlockStatus> controller;

    void onValue(int index, bool value) {
      latest[index] = Some(value);
      final blockedByMe = latest[0].getOrElse(() => false);
      final blockedByOther = latest[1].getOrElse(() => false);
      if (latest.every((o) => o.isSome())) {
        controller.add(
          switch ((blockedByMe, blockedByOther)) {
            (true, true) => BlockStatus.blockedByMe,
            (true, false) => BlockStatus.blockedByMe,
            (false, true) => BlockStatus.blockedByOther,
            (false, false) => BlockStatus.none,
          },
        );
      }
    }

    controller = StreamController<BlockStatus>(
      onListen: () => subscriptions.addAll([
        blockedBy(currentUserId, otherUserId).listen(
          (value) => onValue(0, value),
          onError: (Object error) => controller.addError(mapError(error)),
        ),
        blockedBy(otherUserId, currentUserId).listen(
          (value) => onValue(1, value),
          onError: (Object error) => controller.addError(mapError(error)),
        ),
      ]),
      onCancel: () => Future.wait(subscriptions.map((s) => s.cancel())),
    );

    return controller.stream.distinct();
  }
}

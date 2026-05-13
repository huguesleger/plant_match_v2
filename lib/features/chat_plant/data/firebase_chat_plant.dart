import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';

class FirebaseChatPlant implements ChatPlantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _chats =>
      _firestore.collection('plant_chats');

  CollectionReference<Map<String, dynamic>> _messages(String chatId) =>
      _chats.doc(chatId).collection('messages');

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
          throw Exception('Paramètres invalides pour la création du chat');
        }

        final ownerDoc =
            await _firestore.collection('users').doc(plantOwnerId).get();

        final ownerData = ownerDoc.data() ?? {};

        final String plantOwnerName =
            (ownerData['userName'] as String?)?.trim().isNotEmpty == true
                ? ownerData['userName']
                : (ownerData['fullName'] as String?)?.split(' ').first ??
                    'Propriétaire';

        final String plantOwnerAvatar =
            (ownerData['profilImg'] as String?)?.trim().isNotEmpty == true
                ? ownerData['profilImg']
                : '';

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
      (error, _) => UnexpectedFailure('Erreur création chat plante: $error'),
    );
  }

  @override
  Stream<List<types.Message>> messagesStream(String chatId) {
    if (chatId.isEmpty) {
      throw Exception('chatId invalide');
    }
    return _messages(chatId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.where((doc) => doc.data()['timestamp'] != null).map(
            (doc) {
              final data = doc.data();
              final messageType = data['messageType'] as String?;

              final status = data['readAt'] != null
                  ? types.Status.seen
                  : types.Status.sent;

              if (messageType == ChatMessageType.plantExchange.name) {
                return types.CustomMessage(
                  id: doc.id,
                  author: types.User(id: doc['senderId']),
                  status: status,
                  createdAt: (doc['timestamp'] as Timestamp)
                      .toDate()
                      .millisecondsSinceEpoch,
                  metadata: {
                    'readAt': data['readAt'],
                    'messageType': ChatMessageType.plantExchange.name,
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
          throw Exception('Paramètres invalides pour l’envoi du message');
        }

        final chatRef = _chats.doc(chatId);

        await _messages(chatId).add({
          'senderId': senderId,
          'receiverId': receiverId,
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'readAt': null,
        });

        await chatRef.update({
          'lastMessage': text,
          'lastMessageAt': FieldValue.serverTimestamp(),
          'unreadCount.$receiverId': FieldValue.increment(1),
          'deletedFor': FieldValue.arrayRemove([senderId, receiverId]),
        });
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur envoi message: $error'),
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
        final deletedFor = List<String>.from(data['deletedFor'] ?? []);
        return !deletedFor.contains(uid);
      }).map((doc) {
        final data = doc.data();

        return ChatPlant(
          chatId: doc.id,
          plantId: data['plantId'],
          plantName: data['plantName'],
          plantDescription: data['plantDescription'],
          plantImage: data['plantImage'],
          plantExchangeType: data['plantExchangeType'] != null
              ? OfferType.values.byName(data['plantExchangeType'] as String)
              : OfferType.exchange,
          plantOwnerId: data['plantOwnerId'],
          plantOwnerName: data['plantOwnerName'],
          plantOwnerAvatar:
              Option.fromNullable(data['plantOwnerAvatar'] as String?),
          participants: List<String>.from(data['participants']),
          lastMessage: Option.fromNullable(data['lastMessage'] as String?),
          lastMessageAt: Option.fromNullable(
            (data['lastMessageAt'] as Timestamp?)?.toDate(),
          ),
          unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
          otherUserId: (List<String>.from(data['participants']))
              .firstWhere((id) => id != uid),
          hasUnreadExchange: false,
          isExchangeCompleted: data['isExchangeCompleted'] ?? false,
          acceptedExchangeId:
              Option.fromNullable(data['acceptedExchangeId'] as String?),
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
      (error, _) => UnexpectedFailure('Erreur reset unread: $error'),
    );
  }

  @override
  Stream<int> unreadCount(String uid) {
    if (uid.isEmpty) {
      throw Exception('UID invalide');
    }
    return _chats
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      int total = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final deletedFor = List<String>.from(data['deletedFor'] ?? []);

        if (!deletedFor.contains(uid)) {
          total += (data['unreadCount']?[uid] ?? 0) as int;
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
      (error, _) => UnexpectedFailure('Erreur marquage lu: $error'),
    );
  }

  @override
  TaskEither<Failure, List<String>> getParticipants(String chatId) {
    return TaskEither.tryCatch(
      () async {
        if (chatId.isEmpty) {
          throw Exception('chatId invalide');
        }

        final doc = await _chats.doc(chatId).get();
        final data = doc.data();

        if (data == null) {
          throw Exception('Chat introuvable');
        }

        return List<String>.from(data['participants']);
      },
      (error, _) =>
          UnexpectedFailure('Erreur récupération participants: $error'),
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
      (error, _) => UnexpectedFailure('Erreur soft delete chat: $error'),
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
          throw Exception('Paramètres invalides pour l\'envoi du message');
        }

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
          'readAt': null,
        });

        await chatRef.update({
          'lastMessage': 'Proposition d\'échange',
          'lastMessageAt': FieldValue.serverTimestamp(),
          'deletedFor': FieldValue.arrayRemove([senderId, receiverId]),
        });
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur envoi message échange: $error'),
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
      (error, _) => UnexpectedFailure('Erreur signalement: $error'),
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
      (error, _) => UnexpectedFailure('Erreur blocage utilisateur: $error'),
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
      (error, _) => UnexpectedFailure('Erreur déblocage utilisateur: $error'),
    );
  }

  @override
  Stream<bool> isBlockedStream({
    required String currentUserId,
    required String otherUserId,
  }) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('blocked_users')
        .doc(otherUserId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}

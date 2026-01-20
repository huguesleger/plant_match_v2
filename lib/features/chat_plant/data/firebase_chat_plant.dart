import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';

class FirebaseChatPlant implements ChatPlantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _chats =>
      _firestore.collection('plant_chats');

  CollectionReference<Map<String, dynamic>> _messages(String chatId) =>
      _chats.doc(chatId).collection('messages');

  @override
  Future<String> getOrCreatePlantChat({
    required String currentUserId,
    required String plantOwnerId,
    required String plantId,
    required String plantName,
    required String plantDescription,
    required String plantImage,
    required String plantExchangeType,
  }) async {
    if (currentUserId.isEmpty || plantOwnerId.isEmpty || plantId.isEmpty) {
      throw Exception('Paramètres invalides pour la création du chat');
    }

    try {
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
        'plantExchangeType': plantExchangeType,
        'plantOwnerId': plantOwnerId,
        'plantOwnerName': plantOwnerName,
        'plantOwnerAvatar': plantOwnerAvatar,
      };

      if (!chatDoc.exists) {
        await chatRef.set({
          ...chatData,
          'createdAt': FieldValue.serverTimestamp(),
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
    } catch (e) {
      throw Exception('Erreur lors de la création du chat plante : $e');
    }
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
          (snapshot) => snapshot.docs
              .where((doc) => doc.data()['timestamp'] != null)
              .map(
                (doc) => types.TextMessage(
                  id: doc.id,
                  author: types.User(id: doc['senderId']),
                  createdAt: (doc['timestamp'] as Timestamp)
                      .toDate()
                      .millisecondsSinceEpoch,
                  text: doc['text'],
                  metadata: {
                    'readAt': doc['readAt'],
                  },
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    if (chatId.isEmpty || senderId.isEmpty || receiverId.isEmpty) {
      throw Exception('Paramètres invalides pour l’envoi du message');
    }

    try {
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
    } catch (e) {
      throw Exception('Erreur lors de l’envoi du message : $e');
    }
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
          plantExchangeType: data['plantExchangeType'],
          plantOwnerId: data['plantOwnerId'],
          plantOwnerName: data['plantOwnerName'],
          plantOwnerAvatar: data['plantOwnerAvatar'],
          participants: List<String>.from(data['participants']),
          lastMessage: data['lastMessage'],
          lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
          unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
          otherUserId: (List<String>.from(data['participants']))
              .firstWhere((id) => id != uid),
        );
      }).toList();
    });
  }

  @override
  Future<void> resetUnread(String chatId, String uid) async {
    if (chatId.isEmpty || uid.isEmpty) return;
    await _chats.doc(chatId).update({'unreadCount.$uid': 0});
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
  Future<void> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  }) async {
    if (chatId.isEmpty || currentUserId.isEmpty) return;

    try {
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
    } catch (e) {
      throw Exception('Erreur lors du marquage des messages lus : $e');
    }
  }

  @override
  Future<List<String>> getParticipants(String chatId) async {
    if (chatId.isEmpty) {
      throw Exception('chatId invalide');
    }

    try {
      final doc = await _chats.doc(chatId).get();
      final data = doc.data();

      if (data == null) {
        throw Exception('Chat introuvable');
      }

      return List<String>.from(data['participants']);
    } catch (e) {
      throw Exception('Erreur récupération participants : $e');
    }
  }

  @override
  Future<void> softDeleteChat({
    required String chatId,
    required String userId,
  }) async {
    final doc =
        FirebaseFirestore.instance.collection('plant_chats').doc(chatId);

    await doc.set({
      'deletedFor': FieldValue.arrayUnion([userId])
    }, SetOptions(merge: true));
  }
}

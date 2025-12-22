import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';

class FirebaseChatPlant implements ChatPlantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    // Récupérer le profil du propriétaire pour nom et avatar
    final ownerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(plantOwnerId)
        .get();
    final ownerData = ownerDoc.data();
    final plantOwnerName =
        ownerData?['userName']?.toString().trim().isNotEmpty == true
            ? ownerData!['userName']
            : ownerData?['fullName']?.toString().split(' ').first ??
                'Propriétaire';
    final plantOwnerAvatar =
        ownerData?['profilImg']?.toString().trim().isNotEmpty == true
            ? ownerData!['profilImg']
            : '';

    final ids = [currentUserId, plantOwnerId]..sort();
    final chatId = '${plantId}_${ids[0]}_${ids[1]}';

    final ref = _firestore.collection('plant_chats').doc(chatId);
    final doc = await ref.get();

    final data = {
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

    if (!doc.exists) {
      await ref.set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'unreadCount': {currentUserId: 0, plantOwnerId: 0},
      });
    } else {
      await ref.update({
        'plantOwnerName': plantOwnerName,
        'plantOwnerAvatar': plantOwnerAvatar,
      });
    }

    return chatId;
  }

  @override
  Stream<List<types.Message>> messagesStream(String chatId) {
    return _firestore
        .collection('plant_chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .where((d) => d.data()['timestamp'] != null)
          .map((doc) {
        final data = doc.data();
        return types.TextMessage(
          id: doc.id,
          author: types.User(id: data['senderId']),
          createdAt:
              (data['timestamp'] as Timestamp).toDate().millisecondsSinceEpoch,
          text: data['text'],
          metadata: {
            'readAt': data['readAt'],
          },
        );
      }).toList();
    });
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final ref = _firestore.collection('plant_chats').doc(chatId);

    await ref.collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'readAt': null,
    });

    await ref.update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'unreadCount.$receiverId': FieldValue.increment(1),
    });
  }

  @override
  Stream<List<ChatPlant>> chatsForUser(String uid) {
    return _firestore
        .collection('plant_chats')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
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
        );
      }).toList();
    });
  }

  @override
  Future<void> resetUnread(String chatId, String uid) {
    return _firestore
        .collection('plant_chats')
        .doc(chatId)
        .update({'unreadCount.$uid': 0});
  }

  @override
  Stream<int> unreadCount(String uid) {
    return _firestore
        .collection('plant_chats')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      int total = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final unread = data['unreadCount']?[uid] ?? 0;
        total += unread as int;
      }

      return total;
    });
  }

  @override
  Future<void> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  }) async {
    final ref = _firestore.collection('plant_chats').doc(chatId);

    final unreadMessages = await ref
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('readAt', isNull: true)
        .get();

    final batch = _firestore.batch();

    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {
        'readAt': FieldValue.serverTimestamp(),
      });
    }

    batch.update(ref, {
      'unreadCount.$currentUserId': 0,
    });

    await batch.commit();
  }

  @override
  Future<List<String>> getParticipants(String chatId) async {
    final doc = await _firestore.collection('plant_chats').doc(chatId).get();

    final data = doc.data();
    if (data == null) {
      throw Exception('Chat introuvable');
    }

    return List<String>.from(data['participants']);
  }
}

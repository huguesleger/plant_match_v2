import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/features/chat/domain/entities/chat_user.dart';
import 'package:plant_match_v2/features/chat/repository/chat_repository.dart';

class FirebaseChat implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> getOrCreateChat(String uid1, String uid2) async {
    final chatId = uid1.compareTo(uid2) < 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';

    final ref = _firestore.collection('chats').doc(chatId);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'participants': [uid1, uid2],
        'createdAt': FieldValue.serverTimestamp(),
        'unreadCount': {
          uid1: 0,
          uid2: 0,
        },
        'lastMessageReadAt': null,
      });
    }

    return chatId;
  }

  @override
  Stream<List<types.Message>> messagesStream(String chatId) {
    return _firestore
        .collection('chats')
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
    required String text,
    required String receiverId,
  }) async {
    final ref = _firestore.collection('chats').doc(chatId);

    await ref.collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'seenBy': [senderId],
      'receiverId': receiverId,
      'readAt': null,
    });

    await ref.update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'unreadCount.$receiverId': FieldValue.increment(1),
      'lastMessageReadAt': null,
    });
  }

  @override
  Stream<List<ChatUser>> chatsForUser(String uid) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatUser(
          chatId: doc.id,
          participants: List<String>.from(data['participants']),
          lastMessage: data['lastMessage'],
          lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
          unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
          otherUserId: data['participants']
              .firstWhere((participant) => participant != uid),
          otherUserName: '',
          otherUserAvatar: '',
        );
      }).toList();
    });
  }

  @override
  Future<void> resetUnread(String chatId, String uid) {
    return _firestore.collection('chats').doc(chatId).update({
      'unreadCount.$uid': 0,
    });
  }

  @override
  Stream<int> unreadCount(String uid) {
    return _firestore
        .collection('chats')
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
    final ref = _firestore.collection('chats').doc(chatId);
    final unreadMessages = await ref
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('readAt', isNull: true)
        .get();

    if (unreadMessages.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {
        'readAt': FieldValue.serverTimestamp(),
      });
    }

    batch.update(ref, {
      'lastMessageReadAt': FieldValue.serverTimestamp(),
      'unreadCount.$currentUserId': 0,
    });
    await batch.commit();
  }
}

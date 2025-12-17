import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> getOrCreateChat(String uid1, String uid2) async {
    final chatId = uid1.compareTo(uid2) < 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';
    final chatDoc = firestore.collection('chats').doc(chatId);
    final exists = await chatDoc.get();

    if (!exists.exists) {
      await chatDoc.set({
        'participants': [uid1, uid2],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCount': {
          uid1: 0,
          uid2: 0,
        },
      });
    }
    return chatId;
  }
}

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../components/debugcusprint.dart';

class ChatService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message, String chatRoomId) async {
    try {
      final String currentUserId = _firebaseAuth.currentUser!.uid;
      final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();

      await _fireStore.runTransaction((transaction) async {
        transaction.set(
          _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').doc(),
          {
            'senderId': currentUserId,
            'senderEmail': currentUserEmail,
            'timestamp': FieldValue.serverTimestamp(),
            'message': message,
          },
        );
      });
    } catch (e) {
      debugLog('Transaction failed: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId, String chatRoomId, {Timestamp? afterTimestamp}) {
    Query query = _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false);

    if (afterTimestamp != null) {
      query = query.where('timestamp', isGreaterThan: afterTimestamp);
    }

    return query.snapshots();
  }

  Query getMessagesQuery(String chatRoomId, {Timestamp? afterTimestamp}) {
    Query query = _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false);

    if (afterTimestamp != null) {
      query = query.where('timestamp', isGreaterThan: afterTimestamp);
    }

    return query;
  }

  // New method to listen to new messages and update hive
  void listenForNewMessages(String chatRoomId) async {
    // Use the same encryption key as used in saving
    final encryptionKey = utf8.encode('vishnucanbeormaynotbegayinpinkfrogdress');
    final keyHash = sha256.convert(encryptionKey).bytes;

    // Open Hive box with encryption
    var box = await Hive.openBox(
        'messageDetails',
        encryptionCipher: HiveAesCipher(keyHash)
    );

    String? lastTimestampString = box.get('lastMessageTimestamp_$chatRoomId') as String?;
    Timestamp? lastTimestamp;

    if (lastTimestampString != null) {
      lastTimestamp = Timestamp.fromMillisecondsSinceEpoch(DateTime.parse(lastTimestampString).millisecondsSinceEpoch);
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query query = firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .limitToLast(1);

    if (lastTimestamp != null) {
      query = query.where('timestamp', isGreaterThan: lastTimestamp);
    }

    query.snapshots().listen((snapshot) async {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          String message = data['message'];
          DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

          debugLog('Chat room ID: $chatRoomId');
          debugLog('Last message: $message');
          debugLog('Last message timestamp: $timestamp');

          await box.put('lastMessage_$chatRoomId', message); // Store last message in Hive box
          await box.put('lastMessageTimestamp_$chatRoomId', DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp)); // Store last message timestamp in Hive box
        }
      }
    });
  }


}

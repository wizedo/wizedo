import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Function to delete the chat
  Future<void> deleteChat(String otherUserId) async {
    try {
      // Construct chat room id from user ids (sorted to ensure consistency)
      List<String> ids = [_firebaseAuth.currentUser!.uid, otherUserId];
      ids.sort();
      String chatRoomId = ids.join("_");

      // Delete all messages in the chat room
      await _fireStore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          // For each message, the delete() function is called on its reference (ds.reference) to delete the message document.
          ds.reference.delete();
        }
      });

      // Delete the chat room itself
      await _fireStore.collection('chat_rooms').doc(chatRoomId).delete();

      // After successful deletion, you can perform additional actions if needed,
      // such as updating the UI or showing a confirmation message.
    } catch (error) {
      // Handle the error, if any, such as showing an error message to the user.
      print("Error deleting chat: $error");
    }
  }
}

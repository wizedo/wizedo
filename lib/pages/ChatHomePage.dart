import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Widgets/colors.dart';
import '../services/chatservices/chatpage.dart';
import '../services/chatservices/chatservice.dart';
import 'LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

    @override
    State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final ChatService _chatService = ChatService(); // Add this line

    //Create a Map to store the latest messages for each user
    Map<String, String> latestMessages = {}; // Map to store latest messages


    Future<void> _signOut() async {
        await FirebaseAuth.instance.signOut();
        Get.offAll(LoginPage());
    }



    @override
    Widget build(BuildContext context) {
    //     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //             statusBarColor: Color(0xFF21215E).withOpacity(0.5), // Set the status bar color
    //             statusBarIconBrightness: Brightness.light, // Set the status bar icons color
    //             systemNavigationBarColor: Color(0xFF21215E).withOpacity(0.7), // Set the navigation bar color
    //             systemNavigationBarDividerColor: Colors.transparent, // Set the navigation bar divider color
    // ));
        return WillPopScope(
                onWillPop: () async {
            // Override the back button behavior to prevent going back to LoginPage.
            Get.offAll(ChatHomePage());
            return false; // Return false to prevent default back navigation.
        },
        child: Scaffold(
        backgroundColor: Colors.grey[20],
        appBar: AppBar(
                  title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                  child: Text(
                  'Message',
                  style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),),),
                  backgroundColor: backgroundColor,
                  actions: [
                  // IconButton(
                  // icon: Icon(Icons.logout),
                  // onPressed: _signOut,
                  //       ),
                      ],
          ),
        body: _buildUserList(),
        ),
    );
    }

    Widget _buildUserList() {
        return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FutureBuilder(
                future: _fetchUserList(),
                builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
                return Center(child: Text('Error'));
            }

            List<Widget> userItems = [];
            snapshot.data!.forEach((userData) {
                    String email = userData['email'] ?? '';
            String displayName = email.split('@').first;

            userItems.add(
                    GestureDetector(
                            onTap: () {
                //navigating to user's chat page and also giving reciveremail and uid
                Get.to(ChatPage(
                        receiveruserEmail: userData['email'],
                        receiverUserID: userData['uid'],
                  ));
            },
            child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
            child: Card(
                    elevation: 2, // Add elevation for 3D effect
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
            child: ListTile(
                    dense: true,
                    title: Text(displayName,style: TextStyle(fontSize: 15,color: backgroundColor),),
            subtitle: Text(latestMessages[userData['uid']] ?? ''),
                    ),
                  ),
                ),
              ),
            );
          });

            return ListView(
                    children: userItems,
          );
        },
      ),
    );
    }



    Future<List<Map<String, dynamic>>> _fetchUserList() async {
        List<Map<String, dynamic>> userList = [];

        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
                'users').get();

        for (var doc in snapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            if (_auth.currentUser!.email != data['email']) {
                QuerySnapshot latestSnapshot = await _chatService
                        .getMessages(
                                _auth.currentUser!.uid,
                        data['uid'],
        )
            .first;

                String latestMessage = '';
                if (latestSnapshot.docs.isNotEmpty) {
                    latestMessage = latestSnapshot.docs.last['message'];
                }

                latestMessages[data['uid']] = latestMessage;
                userList.add(data);
            }
        }

        return userList;
    }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/BlackText.dart';
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
  String userCollegee = 'null';
  String userEmail='null';



  //Create a Map to store the latest messages for each user
  Map<String, String> latestMessages = {

  }; // Map to store latest messages


  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(LoginPage());
  }

  Future<String> getUserEmailLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('userEmail');
      print('my username in chat page is: $userEmail');
      return userEmail ?? ''; // Return an empty string if userEmail is null
    } catch (error) {
      print('Error fetching user email locally: $error');
      return '';
    }
  }

  Future<String?> getSelectedCollegeLocally(String userEmail) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("after this statement select college locally should show");
      print(prefs.getString('selectedCollege_$userEmail'));
      return prefs.getString('selectedCollege_$userEmail');
    } catch (error) {
      print('Error getting selected college locally: $error');
      return null;
    }
  }

  Future<void> getUserCollege() async {
    try {
      print('i am in chat page');
      String? email=await getUserEmailLocally();
      String? userCollege = await getSelectedCollegeLocally(email!);
      setState(() {
        userCollegee = userCollege ?? 'null set manually2';
        print('User College in chat page: $userCollegee'); // Print the user's college name
      });

    } catch (error) {
      print('Error getting user college: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userEmail = await getUserEmailLocally();
    getUserCollege();
  }



  @override
  Widget build(BuildContext context) {
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
              child: InkWell(
                onTap: (){
                  setState(() {

                  });
                },
                child: Text(
                  'Message',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),),),
          backgroundColor: backgroundColor,
          actions: [
            // IconButton(
            // icon: Icon(Icons.logout),
            // onPressed: _signOut,
            //       ),
          ],
          automaticallyImplyLeading: false,
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
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }


          List<Widget> userItems = [];
          snapshot.data!.forEach((userData) {
            String displayName;

            if (userData['workeremail'] == userEmail) {
              displayName = userData['recieveremail'].split('@').first;
            } else {
              displayName = userData['workeremail'].split('@').first;
            }

            userItems.add(
              GestureDetector(
                onTap: () {
                  //navigating to user's chat page and also giving reciveremail and uid
                  Get.to(ChatPage(
                      receiveruserEmail: userData['emailid'],
                      receiverUserID: userData['userId'],
                      workeremail: userData['workeremail'],
                      recieveremail: userData['recieveremail'],
                      chatroomid:userData['chatRoomId']
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Card(
                    elevation: 2, // Add elevation for 3D effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      dense: true,
                      title: BlackText(displayName),
                      subtitle: BlackText(userData['lastMessage'] ?? '',fontSize: 9,fontWeight: FontWeight.normal,),

                      // subtitle: BlackText(userData['subCategory'] ?? '',fontWeight: FontWeight.normal,fontSize: 9,),
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
    Set<String> existingChatRoomIds = {}; // Set to store existing chat room IDs

    QuerySnapshot snapshot1 = await FirebaseFirestore.instance
        .collection('colleges')
        .doc(userCollegee)
        .collection('collegePosts')
        .where('status', isEqualTo: 'Applied')
        .where('amountpaid', isEqualTo: 'yes')
        .where('workeremail', isEqualTo: userEmail)
        .get();

    QuerySnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('colleges')
        .doc(userCollegee)
        .collection('collegePosts')
        .where('status', isEqualTo: 'Applied')
        .where('amountpaid', isEqualTo: 'yes')
        .where('recieveremail', isEqualTo: userEmail)
        .get();

    // Combine the results of both queries
    List<QueryDocumentSnapshot> combinedResults = [...snapshot1.docs, ...snapshot2.docs];

    for (var doc in combinedResults) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      String otherUseId;

      if (data['workeremail'] == userEmail) {
        otherUseId = data['recieveremail'];
      } else {
        otherUseId = data['workeremail'];
      }

      if (userEmail != otherUseId) {
        String? chatRoomId = data['chatRoomId'];
        if (chatRoomId != null) {
          // If chat room ID exists, check if it's encountered for the first time
          if (!existingChatRoomIds.contains(chatRoomId)) {
            // If it's encountered for the first time, add data to userList
            userList.add(data);
            existingChatRoomIds.add(chatRoomId);
          }
        } else {
          // If chat room ID doesn't exist, generate a new one
          chatRoomId = FirebaseFirestore.instance.collection('chatRooms').doc().id;
          // Assign the new chat room ID to the document
          await FirebaseFirestore.instance
              .collection('colleges')
              .doc(userCollegee)
              .collection('collegePosts')
              .doc(doc.id)
              .update({'chatRoomId': chatRoomId});
          // Add data to userList
          userList.add(data);
          existingChatRoomIds.add(chatRoomId);
        }
      }
    }

    // Fetch and append last messages for each user
    for (var user in userList) {
      String? lastMessage = await _chatService.fetchLastMessage(user['chatRoomId']);
      user['lastMessage'] = lastMessage;
    }

    return userList;
  }



}
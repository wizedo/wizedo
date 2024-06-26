import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/BlackText.dart';
import 'package:wizedo/components/white_text.dart';
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
  RxSet<String> existingChatRoomIds = <String>{}.obs;
  RxList<Map<String, dynamic>> userList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> postlist = <Map<String, dynamic>>[].obs;



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

  @override
  void dispose() {
    print('disposed few stuff');
    super.dispose();
  }

  Future<void> initializeData() async {
    userEmail = await getUserEmailLocally();
    getUserCollege();

    // Check the refresh key initially
    checkRefreshKey();
  }

  // Check the refresh key stored locally
  Future<void> checkRefreshKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshKey = prefs.getString('refreshKey');

    if (refreshKey == 'yes') {
      // Call setState to refresh the page after a slight delay
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          print('set state called for yes');
        });
      });
      await prefs.setString('refreshKey', 'no');
    }
  }


  Future<Timestamp?> _getLastMessageTimestamp(String chatRoomId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['timestamp'] as Timestamp?;
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching last message timestamp: $error');
      return null;
    }
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
            child: InkWell(
                onTap: (){
                  listenForChatChanges();
                },
                child: InkWell(
                    onTap: (){
                      setState(() {

                      });
                    },
                    child: WhiteText('Messages',fontSize: 17,))
            ),),
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

          return Obx(() {
            List<Widget> userItems = userList.map((userData) {
              String displayName;
              if (userData['workeremail'] == userEmail) {
                displayName = userData['recieveremail'].split('@').first;
              } else {
                displayName = userData['workeremail'].split('@').first;
              }

              String lastMessage = userData['lastMessage'].value ?? '';
              String lastMessageTimestamp = _formatTimestamp(userData['lastMessageTimestamp'].value) ?? '';

              return GestureDetector(
                onTap: () {
                  Get.to(ChatPage(
                    receiveruserEmail: userData['emailid'],
                    receiverUserID: userData['userId'],
                    workeremail: userData['workeremail'],
                    recieveremail: userData['recieveremail'],
                    chatroomid: userData['chatRoomId'],
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: ListTile(
                    dense: true,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [
                          BlackText(displayName, fontSize: 14,),
                          SizedBox(width: 10,),
                          BlackText('-',fontSize: 14,),
                          SizedBox(width: 10,),
                          FutureBuilder(
                            future: _fetchSubCategoriesForChatRoom(userData['chatRoomId']),
                            builder: (context, subCategorySnapshot) {
                              if (subCategorySnapshot.hasData) {
                                List<String>? subCategories = subCategorySnapshot.data;
                                String subCategoriesText = subCategories!.join(', '); // Join subcategories with comma

                                if (subCategoriesText.length > 27) {
                                  subCategoriesText = subCategoriesText.substring(0, 30) + '...';
                                }

                                return Expanded(child: BlackText(subCategoriesText, fontSize: 9));
                              } else {
                                return Container();
                              }
                            },
                          ),

                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BlackText(
                                lastMessage,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 13),
                            BlackText(
                              lastMessageTimestamp,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList();

            return RefreshIndicator(
              onRefresh: () async{
                await Future.delayed(Duration(seconds: 3));
                setState(() {

                });
              },
              color: Colors.white,
              backgroundColor: backgroundColor,
              child: ListView(
                children: userItems,
              ),
            );
          });
        },
      ),
    );
  }






  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      // Format the hour part
      String hour = '${dateTime.hour}';
      // Pad minute part with leading zero if less than 10
      String minute = '${dateTime.minute}'.padLeft(2, '0');
      return '$hour:$minute';
    } else {
      return '';
    }
  }


  Future<List<Map<String, dynamic>>> _fetchUserList() async {

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
            existingChatRoomIds.refresh();
            await _fetchSubCategoriesForChatRoom(chatRoomId);
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
          existingChatRoomIds.refresh();
          await _fetchSubCategoriesForChatRoom(chatRoomId);
        }
      }
    }

    for (var user in userList) {
      String? lastMessage = await _chatService.fetchLastMessage(user['chatRoomId']);
      Timestamp? lastMessageTimestamp = await _getLastMessageTimestamp(user['chatRoomId']);
      // Make lastMessage and lastMessageTimestamp observable
      user['lastMessage'] = lastMessage.obs;
      user['lastMessageTimestamp'] = lastMessageTimestamp.obs;
    }
    listenForChatChanges();
    return userList;
  }

  Future<List<String>> _fetchSubCategoriesForChatRoom(String chatRoomId) async {
    List<String> subCategories = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('colleges')
        .doc(userCollegee)
        .collection('collegePosts')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .where('status', isEqualTo: 'Applied')
        .get();

    // Iterate through each document and extract the subCategory field
    snapshot.docs.forEach((doc) {
      String subCategory = doc['subCategory'];
      subCategories.add(subCategory);
    });
    print('subcategories are below $subCategories');

    return subCategories;
  }



  Stream<QuerySnapshot> listenForChatChanges() {
    // Create a StreamController to manage the combined stream
    final controller = StreamController<QuerySnapshot>();
    print(existingChatRoomIds);

    existingChatRoomIds.forEach((chatRoomId) {
      Stream<QuerySnapshot> chatRoomStream = FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();

      // Listen to the chat room stream and add data to controller
      chatRoomStream.listen((snapshot) async {
        print('change happened');
        controller.add(snapshot);
        for (var user in userList) {
          String? lastMessage = await _chatService.fetchLastMessage(user['chatRoomId']);
          Timestamp? lastMessageTimestamp = await _getLastMessageTimestamp(user['chatRoomId']);
          // Make lastMessage and lastMessageTimestamp observable
          user['lastMessage'] = lastMessage.obs;
          user['lastMessageTimestamp'] = lastMessageTimestamp.obs;
          userList.refresh();
        }

      });
    });

    return controller.stream;
  }




}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/my_text_field.dart';
import 'chatcontroller.dart';
import 'chatservice.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiveruserEmail,
    required this.receiverUserID
  });
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController=TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  //for delting the chat intilizing to use it
  final ChatController _chatController = Get.put(ChatController());

  //for automatic scrolling
  final ScrollController _scrollController = ScrollController();

  void sendMessage()async{
    //only send message if there is something is send
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text);

      //clear the text contorller after sending message
      _messageController.clear();
    }
  }


  // Function to format the timestamp
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  String latestMessage = ''; // Store the latest received message here

  @override
  void initState() {
    super.initState();
    _getLatestMessage(); // Fetch the latest message when the widget is initialized
  }

  // Function to get the latest message
  void _getLatestMessage() async {
    QuerySnapshot latestSnapshot = await _chatService.getMessages(
      _firebaseAuth.currentUser!.uid,
      widget.receiverUserID,
    ).first;

    if (latestSnapshot.docs.isNotEmpty) {
      Map<String, dynamic> latestData =
      latestSnapshot.docs.last.data() as Map<String, dynamic>;
      setState(() {
        latestMessage = latestData['message'];
      });

      // Scroll to the end after updating the latest message
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set the system overlay style
    // Set the system overlay style for status and navigation bars
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF21215E).withOpacity(0.5), // Set the status bar color
      statusBarIconBrightness: Brightness.light, // Set the status bar icons color
      systemNavigationBarColor: Color(0xFF21215E).withOpacity(0.7), // Set the navigation bar color
      systemNavigationBarDividerColor: Colors.transparent, // Set the navigation bar divider color
    ));
    String receiverDisplayName = widget.receiveruserEmail.split('@').first;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(receiverDisplayName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
            ),
          ),
          backgroundColor: Color(0xFF21215E).withOpacity(0.7),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.delete_rounded,size: 16,),
              onPressed: () {
                Get.snackbar(
                  '', // Empty title for a transparent style
                  'Are you sure you want to delete this chat??',
                  snackPosition: SnackPosition.TOP,
                  duration: Duration(seconds: 6),
                  margin: EdgeInsets.only(top: 50,left: 10,right: 10),
                  backgroundColor: Colors.transparent,
                  borderRadius: 20,
                  mainButton: TextButton(
                    onPressed: () {
                      _chatController.deleteChat(widget.receiverUserID); // Pass the chatId
                      Get.back(); // Close the snackbar
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Color(0xFF21215E)), // Change button text color
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(child: _buildMessageList()),

              //User Input
              _buildMessageInput(),
              const SizedBox(height: 25,)
            ],
          ),
        ),
      ),
    );
  }

  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(//This widget helps handle real-time updates from a stream of data
        stream: _chatService.getMessages(//This function returns a stream of messages between the current user and the receiver user.
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context,snapshot){//This is where the UI is built based on the state of the stream's data.
          if(snapshot.hasError){
            return Text('Error${snapshot.error}');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Text('Loading...');
          }
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            // Scroll to the end after the ListView is built and updated
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });
          return ListView(
            controller: _scrollController, // Attach the ScrollController
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        });
  }

    //build message item
    Widget _buildMessageItem(DocumentSnapshot document){
      Map<String,dynamic> data=document.data() as Map<String,dynamic>;
      //above code  is extracting the data of a specific message like
      // When you call document.data() on the DocumentSnapshot object, it retrieves the data and assigns it to the data map:
      //
      // Map<String, dynamic> data = {
      // "senderId": "user123",
      // "senderEmail": "user123@gmail.com",
      // "message": "Hello, how are you?",
      // "timestamp": 1678987654321
      // };
      //After this assignment, you can access the data using the keys in the data map. For example:

      // String senderId = data['senderId']; // "user123"

      //align msg to right if sender is user otherwise left
      var alignment =(data['senderId']==_firebaseAuth.currentUser!.uid)?
      Alignment.centerRight : Alignment.centerLeft;


      // Determine the background color based on the sender's ID
      Color bubbleColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ? Color(0xFF21215E).withOpacity(0.7) // User sending the message
          : Colors.white.withOpacity(0.5); // User receiving the message

      Color textColor = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Colors.white : Color(0xFF21215E);
      Color borderColor = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Colors.white : Color(0xFF21215E);

      BoxShadow boxShadow = (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ? BoxShadow(color: Color(0xFF21215E).withOpacity(0.7), blurRadius: 80.0) // Transparent box shadow for sent messages
          : BoxShadow(color: Color(0xFF21215E).withOpacity(0.7), blurRadius: 80.0); // Colored box shadow for received messages


      // Determine the border radius based on the sender's ID
      BorderRadiusGeometry borderRadius = (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ? BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(0.5), // Slightly different radius for user sending
      )
          : BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(0.5), // Slightly different radius for user receiving
        bottomRight: Radius.circular(15),
      );

      // Extract part of the email before '@gmail.com'
      String senderDisplayName = data['senderEmail'].split('@')[0];

      if (data['timestamp'] == null) {
        return Container(); // Return an empty container if the timestamp is null
      }

      return Container(
        alignment: alignment,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //This determines the horizontal alignment of the column's children based on the condition.
            crossAxisAlignment: (data['senderId']==_firebaseAuth.currentUser!.uid)?
            CrossAxisAlignment.end : CrossAxisAlignment.start,
            //If the senderId matches the current user's UID, the children will be aligned to the bottom, otherwise to the top.
            mainAxisAlignment: (data['senderId']==_firebaseAuth.currentUser!.uid)?
            MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(senderDisplayName, style: TextStyle(fontSize: 9)),
              const SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: bubbleColor,
                  // border: Border.all(color: borderColor, width: 0.7),
                  boxShadow: [boxShadow]// Set the border color
                ),
                child: Text(
                  data['message'],
                  style: TextStyle(fontSize: 13, color: textColor),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTimestamp(data['timestamp']), // Format the timestamp here
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

  //build message input
  Widget _buildMessageInput(){
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 0,bottom: 2,right: 0,left: 20),
        child: Row(
          children: [
            Expanded(child: MyTextField(
              controller: _messageController,
              label: 'Enter Message',
              obscureText: false,
            )),
            //send button
            Container(child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(onPressed: sendMessage, icon: Icon(Icons.send,color: Color(0xFF21215E).withOpacity(0.7) ,)),
            ))
          ],
        ),
      ),
    );
  }
}
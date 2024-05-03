import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/colors.dart';
import 'chatcontroller.dart';
import 'chatservice.dart';
import 'package:crypto/crypto.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiverUserID;
  final String? workeremail; // Optional parameter
  final String? recieveremail; // Optional parameter
  final String? chatroomid;

  const ChatPage({
    required this.receiveruserEmail,
    required this.receiverUserID,
    this.workeremail,
    this.recieveremail,
    required this.chatroomid,
    Key? key,
  }) : super(key: key);

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

  String userEmail='null';
  String otherEmail='null';
  String boka='null';

  // for textfield focus
  FocusNode myFocusNode=FocusNode();
  bool _messagesLoaded = false;


  @override
  void initState() {
    super.initState();
    _initializeData();
    print('below is workeremail and recieveremail from chat page');
    print(widget.workeremail);
    print(widget.recieveremail);
    print(widget.receiverUserID);
    print('below is otheremail');
    print(otherEmail);
    print('below printig boka');
    print(boka);
    _getLatestMessage(); // Fetch the latest message when the widget is initialized

    //add listener to focus node
    myFocusNode.addListener(() {
      Future.delayed(const Duration(milliseconds: 650),
        ()=> scrollDown(),
      );
    });

    //wait a bit for listview to be build, then scroll to bottom
    Future.delayed(
      const Duration(milliseconds: 650),
        () => scrollDown(),
    );
  }

  @override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }

  Future<void> _initializeData() async {
    await initializeData();
    otherEmail = await getOtherEmail(userEmail, widget.workeremail, widget.recieveremail);
    _getLatestMessage();
  }

  Future<void> initializeData() async {
    userEmail = await getUserEmailLocally() ?? '';
  }

  Future<String> getUserEmailLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('userEmail');
      print('my username in chatpage particular page is: $userEmail');
      return userEmail ?? ''; // Return an empty string if userEmail is null
    } catch (error) {
      print('Error fetching user email locally: $error');
      return '';
    }
  }

  String getOtherEmail(String userEmail, String? workeremail, String? recieveremail) {
    print('below is useremail and workeremail');
    print(userEmail);
    print(workeremail);
    if (userEmail != workeremail) {
      return workeremail ?? 'DefaultRecieverEmail';
    } else {
      return recieveremail ?? 'DefaultRecieverEmail';
    }
  }

  void sendMessage()async{
    //only send message if there is something is send
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text,widget.chatroomid!);

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

  // Function to get the latest message
  void _getLatestMessage() async {
    QuerySnapshot latestSnapshot = await _chatService.getMessages(
        _firebaseAuth.currentUser!.uid,
        widget.receiverUserID,
        widget.chatroomid!
    ).first;

    if (latestSnapshot.docs.isNotEmpty) {
      Map<String, dynamic> latestData =
      latestSnapshot.docs.last.data() as Map<String, dynamic>;
      setState(() {
        latestMessage = latestData['message'];
      });

      // Check if the controller has clients before trying to jump
      if (_scrollController.hasClients) {
        // Scroll to the end after updating the latest message
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: FutureBuilder(
            future: initializeData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  otherEmail.split('@').first ?? 'Default Title',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                );
              } else {
                return CircularProgressIndicator(); // Or any other loading indicator
              }
            },
          ),
        ),
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.delete_rounded, size: 16,),
          //   onPressed: () {
          //     Get.snackbar(
          //       '', // Empty title for a transparent style
          //       'Are you sure you want to delete this chat??',
          //       snackPosition: SnackPosition.TOP,
          //       duration: Duration(seconds: 6),
          //       margin: EdgeInsets.only(top: 50, left: 10, right: 10),
          //       backgroundColor: Colors.transparent,
          //       borderRadius: 20,
          //       mainButton: TextButton(
          //         onPressed: () {
          //           _chatController.deleteChat(widget.receiverUserID); // Pass the chatId
          //           Get.back(); // Close the snackbar
          //         },
          //         child: Text(
          //           'Yes',
          //           style: TextStyle(color: Color(0xFF21215E)), // Change button text color
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            //User Input
            _buildMessageInput(),
            const SizedBox(height: 10)
          ],
        ),

      ),
    );
  }

  //build message list
// build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserID,
        _firebaseAuth.currentUser!.uid,
        widget.chatroomid!,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting && !_messagesLoaded) {
          return Center(
            child: CircularProgressIndicator(), // Show a loading indicator instead of "Loading messages..."
          );
        }
        if (!_messagesLoaded) {
          _messagesLoaded = true; // Set messagesLoaded to true once messages are loaded for the first time
        }
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          // Scroll to the end after the ListView is built and updated
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
        return ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.only(bottom: 10),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(
              snapshot.data!.docs[index],
              index,
              snapshot.data!.docs.length,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            // Check if the current message has a different date from the previous message
            if (index > 0) {
              Timestamp currentTimestamp = (snapshot.data!.docs[index].data() as Map<String, dynamic>)['timestamp'];
              Timestamp previousTimestamp = (snapshot.data!.docs[index - 1].data() as Map<String, dynamic>)['timestamp'];
              DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(currentTimestamp.seconds * 1000);
              DateTime previousDate = DateTime.fromMillisecondsSinceEpoch(previousTimestamp.seconds * 1000);
              if (currentDate.day != previousDate.day || currentDate.month != previousDate.month || currentDate.year != previousDate.year) {
                // If dates are different, show a container with the date
                String formattedDate = DateFormat('dd MMMM yyyy').format(currentDate);
                return Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 30),
                  child: Center(
                    child: Container(
                      height: 30, // Adjust the height as needed
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Add internal padding
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFF21215E).withOpacity(0.7),
                      ),
                      child: Text(
                        formattedDate,
                        style: GoogleFonts.mPlusRounded1c(
                          textStyle: TextStyle(
                            color:Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // Default font size is 14
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
            return SizedBox(); // Otherwise, return an empty SizedBox
          },

        );
      },
    );
  }




  //build message item
  Widget _buildMessageItem(DocumentSnapshot document, int index, int totalCount) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align msg to right if sender is user otherwise left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // Determine the background color based on the sender's ID
    Color bubbleColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Color(0xFF21215E).withOpacity(0.7) // User sending the message
        : Colors.white.withOpacity(0.5); // User receiving the message

    Color textColor = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Colors.white : Color(0xFF21215E);
    Color borderColor = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Colors.white : Color(0xFF21215E);

    // Determine the border radius based on the sender's ID
    BorderRadiusGeometry borderRadius = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(index == totalCount - 1 ? 0.5 : 0), // Slightly different radius for user sending
    )
        : BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
      bottomLeft: Radius.circular(0.5), // Slightly different radius for user receiving
      bottomRight: Radius.circular(index == totalCount - 1 ? 15 : 0),
    );

    // Extract part of the email before '@gmail.com'
    // String senderDisplayName = (data['senderEmail'] ?? '').split('@')[0];

    // Determine the alignment and padding based on sender's ID
    CrossAxisAlignment crossAlignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    double leftPadding = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? MediaQuery.of(context).size.width * 0.15 // 15% of screen width for sent messages
        : 0; // No left padding for received messages

    double rightPadding = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? 0 // No right padding for sent messages
        : MediaQuery.of(context).size.width * 0.15; // 15% of screen width for received messages

    EdgeInsets padding = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? EdgeInsets.fromLTRB(leftPadding, 10.0, rightPadding, 10.0)
        : EdgeInsets.fromLTRB(leftPadding, 10.0, rightPadding, 10.0);

    if (data['timestamp'] == null) {
      return Container(); // Return an empty container if the timestamp is null
    }

    return Container(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Column(
            //This determines the horizontal alignment of the column's children based on the condition.
            crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            //If the senderId matches the current user's UID, the children will be aligned to the bottom, otherwise to the top.
            mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              // Text(senderDisplayName, style: TextStyle(fontSize: 9)),
              // const SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: bubbleColor,
                  // border: Border.all(color: borderColor, width: 0.7),
                  boxShadow: [
                    if (index != totalCount - 1) // Apply box shadow only if it's not the last message
                      BoxShadow(
                        color: Color(0xFF21215E).withOpacity(0.7),
                        blurRadius: 80.0,
                      ),
                  ],
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
      ),
    );
  }


// Build Message Input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 0, left: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: GoogleFonts.mPlusRounded1c(
                textStyle: TextStyle(
                color:Color(0xFF000000),
                fontSize: 14, // Default font size is 14
              ),
              ),
              controller: _messageController,
              cursorHeight: 25,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              focusNode: myFocusNode,
              maxLines: null, // Set to null for multiline
              decoration: InputDecoration(
                labelText: 'Send Message...',
                labelStyle: GoogleFonts.mPlusRounded1c(
                  textStyle: TextStyle(
                    color:Color(0xFF000000),
                    fontSize: 14, // Default font size is
                  ),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFF21215E)), // Set focused border line color here
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Adjust height here
              ),
            ),
          ),
          // Circular container with send icon
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: InkWell(
              onTap: sendMessage,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF21215E).withOpacity(0.7),
                ),
                child: Icon(Icons.send_rounded, size: 23, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }





}
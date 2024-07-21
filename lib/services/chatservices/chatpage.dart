import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../Widgets/colors.dart';
import '../../components/chatscomponents/MessageBubble.dart';
import '../../components/chatscomponents/MessageInput.dart';
import '../../components/debugcusprint.dart';
import '../../controller/UserController.dart';
import 'chatcontroller.dart';
import 'chatservice.dart';
import 'DocumentSnapshotMock.dart';

// Encryption/Decryption with Hive: By specifying the encryptionCipher when opening the box, Hive encrypts and decrypts the data automatically.
// Data Handling: Once you retrieve the data from the Hive box, it’s already decrypted, so you can process it as usual.

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiverUserID;
  final String? workeremail;
  final String? recieveremail;
  final String? chatroomid;

  const ChatPage({
    required this.receiveruserEmail,
    required this.receiverUserID,
    this.workeremail,
    this.recieveremail,
    required this.chatroomid,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AutomaticKeepAliveClientMixin<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserController userController = Get.find<UserController>();

  final ScrollController _scrollController = ScrollController();

  String userEmail = 'null';
  String otherEmail = ' ';

  FocusNode myFocusNode = FocusNode();
  bool _messagesLoaded = false;
  bool _isSending = false;
  DateTime? _latestMessageTimestamp; // Declare _latestMessageTimestamp here

  final RxList<DocumentSnapshotMock> _messagesList = <DocumentSnapshotMock>[].obs;
  StreamSubscription<QuerySnapshot>? _messagesSubscription; // Firestore subscription

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadMessagesFromLocalStorage();
    myFocusNode.addListener(() {
      Future.delayed(const Duration(milliseconds: 650), () => scrollDown());
    });

    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          _showScrollButton = false;
        });
      } else {
        setState(() {
          _showScrollButton = true;
        });
      }
    });
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  bool _showScrollButton = false;

  Future<void> _initializeData() async {
    await initializeData();
    otherEmail = getOtherEmail(userEmail, widget.workeremail, widget.recieveremail);
  }

  Future<void> initializeData() async {
    userEmail = userController.id ?? '';
  }

  String getOtherEmail(String userEmail, String? workeremail, String? recieveremail) {
    if (userEmail != workeremail) {
      return workeremail ?? 'DefaultRecieverEmail';
    } else {
      return recieveremail ?? 'DefaultRecieverEmail';
    }
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty && !_isSending) {
      _isSending = true;
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text, widget.chatroomid!);
      _messageController.clear();
      await Future.delayed(const Duration(seconds: 2));
      _isSending = false;
    }
  }

  Future<void> _getMessagesFromFirestore() async {
    Query query = _chatService.getMessagesQuery(
      widget.chatroomid!,
      afterTimestamp: _latestMessageTimestamp != null ? Timestamp.fromDate(_latestMessageTimestamp!) : null,
    );

    _messagesSubscription = query.snapshots().listen((QuerySnapshot snapshot) {
      debugLog('New message fetched');

      if (!mounted) return; // Check if the widget is still mounted before calling setState

      setState(() {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            debugLog('Document ID: ${change.doc.id}');
            debugLog('Document Data: ${change.doc.data()}');

            Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
            debugLog('Map data $data');

            // Update last message in hive
            _updateLastMessage(data['message'], widget.chatroomid!);

            if (data['timestamp'] != null) {
              final timestamp = (data['timestamp'] as Timestamp).toDate();

              if (_latestMessageTimestamp == null || timestamp.isAfter(_latestMessageTimestamp!)) {
                _latestMessageTimestamp = timestamp;

                // Update last message timestamp in hive
                _updateLastMessageTimestamp(timestamp, widget.chatroomid!);
              }
            } else {
              debugLog('Message with ID ${widget.chatroomid!} has a null timestamp');
              continue;
            }

            if (data['timestamp'] is int) {
              data['timestamp'] = DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int).millisecondsSinceEpoch;
            }

            _messagesList.add(DocumentSnapshotMock(data, change.doc.id));
          }
        }

        _messagesLoaded = true;
        _saveMessagesToLocalStorage(_messagesList);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      });
    });
  }

  void _updateLastMessage(String message, String chatRoomId) async {
    try {
      // Use the same encryption key as used in saving
      final encryptionKey = utf8.encode('vishnucanbeormaynotbegayinpinkfrogdress');
      final keyHash = sha256.convert(encryptionKey).bytes;

      // Open Hive box with encryption
      var box = await Hive.openBox(
          'messageDetails',
          encryptionCipher: HiveAesCipher(keyHash)
      );

      await box.put('lastMessage_$chatRoomId', message); // Store last message in Hive
      debugLog('Updating last message');
    } catch (error) {
      debugLog('Error updating last message: $error');
    }
  }

  void _updateLastMessageTimestamp(DateTime timestamp, String chatRoomId) async {
    try {
      // Use the same encryption key as used in saving
      final encryptionKey = utf8.encode('vishnucanbeormaynotbegayinpinkfrogdress');
      final keyHash = sha256.convert(encryptionKey).bytes;

      // Open Hive box with encryption
      var box = await Hive.openBox(
          'messageDetails',
          encryptionCipher: HiveAesCipher(keyHash)
      );

      await box.put('lastMessageTimestamp_$chatRoomId', DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp));
      debugLog('Updating last message timestamp');
    } catch (error) {
      debugLog('Error updating last message timestamp: $error');
    }
  }

  Future<void> _saveMessagesToLocalStorage(RxList<DocumentSnapshotMock> messagesList) async {
    try {
      // Use a secure method to generate or retrieve your encryption key
      final encryptionKey = utf8.encode('vishnucanbeormaynotbegayinpinkfrogdress');
      final keyHash = sha256.convert(encryptionKey).bytes; // Hash the key to ensure it is 32 bytes long

      // Open Hive box with encryption
      var box = await Hive.openBox(
          'messageDetails',
          encryptionCipher: HiveAesCipher(keyHash)
      );

      List<String> messages = messagesList.map((doc) {
        Map<String, dynamic> data = doc.data();

        // Ensure timestamp is properly handled based on its type
        if (data['timestamp'] is Timestamp) {
          data['timestamp'] = (data['timestamp'] as Timestamp).millisecondsSinceEpoch;
        } else if (data['timestamp'] is int) {
          // Handle case where timestamp is already an int (from local storage)
          // No need to convert further
        } else {
          // Handle unexpected type gracefully or set default value
        }

        return jsonEncode(data);
      }).toList();

      await box.put(widget.chatroomid!, messages); // Store messages in Hive box
    } catch (error) {
      debugLog('Error saving messages to local storage: $error');
    }
  }

  Future<void> _loadMessagesFromLocalStorage() async {
    try {
      // Use the same encryption key as used in saving
      final encryptionKey = utf8.encode('vishnucanbeormaynotbegayinpinkfrogdress');
      final keyHash = sha256.convert(encryptionKey).bytes;

      // Open Hive box with encryption
      var box = await Hive.openBox(
          'messageDetails',
          encryptionCipher: HiveAesCipher(keyHash)
      );

      List<String>? messages = box.get(widget.chatroomid!) as List<String>?;

      if (messages != null) {
        // Get.snackbar('status', 'Hive loaded'); // Show a snack bar for indication
        debugLog('Loading messages from Hive');
        setState(() {
          _messagesList.value = messages.map((msg) {
            final data = jsonDecode(msg) as Map<String, dynamic>;
            String documentId = data['id'] ?? '';
            if (data.containsKey('timestamp') && data['timestamp'] != null) {
              data['timestamp'] = Timestamp.fromMillisecondsSinceEpoch(data['timestamp']);
            }
            if (_latestMessageTimestamp == null ||
                (data['timestamp'] as Timestamp).toDate().isAfter(_latestMessageTimestamp!)) {
              _latestMessageTimestamp = (data['timestamp'] as Timestamp).toDate();
            }
            return DocumentSnapshotMock(data, documentId);
          }).toList();
          _messagesLoaded = true;

          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
        });
      } else {
        // Get.snackbar('status', 'No messages found in Hive, loading fresh messages from Firestore'); // Show a snack bar for indication
        debugLog('No messages found in Hive');
      }
      _getMessagesFromFirestore(); // Listen to Firestore for new messages
    } catch (error) {
      debugLog('Error loading messages from Hive: $error');
      Get.snackbar('status', 'Error loading messages from Hive'); // Show a snack bar for indication
    }
  }


  @override
  void dispose() {
    _messagesSubscription?.cancel();
    myFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: InkWell(
            onTap: () async {
              await Hive.deleteBoxFromDisk('messageDetails');
              // Get.snackbar('error', 'hive cleared for messagedetails');
            },
            child: Text(
              otherEmail.split('@').first ?? 'Default Title',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _buildMessageList()),
              MessageInput(
                controller: _messageController,
                focusNode: myFocusNode,
                sendMessage: sendMessage,
              ),
              const SizedBox(height: 10)
            ],
          ),
          if (_showScrollButton)
            Positioned(
              bottom: Get.height * 0.11,
              right: 20,
              child: SizedBox(
                width: 43, // Increase size to maintain circular shape
                height: 43, // Increase size to maintain circular shape
                child: FloatingActionButton(
                  onPressed: scrollDown,
                  child: Icon(Icons.keyboard_double_arrow_down_rounded),
                  mini: true,
                  backgroundColor: Colors.grey.shade100,
                  shape: const CircleBorder(), // Ensures circular shape
                ),
              ),
            ),

        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (!_messagesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: _messagesList.length,
      itemBuilder: (context, index) {
        return _buildMessageItem(
          _messagesList[index],
          index,
          _messagesList.length,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index > 0) {
          var currentData = _messagesList[index].data();
          var previousData = _messagesList[index - 1].data();

          dynamic currentTimestamp = currentData['timestamp'];
          dynamic previousTimestamp = previousData['timestamp'];

          if (currentTimestamp != null && previousTimestamp != null) {
            DateTime currentDate;
            DateTime previousDate;

            if (currentTimestamp is Timestamp) {
              currentDate = currentTimestamp.toDate();
            } else if (currentTimestamp is int) {
              currentDate = DateTime.fromMillisecondsSinceEpoch(currentTimestamp);
            } else {
              return const SizedBox(); // Handle unexpected type gracefully
            }

            if (previousTimestamp is Timestamp) {
              previousDate = previousTimestamp.toDate();
            } else if (previousTimestamp is int) {
              previousDate = DateTime.fromMillisecondsSinceEpoch(previousTimestamp);
            } else {
              return const SizedBox(); // Handle unexpected type gracefully
            }

            if (currentDate.day != previousDate.day ||
                currentDate.month != previousDate.month ||
                currentDate.year != previousDate.year) {
              String formattedDate = DateFormat('dd MMMM yyyy').format(currentDate);
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30),
                child: Center(
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF21215E).withOpacity(0.7),
                    ),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshotMock document, int index, int totalCount) {
    Map<String, dynamic> data = document.data();

    bool isCurrentUser = data['senderId'] == _firebaseAuth.currentUser!.uid;
    DateTime timestamp;

    if (data['timestamp'] is Timestamp) {
      timestamp = (data['timestamp'] as Timestamp).toDate();
    } else if (data['timestamp'] is int) {
      timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int);
    } else {
      // Handle the case where timestamp is of unexpected type or null
      timestamp = DateTime.now(); // Provide a default timestamp
    }

    return MessageBubble(
      message: data['message'],
      senderId: data['senderId'],
      timestamp: timestamp,
      isCurrentUser: isCurrentUser,
      isLastMessage: index == totalCount - 1,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
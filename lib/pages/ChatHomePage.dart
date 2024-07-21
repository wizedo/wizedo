import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/colors.dart';
import '../components/debugcusprint.dart';
import '../controller/UserController.dart';
import '../services/chatservices/chatpage.dart';
import '../services/chatservices/chatservice.dart';
import 'LoginPage.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> with AutomaticKeepAliveClientMixin<ChatHomePage>{
  final ChatService _chatService = ChatService();
  String userCollegee = 'null';
  String userEmail = 'null';
  RxSet<String> existingChatRoomIds = <String>{}.obs;
  RxList<Map<String, dynamic>> userList = <Map<String, dynamic>>[].obs;
  late Timer _timer;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController userController = Get.find<UserController>();


  @override
  void initState() {
    super.initState();
    initializeData();
    // Start periodic timer to fetch last message details
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    debugLog('Disposed few stuff');
    super.dispose();
  }

  void _startTimer() {
    // Start a timer that runs every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Fetch last message details for all chat rooms in userList
      for (var userData in userList) {
        String chatRoomId = userData['chatRoomId'];
        _fetchLastMessageDetails(chatRoomId);
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  Future<void> initializeData() async {
    userEmail = userController.id;
    userCollegee= userController.college;
    await Hive.openBox<String>('avatars');
    checkRefreshKey();
  }

  Future<void> _initializeListeners(List<String> chatRoomIds) async {
    for (String chatRoomId in chatRoomIds) {
      _chatService.listenForNewMessages(chatRoomId);
    }
  }


  Future<void> checkRefreshKey() async {
    try {
      var box = await Hive.openBox('refreshKeyBox'); // Open Hive box for refresh key
      String? refreshKey = box.get('refreshKey');

      if (refreshKey == 'yes') {
        await Future.delayed(const Duration(seconds: 3), () {
          debugLog('setState called for yes');
        });

        box.put('refreshKey', 'no'); // Update refresh key in Hive
      }
    } catch (error) {
      debugLog('Error checking refresh key: $error');
    }
  }

  Future<DateTime?> getLastMessageTimestamp(String chatRoomId) async {
    try {
      var box = await Hive.openBox('messageTimestamps'); // Open Hive box for message timestamps
      String? timestampString = box.get('lastMessageTimestamp_$chatRoomId');

      if (timestampString != null) {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(timestampString));
      } else {
        return null;
      }
    } catch (error) {
      debugLog('Error fetching last message timestamp: $error');
      return null;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(const LoginPage());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[20],
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {});
              },
              child: const Text(
                'Messages',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
          backgroundColor: backgroundColor,
          actions: const [],
          automaticallyImplyLeading: false,
        ),
        body: _buildUserList(),
      ),
    );
  }

  final Map<String, String> _avatarCache = {};
  bool _avatarsLoaded = false;

  Future<void> _preloadAvatars() async {
    for (int i = 0; i < userList.length; i++) {
      var userData = userList[i];
      String otherUserEmail = (userData['workeremail'] == userEmail)
          ? userData['recieveremail']
          : userData['workeremail'];
      await getAvatarUrl(otherUserEmail);
    }
    setState(() {
      _avatarsLoaded = true;
    });
  }


  Future<String?> getAvatarUrl(String email) async {
    var avatarBox = Hive.box<String>('avatars');

    if (_avatarCache.containsKey(email)) {
      // print('avatar from cache');
      return _avatarCache[email];
    }

    if (avatarBox.containsKey(email)) {
      // print('avatar from hive');
      final avatar = avatarBox.get(email);
      _avatarCache[email] = avatar!;
      return avatar;
    }

    try {
      final docSnapshot = await _firestore.collection('usersDetails').doc(email).get();
      if (docSnapshot.exists) {
        final userData = docSnapshot.data() as Map<String, dynamic>;
        final avatarName = userData['avatar'];
        if (avatarName != null && avatarName is String) {
          // print('inside firestore fetching');
          final avatarPath = _mapAvatarNameToPath(avatarName);
          avatarBox.put(email, avatarPath);
          _avatarCache[email] = avatarPath;
          return avatarPath;
        } else {
          // print('default firestore');
          final defaultAvatar = _mapAvatarNameToPath('default');
          avatarBox.put(email, defaultAvatar);
          _avatarCache[email] = defaultAvatar;
          return defaultAvatar;
        }
      } else {
        // print('else firestore');
        final otherAvatar = _mapAvatarNameToPath('otherAvatarName');
        avatarBox.put(email, otherAvatar);
        _avatarCache[email] = otherAvatar;
        return otherAvatar;
      }
    } catch (error) {
      debugLog('Error fetching avatar for $email: $error');
      final phoneScreenAvatar = _mapAvatarNameToPath('default');
      avatarBox.put(email, phoneScreenAvatar);
      _avatarCache[email] = phoneScreenAvatar;
      return phoneScreenAvatar;
    }
  }

  String _mapAvatarNameToPath(String avatarName) {
    switch (avatarName) {
      case 'beardo':
        return 'lib/images/beardo.png';
      case 'bhola':
        return 'lib/images/bhola.png';
      case 'freestyle':
        return 'lib/images/freestyle.png';
      case 'goodboi':
        return 'lib/images/goodboi.png';
      case 'gorigori':
        return 'lib/images/gorigori.png';
      case 'happyindian':
        return 'lib/images/happyindian.png';
      case 'orangewolf':
        return 'lib/images/orangewolf.png';
      case 'ponitail':
        return 'lib/images/ponitail.png';
      case 'purploo':
        return 'lib/images/purploo.png';
      case 'sanyasi':
        return 'lib/images/sanyasi.png';
      case 'smile':
        return 'lib/images/smile.png';
      case 'tintin':
        return 'lib/images/tintin.png';
      case 'nerdy':
        return 'lib/images/nerdy.png';
      case 'bush':
        return 'lib/images/bush.png';
      case 'lovemelikeyoudo':
        return 'lib/images/lovemelikeyoudo.png';
      case 'carefree':
        return 'lib/images/carefree.png';
      case 'tate':
        return 'lib/images/tate.png';
      default:
        return 'lib/images/uname.png';
    }
  }



  Widget _buildUserList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FutureBuilder(
        future: _fetchUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugLog('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Obx(() {
            if (userList.isEmpty) {
              return const Center(
                child: Text(
                  'No activity yet. Start posting and accepting to contact someone.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              );
            }

            if (!_avatarsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Widget> userItems = userList.map((userData) {
              String otherUserEmail = (userData['workeremail'] == userEmail)
                  ? userData['recieveremail']
                  : userData['workeremail'];

              String displayName = otherUserEmail.split('@').first;
              String lastMessage = userData['lastMessage'] ?? '';
              String lastMessageTimestamp = userData['lastMessageTimestamp'] ?? '';
              String? avatarPath = _avatarCache[otherUserEmail];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiveruserEmail: userData['emailid'],
                        receiverUserID: userData['userId'],
                        workeremail: userData['workeremail'],
                        recieveremail: userData['recieveremail'],
                        chatroomid: userData['chatRoomId'],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: ListTile(
                    leading: avatarPath != null
                        ? Image.asset(
                      avatarPath,
                      width: 55,
                      height: 55,
                    )
                        : const Icon(Icons.person, size: 50),
                    // dense: true,//later i can consider this
                    title: Row(
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '-',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        FutureBuilder(
                          future: _fetchSubCategoriesForChatRoom(userData['chatRoomId']),
                          builder: (context, subCategorySnapshot) {
                            if (subCategorySnapshot.hasData) {
                              List<String>? subCategories = subCategorySnapshot.data;
                              String subCategoriesText = subCategories!.join(', ');

                              if (subCategoriesText.length > 27) {
                                subCategoriesText = '${subCategoriesText.substring(0, 30)}...';
                              }

                              return Expanded(
                                child: Text(
                                  subCategoriesText,
                                  style: const TextStyle(fontSize: 9, color: Colors.black),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  lastMessage,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 11, color: Colors.black),
                                ),
                              ),
                              Text(
                                lastMessageTimestamp,
                                style: const TextStyle(fontSize: 9, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 3));
                setState(() {});
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
      return DateFormat('hh:mm a').format(dateTime); // Format as 12-hour time
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

    List<QueryDocumentSnapshot> combinedResults = [...snapshot1.docs, ...snapshot2.docs];

    for (var doc in combinedResults) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String otherUseId = (data['workeremail'] == userEmail)
          ? data['recieveremail']
          : data['workeremail'];

      if (userEmail != otherUseId) {
        String? chatRoomId = data['chatRoomId'];

        if (chatRoomId != null) {
          if (!existingChatRoomIds.contains(chatRoomId)) {
            userList.add(data);
            existingChatRoomIds.add(chatRoomId);
            existingChatRoomIds.refresh();
            await _fetchLastMessageDetails(chatRoomId);
            _initializeListeners(existingChatRoomIds.toList());
            _preloadAvatars();
          }
        } else {
          chatRoomId = FirebaseFirestore.instance.collection('chatRooms').doc().id;
          await FirebaseFirestore.instance
              .collection('colleges')
              .doc(userCollegee)
              .collection('collegePosts')
              .doc(doc.id)
              .update({'chatRoomId': chatRoomId});
          userList.add(data);
          existingChatRoomIds.add(chatRoomId);
          existingChatRoomIds.refresh();
          await _fetchLastMessageDetails(chatRoomId);
          debugLog('these are existing chatroomids $existingChatRoomIds');
          _initializeListeners(existingChatRoomIds.toList());
          _preloadAvatars();

        }
      }
    }

    return userList;
  }

  Future<void> _fetchLastMessageDetails(String chatRoomId) async {
    try {
      // Use the same encryption key as used in saving
      final encryptionKey = utf8.encode('vishnucanbeormaynotbegayinpinkfrogdress');
      final keyHash = sha256.convert(encryptionKey).bytes;

      // Open Hive box with encryption
      var box = await Hive.openBox(
          'messageDetails',
          encryptionCipher: HiveAesCipher(keyHash)
      );

      String? lastMessage = box.get('lastMessage_$chatRoomId');
      String? timestampString = box.get('lastMessageTimestamp_$chatRoomId');
      String formattedTime = '';

      if (timestampString != null) {
        try {
          DateTime dateTime = DateTime.parse(timestampString); // Parse timestampString to DateTime
          formattedTime = DateFormat('hh:mm a').format(dateTime); // Format as 12-hour time
        } catch (e) {
          debugLog('Error parsing timestampString: $e');
        }
      }

      for (var user in userList) {
        if (user['chatRoomId'] == chatRoomId) {
          user['lastMessage'] = lastMessage;
          user['lastMessageTimestamp'] = formattedTime;
        }
      }
      userList.refresh(); // Update the UI after fetching details
    } catch (error) {
      debugLog('Error fetching last message details: $error');
    }
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

    for (var doc in snapshot.docs) {
      String subCategory = doc['subCategory'];
      subCategories.add(subCategory);
    }

    return subCategories;
  }
}

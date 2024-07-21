
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:wizedo/components/my_timeline_tile.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/debugcusprint.dart';
import '../components/mPlusRoundedText.dart';
import '../components/my_elevatedbutton.dart';
import '../controller/BottomNavigationController.dart';
import '../controller/UserController.dart';
import '../services/chatservices/chatcontroller.dart';
import 'BottomNavigation.dart';

class statusPage extends StatefulWidget {
  final String? postid;
  final int? priceRange;
  final String? chatroomid;

  const statusPage({
    super.key,
    this.postid,
    this.priceRange,
    this.chatroomid
  });

  @override
  State<statusPage> createState() => _statusPageState();
}

class _statusPageState extends State<statusPage> {
  String userCollegee = 'null';
  String userEmail = 'null';
  final ChatController _chatController = Get.put(ChatController());
  final BottomNavigationController _bottomNavigationController = Get.find<BottomNavigationController>();
  final UserController userController = Get.find<UserController>();



  Future<void> saveRefreshKeyLocally() async {
    try {
      var box = await Hive.openBox('refreshKeyBox'); // Open Hive box for refresh key
      await box.put('refreshKey', 'yes'); // Store refresh key in Hive
      debugLog('Refresh key saved locally');
    } catch (error) {
      debugLog('Error saving refresh key locally: $error');
    }
  }

  @override
  void initState() {
    debugLog('Post ID in status page is: ${widget.postid}');
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userEmail = userController.id;
    userCollegee = userController.college;
  }

  Future<void> checkAppliedStatus() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('colleges')
          .doc(userCollegee)
          .collection('collegePosts')
          .where('chatRoomId', isEqualTo: widget.chatroomid)
          .where('status', isEqualTo: 'Applied')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        debugLog('Exists cannot delete chatroom');
      } else {
        if (widget.chatroomid != null) {
          _chatController.deleteChat(widget.chatroomid!);
          debugLog('Doesn\'t exist can delete chatroom');
        } else {
          debugLog('chatroomid is null, cannot delete chatroom');
        }
        debugLog('Doesn\'t exist can delete chatroom');
      }
    } catch (error) {
      debugLog('Error checking applied status: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Price: ${widget.priceRange}',
          style: mPlusRoundedText.copyWith(fontSize: 24, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 2,left: 25,right: 20),
        child: ListView(
          children: [
            Container(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('colleges')
                    .doc(userCollegee)
                    .collection('collegePosts')
                    .doc(widget.postid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.active) {
                    debugLog('i am in status page 1');
                    if (snapshot.hasData && snapshot.data!.exists) {
                      debugLog('i am in status page 2');

                      Map<String, dynamic> documentData = snapshot.data!.data() as Map<String, dynamic>;
                      int pstatus = documentData['pstatus'] ?? 0;
                      String status =documentData['status']!;


                      // Check if userEmail is the same as the worker's email
                      bool isUserWorker = userEmail == documentData['workeremail'];
                      debugLog(isUserWorker);

                      // Create a list to hold MyTimeLineTile widgets
                      List<Widget> timelineWidgets = [];


                      if (userEmail != documentData['workeremail']) {
                        // Add other MyTimeLineTile widgets as needed
                        timelineWidgets.add(
                          MyTimeLineTile(
                            isFirst: true,
                            isLast: false,
                            isPast: pstatus >= 1,
                            eventCard: const Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WhiteText('Task Created', fontWeight: FontWeight.bold, fontSize: 16,),
                                  WhiteText('Task has been posted waiting for someone to accept your task',fontSize: 12),
                                ],
                              ),
                            ),
                          ),
                        );

                        timelineWidgets.add(
                          Column(
                            children: [
                              MyTimeLineTile(
                                isFirst: false,
                                isLast: false,
                                isPast: pstatus >= 2,
                                eventCard: const Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WhiteText('Task Accepted', fontWeight: FontWeight.bold, fontSize: 16,),
                                      WhiteText('Task has been accepted, awaiting confirmation.', fontSize: 12),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: pstatus != 4 && pstatus != 5 && pstatus != 6 && pstatus != 1 && status!='Completed',
                                    child: ElevatedButton(
                                      onPressed: pstatus == 3 ? null : () async {
                                        Get.defaultDialog(
                                          title: 'Confirmation',
                                          titlePadding: const EdgeInsets.only(top: 20),
                                          contentPadding: const EdgeInsets.all(25),
                                          middleText: "Canceling without Confirmation means you're giving up on completing this task. Are you sure?",
                                          confirm: TextButton(
                                            onPressed: () async {
                                              final firestore = FirebaseFirestore.instance;
                                              await firestore.runTransaction((transaction) async {
                                                final collegePostRef = firestore
                                                    .collection('colleges')
                                                    .doc(userCollegee)
                                                    .collection('collegePosts')
                                                    .doc(widget.postid);
                                                transaction.update(collegePostRef, {
                                                  'pstatus': 0, // it should be 1 actually
                                                  'status': 'active'
                                                });
                                              });
                                              Get.back(); // Going back using GetX
                                              Get.back(); // Going back using GetX
                                              Get.back(); // Going back using GetX
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          cancel: TextButton(
                                            onPressed: () {
                                              Get.back(); // Going back using GetX
                                            },
                                            child: const Text('No'),
                                          ),
                                        );
                                      },
                                      child: Text(pstatus == 3 ? 'Confirmed' : 'Cancel'),
                                    ),
                                  ),

                                  const SizedBox(width: 40,),
                                  Visibility(
                                    visible: pstatus != 4 && pstatus != 5 && pstatus !=6 && pstatus !=1 && pstatus !=3 && status!='Completed',
                                    child: MyElevatedButton(
                                      onPressed: () async {
                                        final firestore = FirebaseFirestore.instance;
                                        String chatRoomId;

                                        List<String> ids = [
                                          documentData['workeremail'] ?? '',
                                          documentData['emailid'] ?? '',
                                        ];

                                        chatRoomId = ids.join("_unisepx_");

                                        // Check if the reversed form of chatRoomId is already present in Firestore
                                        String reversedChatRoomId = ids.reversed.join("_unisepx_");
                                        debugLog(reversedChatRoomId);
                                        final reversedChatRoomSnapshot = await firestore
                                            .collection('chat_rooms')
                                            .doc(reversedChatRoomId)
                                            .get();

                                        debugLog(reversedChatRoomSnapshot);

                                        debugLog('reverse chatroom found');
                                        // Use the reversed form if it exists
                                        chatRoomId = reversedChatRoomId;
                                      
                                        // Update the document with the chatRoomId
                                        await firestore.runTransaction((transaction) async {
                                          final collegePostRef = firestore
                                              .collection('colleges')
                                              .doc(userCollegee)
                                              .collection('collegePosts')
                                              .doc(widget.postid);

                                          transaction.update(collegePostRef, {
                                            'pstatus': 3,
                                            'amountpaid': 'yes',
                                            'chatRoomId': chatRoomId,
                                          });

                                          saveRefreshKeyLocally();
                                          Get.snackbar('Success', 'Confirmed successfully');
                                          await Future.delayed(const Duration(seconds: 5));

                                          Get.to(const BottomNavigation());
                                          _bottomNavigationController.changePage(2);
                                          // Navigate to the chat page
                                        });

                                      },
                                      width: 180,
                                      height: 40,
                                      borderRadius: 20,
                                      buttonText: 'Confirm',
                                    ),

                                  ),
                                ],
                              ),
                            ],
                          ),
                        );

                        timelineWidgets.add(
                          MyTimeLineTile(
                            isFirst: false,
                            isLast: false,
                            isPast: pstatus >= 3,
                            eventCard: const Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WhiteText('In Progress', fontWeight: FontWeight.bold, fontSize: 16,),
                                  WhiteText('......',fontSize: 12),
                                ],
                              ),
                            ),
                          ),
                        );

                        timelineWidgets.add(
                          Column(
                            children: [
                              MyTimeLineTile(
                                isFirst: false,
                                isLast: true,
                                isPast: pstatus >= 6,
                                eventCard: const Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WhiteText('Task Completed', fontWeight: FontWeight.bold, fontSize: 16,),
                                      WhiteText('Review and approve for confirmation.', fontSize: 12),
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const SizedBox(height: 10,),
                                    Visibility(
                                      visible: pstatus != 1 && pstatus !=2 && pstatus !=3 && pstatus !=5 && pstatus !=4 && status!='Completed',
                                      child: MyElevatedButton(
                                        onPressed: () async {
                                          Get.defaultDialog(
                                            // backgroundColor: Colors.transparent,
                                              title: 'Confirmation',
                                              titlePadding: const EdgeInsets.only(top: 20),
                                              contentPadding: const EdgeInsets.all(25),
                                              middleText: "By confirming, you authorize the release of confirm to the user for the completed task. Are you sure you want to proceed?",
                                              confirm: TextButton(
                                                  onPressed: () async {
                                                    final firestore = FirebaseFirestore.instance;
                                                    await firestore.runTransaction((transaction) async {
                                                      final collegePostRef = firestore
                                                          .collection('colleges')
                                                          .doc(userCollegee)
                                                          .collection('collegePosts')
                                                          .doc(widget.postid);
                                                      transaction.update(collegePostRef, {
                                                        'pstatus':8,
                                                        'status':'Completed'
                                                      });
                                                    });

                                                    await checkAppliedStatus();
                                                    final docRef = FirebaseFirestore.instance.collection('usersDetails').doc(documentData['workeremail']);
                                                    // Use a transaction to update totalapplied
                                                    FirebaseFirestore.instance.runTransaction((transaction) async {
                                                      final totalapplied = await transaction.get(docRef);
                                                      if (totalapplied.exists) {
                                                        // Increment totalapplied by one
                                                        int newTotalApplied = (totalapplied.data()?['totalapplied'] ?? 0) - 1;
                                                        debugLog('new toatal appllied posts are $newTotalApplied');
                                                        transaction.update(docRef, {'totalapplied': newTotalApplied});
                                                      }
                                                    });
                                                    await checkAppliedStatus();
                                                    Get.back(); // Going back using getx
                                                    Get.back(); // Going back using getx
                                                    Get.back(); // Going back using getx
                                                  },
                                                  child: const Text('Yes')),
                                              cancel: TextButton(
                                                  onPressed: (){
                                                    Get.back(); // Going back using getx
                                                  },
                                                  child: const Text('No'))
                                          );
                                        },
                                        width: Get.width* 0.6,
                                        height: Get.height * 0.065,
                                        borderRadius: 30,
                                        mfontsize:12,
                                        melevation: 50,
                                        buttonText: 'Approve',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else {
                        // Add other MyTimeLineTile widgets as needed
                        timelineWidgets.add(
                          MyTimeLineTile(
                            isFirst: true,
                            isLast: false,
                            isPast: pstatus >= 1,
                            eventCard: const Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WhiteText('Task Accepted', fontWeight: FontWeight.bold, fontSize: 16,),
                                  WhiteText('Task has been accepted by you, awaiting user confirmation to connect with each other.',fontSize: 12),
                                ],
                              ),
                            ),
                          ),
                        );

                        timelineWidgets.add(
                          Column(
                            children: [
                              MyTimeLineTile(
                                isFirst: false,
                                isLast: false,
                                isPast: pstatus >= 3,
                                eventCard: const Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WhiteText('User Accepted', fontWeight: FontWeight.bold, fontSize: 16,),
                                      WhiteText('Complete the assigned task.', fontSize: 12),
                                      // WhiteText("Note: Funds will be credited to your registered phone number. Ensure it is linked to your bank account.", fontSize: 9),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: pstatus != 4 && pstatus != 5 && pstatus != 6 && pstatus != 1 && pstatus != 2, // Show the button when pstatus is not 4, 5, 6, 1, or 2
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final firestore = FirebaseFirestore.instance;
                                        await firestore.runTransaction((transaction) async {
                                          final collegePostRef = firestore
                                              .collection('colleges')
                                              .doc(userCollegee)
                                              .collection('collegePosts')
                                              .doc(widget.postid);
                                          transaction.update(collegePostRef, {
                                            'pstatus': 4,
                                          });
                                        });

                                        Get.to(const BottomNavigation());
                                        _bottomNavigationController.changePage(2);
                                      },
                                      child: const Text('Chat'),
                                    ),
                                  ),
                                  Visibility(
                                    visible: pstatus == 4 && status!='Completed', // Show the "Request Payment" button only when pstatus is 4
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final firestore = FirebaseFirestore.instance;
                                        await firestore.runTransaction((transaction) async {
                                          final collegePostRef = firestore
                                              .collection('colleges')
                                              .doc(userCollegee)
                                              .collection('collegePosts')
                                              .doc(widget.postid);
                                          transaction.update(collegePostRef, {
                                            'pstatus': 6, // Update pstatus to 5
                                          });
                                        });
                                      },
                                      child: const Text('Request Review'),
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                ],
                              ),

                            ],
                          ),
                        );

                      }

                      return Column(
                        children: timelineWidgets,
                      );
                    } else {
                      return const Center(
                        child: Text('No active posts', style: TextStyle(color: Colors.black)),
                      );
                    }
                  }

                  return const Center(
                    child: Text('Something went wrong'),
                  );
                },
              ),



            ),
            //start timeline
            // task posted
            //
            // task assigned
            // task has been accepted waiting for the payment
            // In progress
            //
            // task completed
          ],
        ),
      ),
    );
  }
}

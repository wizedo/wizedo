import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/ActiveCard.dart';
import '../components/CustomFilterChip.dart';
import '../components/debugcusprint.dart';
import '../components/myCustomAppliedCard.dart';
import '../controller/UserController.dart';
import 'ActiveParticularDetailScreen.dart';
import 'ParticularPostDetailScreen.dart';

class acceptedPage extends StatefulWidget {
  const acceptedPage({super.key});

  @override
  State<acceptedPage> createState() => _acceptedPageState();
}

class _acceptedPageState extends State<acceptedPage> {
  String _selectedCategory = 'Active';
  String userCollegee = 'null';
  String userEmail = 'null';
  final UserController userController = Get.find<UserController>();
  final ScrollController _scrollControllerforacceptedpage = ScrollController();



  // Function to clean up the username
  String cleanUpUserName(String email) {
    // Extract the username part from the email (remove @gmail.com)
    String userName = email.split('@')[0];
    // Remove any special characters
    userName = userName.replaceAll(RegExp(r'[^\w\s]'), '');
    // Remove any numbers
    userName = userName.replaceAll(RegExp(r'\d'), '');
    debugLog(userName);
    return userName;
  }


  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userEmail =userController.id;
    userCollegee = userController.college;
  }


  List<String> categories = [
    'Applied',
    'Active',
    'Received',
  ];

  void _scrollToCategory(String category) {
    double offset = 0.0;
    switch (category) {
      case 'Applied':
        offset = 0.0;
        break;
      case 'Active':
        offset = 160.0; // Adjust this value based on your layout
        break;
      case 'Received':
        offset = 330.0; // Adjust this value based on your layout
        break;
    }
    _scrollControllerforacceptedpage.animateTo(
      offset,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _changeCategory(int direction) {
    setState(() {
      int index = categories.indexOf(_selectedCategory);
      int newIndex = (index + direction) % categories.length;
      if (newIndex < 0) {
        newIndex = categories.length - 1;
      }
      _selectedCategory = categories[newIndex];
      _scrollToCategory(_selectedCategory); // Scroll to the new category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const WhiteText(
          'Proposals & offers',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF211B2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollControllerforacceptedpage,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 30,bottom: 10),
                  child: Row(
                    children: [
                      CustomFilterChip(
                        label: 'Applied',
                        isSelected: _selectedCategory == 'Applied',
                        onSelected: (isSelected) {
                          setState(() {
                            _scrollToCategory('Applied');
                            _selectedCategory = isSelected ? 'Applied' : '';
                          });
                        },
                      ),
                      const SizedBox(width: 8), // Adjust spacing as needed
                      CustomFilterChip(
                        label: 'Active',
                        isSelected: _selectedCategory == 'Active',
                        onSelected: (isSelected) {
                          setState(() {
                            _scrollToCategory('Active');
                            _selectedCategory = isSelected ? 'Active' : '';
                          });
                        },
                      ),
                      const SizedBox(width: 8), // Adjust spacing as needed
                      CustomFilterChip(
                        label: 'Received',
                        isSelected: _selectedCategory == 'Received',
                        onSelected: (isSelected) {
                          setState(() {
                            _scrollToCategory('Received');
                            _selectedCategory = isSelected ? 'Received' : '';
                          });
                        },
                      ),
                      // SizedBox(width: 60), // Adjust spacing as needed
                      // Add more CustomFilterChip widgets as needed
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (details.primaryVelocity! > 0) {
                      _changeCategory(-1);
                    } else if (details.primaryVelocity! < 0) {
                      _changeCategory(1);
                    }
                  },
                child: _selectedCategory == 'Active'
                    ? ActiveContainer(userCollegee: userCollegee, userEmail: userEmail,)
                    : SizedBox(
                  width: Get.width*0.99,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                        .collection('colleges')
                        .doc(userCollegee)
                        .collection('collegePosts')
                        .where('status', isEqualTo: 'Applied')
                                        // .where('status', whereIn: ['Applied', 'Completed'])// To filter either one
                        .where(_selectedCategory == 'Applied' ? 'workeremail' : 'recieveremail',
                        isEqualTo: userEmail)
                        .snapshots(),
                                        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              var data = snapshot.data!.docs[index].data();
                              Timestamp date = snapshot.data!.docs[index]['createdAt'];
                              var finalDate = DateTime.parse(date.toDate().toString());

                              return GestureDetector(
                                onTap: () {
                                  debugLog(data);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ParticularPostDetailScreen(
                                          category: data['category'],
                                          subject: data['subCategory'],
                                          date: data['createdAt'],
                                          description: data['description'],
                                          priceRange: data['totalPayment'],
                                          finalDate: data['dueDate'],
                                          postid: data['postId'],
                                          emailid: data['emailid'],
                                          googledrivelink: data['googledrivelink'],
                                          chatroomid: data['chatRoomId']),
                                    ),
                                  );
                                },
                                child: MyCustomCard(
                                  subject: data['subCategory'],
                                  createdAt: data['createdAt'],
                                  priceRange: data['totalPayment'].toString(), // Check for null
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: WhiteText('No activity yet'),
                          );
                        }
                      }
                      return const Center(
                        child: Text('Something went wrong'),
                      );
                                        },
                                      ),
                    ),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}




class ActiveContainer extends StatelessWidget {
  final String userCollegee;
  final String userEmail;

  const ActiveContainer({super.key, required this.userCollegee, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: Get.width*0.99,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('colleges')
                  .doc(userCollegee)
                  .collection('collegePosts')
                  .where('status', isEqualTo: 'active')
                  .where('emailid', isEqualTo: userEmail)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true, // Use shrinkWrap to make ListView adjust its size based on children
                      physics: const NeverScrollableScrollPhysics(), // Prevent the ListView from scrolling separately
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data!.docs[index].data();
                        Timestamp date = snapshot.data!.docs[index]['createdAt'];
                        var finalDate = DateTime.parse(date.toDate().toString());

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActiveParticularDetailScreen(
                                  category: data['category'],
                                  subject: data['subCategory'],
                                  date: data['createdAt'],
                                  description: data['description'],
                                  priceRange: data['totalPayment'],
                                  finalDate: data['dueDate'],
                                  postid: data['postId'],
                                  emailid: data['emailid'],
                                  googledrivelink: data['googledrivelink'],
                                  collegename: data['collegeName'],
                                ),
                              ),
                            );
                          },
                          child: ActiveCard(
                            subject: data['subCategory'],
                            createdAt: data['createdAt'],
                            priceRange: data['totalPayment'].toString(), // Check for null
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox(
                      height: 500, // Adjust the height as needed
                      child: Center(
                        child: WhiteText('No activity yet'),
                      ),
                    );
                  }
                }
                return const Center(
                  child: Text('Something went wrong'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:wizedo/components/ActiveCard.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/debugcusprint.dart';
import '../controller/UserController.dart';
import 'ActiveParticularDetailScreen.dart';

class ActivePosts extends StatefulWidget {
  const ActivePosts({super.key});

  @override
  State<ActivePosts> createState() => _ActivePostsState();
}

class _ActivePostsState extends State<ActivePosts> {
  String userCollegee = 'null';
  String userEmail='null';
  double screenHeight = Get.height;
  final UserController userController = Get.find<UserController>();



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
    userEmail = userController.id;
    userCollegee = userController.college;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const WhiteText(
          'Your Posts',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: (){
            Get.back();
          },
        ),
      ),
      backgroundColor: const Color(0xFF211B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 360,
                    height: screenHeight*0.9,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('colleges')
                          .doc(userCollegee)
                          .collection('collegePosts')
                          .where('status', isEqualTo: 'active')
                          .where('emailid',isEqualTo: userEmail)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState == ConnectionState.active) {
                          debugLog('i am in accpeted page 1');
                          if (snapshot.data!.docs.isNotEmpty) {
                            debugLog('i am in accpeted page 2');
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
                                        builder: (context) => ActiveParticularDetailScreen(
                                          category: data['category'],
                                          subject: data['subCategory'],
                                          date: data['createdAt'],
                                          description: data['description'],
                                          priceRange: data['totalPayment'],
                                          finalDate: data['dueDate'],
                                          postid: data['postId'],
                                          emailid: data['emailid'],
                                          googledrivelink:data['googledrivelink'],
                                          collegename:data['collegeName']
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
                            return const Center(
                              child: WhiteText('No completed tasks'),
                            );
                          }
                        }
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

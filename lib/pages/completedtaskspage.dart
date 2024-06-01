import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/JobCard.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/FliterChip.dart';
import '../components/HistoryCard.dart';
import '../components/myCustomAppliedCard.dart';
import 'ParticularPostDetailScreen.dart';
import 'detailsPage.dart';

class CompletedTasksPage extends StatefulWidget {
  const CompletedTasksPage({Key? key});

  @override
  State<CompletedTasksPage> createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  String userCollegee = 'null';
  String userEmail='null';
  double screenHeight = Get.height;


  // Function to clean up the username
  String cleanUpUserName(String email) {
    // Extract the username part from the email (remove @gmail.com)
    String userName = email.split('@')[0];
    // Remove any special characters
    userName = userName.replaceAll(RegExp(r'[^\w\s]'), '');
    // Remove any numbers
    userName = userName.replaceAll(RegExp(r'\d'), '');
    print(userName);
    return userName;
  }
  Future<String> getUserEmailLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('userEmail');
      print('my username in acceptedjobs page is: $userEmail');
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
      print('i am in acceptedjobs page');
      String? email=await getUserEmailLocally();
      String? userCollege = await getSelectedCollegeLocally(email!);
      setState(() {
        userCollegee = userCollege ?? 'null set manually2';
        print('User College in acceptedpage: $userCollegee'); // Print the user's college name
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: WhiteText(
          'History',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: (){
            Get.back();
          },
        ),
      ),
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 360,
                    height: screenHeight*0.9,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('colleges')
                          .doc(userCollegee)
                          .collection('collegePosts')
                          .where('status', isEqualTo: 'Completed')
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState == ConnectionState.active) {
                          print('i am in accpeted page 1');
                          if (snapshot.data!.docs.isNotEmpty) {
                            print('i am in accpeted page 2');
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                Timestamp date = snapshot.data!.docs[index]['createdAt'];
                                var finalDate = DateTime.parse(date.toDate().toString());

                                return GestureDetector(
                                  onTap: () {
                                    print(data);
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
                                          googledrivelink:data['googledrivelink'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: HistoryCard(
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
                        return Center(
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/FliterChip.dart';
import '../components/myCustomAppliedCard.dart';
import 'ParticularPostDetailScreen.dart';

class acceptedPage extends StatefulWidget {
  const acceptedPage({Key? key});

  @override
  State<acceptedPage> createState() => _acceptedPageState();
}

class _acceptedPageState extends State<acceptedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedCategory = 'Applied';
  String userCollegee = 'null';
  String userEmail='null';


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
          'Proposals & offers',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [

                Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5,left: 40),
                        child: Row(
                          children: [
                            FilterChipWidget(
                              label: 'Applied',
                              fontSize: 11,
                              selectedCategory: _selectedCategory,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = 'Applied';
                                });
                              },
                              width: 180,
                              height: 37,
                            ),
                            FilterChipWidget(
                              label: 'Recieved',
                              fontSize: 11,
                              selectedCategory: _selectedCategory,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = 'Recieved';
                                });
                              },
                              width: 180,
                              height: 37,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      height: 45,
                      color: Color(0xFF211B2E),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25,top: 5,right: 10),
                        child: Icon(
                          CupertinoIcons.tags_solid,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                  ],
                ),

                Center(
                  child: Container(
                    width: 360,
                    height: 500,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('colleges')
                          .doc(userCollegee)
                          .collection('collegePosts')
                          .where('status', isEqualTo: 'Applied')
                          // .where('status', whereIn: ['Applied', 'Completed'])// To filter either one
                          .where(_selectedCategory == 'Applied' ? 'workeremail' : 'recieveremail', isEqualTo: userEmail)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState == ConnectionState.active) {
                          if (snapshot.data!.docs.isNotEmpty) {

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
                                          googledrivelink: data['googledrivelink'],
                                          chatroomid: data['chatRoomId']
                                        ),
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

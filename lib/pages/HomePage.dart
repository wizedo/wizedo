import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/CustomRichText.dart';
import 'package:wizedo/components/searchable_dropdown.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:shimmer/shimmer.dart';
import '../components/FliterChip.dart';
import '../components/JobCard.dart';
import '../controller/BottomNavigationController.dart';
import '../services/email_verification_page.dart';
import 'LoginPage.dart';
import 'detailsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController=TextEditingController();

  String _selectedCategory = 'College Project';
  String userCollegee = 'null';

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Get.snackbar('Success', 'Sign out successful');
      Get.offAll(() => LoginPage());
    } catch (error) {
      Get.snackbar('Error', 'Error signing out: $error');
    }
  }

  Future<String?> getUserEmailLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('userEmail');
      return userEmail;
    } catch (error) {
      print('Error fetching user email locally: $error');
      return null;
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
        String? email=await getUserEmailLocally();
        String? userCollege = await getSelectedCollegeLocally(email!);
        setState(() {
          userCollegee = userCollege ?? 'null set manually2';
          print('User College in homepage: $userCollegee'); // Print the user's college name
        });

    } catch (error) {
      print('Error getting user college: $error');
    }
  }


  // Function to clean up the username
  String cleanUpUserName(String email) {
    // Extract the username part from the email (remove @gmail.com)
    String userName = email.split('@')[0];

    // Remove any special characters
    userName = userName.replaceAll(RegExp(r'[^\w\s]'), '');

    // Remove any numbers
    userName = userName.replaceAll(RegExp(r'\d'), '');

    return userName;
  }

  @override
  void initState() {
    super.initState();
    getUserCollege();
    print('below is height we got using getx');
    print(Get.height);
  }

  @override
  Widget build(BuildContext context) {
    // Color(0xFF211B2E),
    return Scaffold(
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomRichText(
                            firstText: 'Peer',
                            secondText: 'mate',
                            firstColor: Colors.white,
                            secondColor: Color(0xFF955AF2),
                            firstFontSize: 20,
                            secondFontSize: 20,
                          ),
                          WhiteText('Learn Together, Achieve Together',fontSize: 12,)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Floating Action Button
                          Container(
                            width: 52.0,
                            height: 52.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Container(
                                width: 46.0,
                                height: 46.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF955AF2).withOpacity(0.1),

                                ),
                                child: Center(
                                  child: Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFF955AF2).withOpacity(0.1),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color(0xFF39304D).withOpacity(0.9),
                                        ),
                                        child: FloatingActionButton(
                                          backgroundColor: Colors.transparent,
                                          onPressed: () {
                                            if (_auth.currentUser != null) {
                                              String userEmail = _auth.currentUser!.email ?? "No email available";
                                              Get.snackbar('Current User', 'Email: $userEmail');
                                            } else {
                                              Get.snackbar('Error', 'No user signed in');
                                            }
                                            print('Redirected to Post Page');
                                          },
                                          tooltip: 'Increment',
                                          child: Icon(Icons.notifications_on_rounded, color: Colors.white, size: 15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25,right: 20,left: 20,bottom: 10),
              child: SearchableDropdownTextField(
                items: [
                  'Bachelor of Arts (BA)',
                  'Bachelor of Science (BSc)',
                  'Bachelor of Commerce (BCom)',
                  'Bachelor of Technology (BTech)',
                  'Bachelor of Business Administration (BBA)',
                  'Bachelor of Computer Applications (BCA)',
                  'Bachelor of Education (BEd)',
                  'Bachelor of Medicine, Bachelor of Surgery (MBBS)',
                  'Bachelor of Dental Surgery (BDS)',
                  'Bachelor of Pharmacy (BPharm)',
                  'Bachelor of Law (LLB)',
                  'Master of Arts (MA)',
                ],
                labelText: 'Search',
                onSelected: (selectedItem) {
                  // Handle the selected item here
                  print('Selected item: $selectedItem');
                },
                suffix: Icon(Icons.search_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                width: 350,
                height: 45,
              ),
            ),

            Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5,left: 50),
                    child: Row(
                      children: [
                        FilterChipWidget(
                          label: 'College Project',
                          selectedCategory: _selectedCategory,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 'College Project';
                            });
                            print('College Chip tapped!');
                          },
                          width: 140,
                          height: 30,
                        ),
                        FilterChipWidget(
                          label: 'Personal Development',
                          selectedCategory: _selectedCategory,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 'Personal Development';
                            });
                            print('Personal Chip tapped!');
                          },
                          width: 160,
                          height: 30,
                        ),
                        FilterChipWidget(
                          label: 'Assignment',
                          selectedCategory: _selectedCategory,
                          onTap: () {
                            setState(() {
                              _selectedCategory = 'Assignment';
                            });
                            print('Assignment Chip tapped!');
                          },
                          width: 120,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 40,
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
            Container(
              child: Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('colleges')
                      .doc(userCollegee) // Replace with the actual document ID or field name
                      .collection('collegePosts')
                      .where('category', isEqualTo: _selectedCategory)
                      .where('status', isEqualTo: 'active')  // Filter for 'active' posts
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
                                    builder: (context) => DetailsScreen(
                                      category: data['category'],
                                      subject: data['subCategory'],
                                      date: data['createdAt'],
                                      description: data['description'],
                                      priceRange: data['totalPayment'],
                                      finalDate: data['dueDate'],
                                      postid: data['postId'],
                                      emailid:data['emailid']
                                    ),
                                  ),
                                );
                              },
                              child: JobCard(
                                category: _selectedCategory,
                                subject: data['subCategory'],
                                date: data['createdAt'],
                                description: data['description'],
                                priceRange: data['totalPayment'],
                                userName: cleanUpUserName(data['emailid']),
                                finalDate: finalDate,
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No active posts'),
                        );
                      }
                    }
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  },
                ),
              ),
            )



            // Bottom banner ad
            // With this corrected code
            // Positioned(
            //   bottom: 0,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: 60, // Adjust the height of the ad container as needed
            //     decoration: BoxDecoration(
            //       color: Colors.grey, // Change the background color of the ad container
            //       borderRadius: BorderRadius.circular(15),
            //     ),
            //     child: Center(
            //       child: Text(
            //         'Ad',
            //         style: TextStyle(color: Colors.grey.shade50, fontSize: 12),
            //       ),
            //     ),
            //   ),
            // ),


            // this the code to filter through chip
            // Expanded(
            //   flex: 1,
            //   child: ListView.builder(
            //     itemCount: selectedCategoryNews.length,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.only(top: 25,left: 25,right: 25),
            //         child: ListTile(
            //           title: Text(selectedCategoryNews[index],style: TextStyle(color: Colors.white),),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // to select category

          ],
        ),
      ),
    );
  }
}
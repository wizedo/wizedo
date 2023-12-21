import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:wizedo/components/CustomRichText.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import 'package:wizedo/components/searchable_dropdown.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:shimmer/shimmer.dart';
import '../components/FliterChip.dart';
import '../components/JobCard.dart';
import '../controller/BottomNavigationController.dart';
import '../services/email_verification_page.dart';
import 'LoginPage.dart';
import 'detailsPage.dart';

class acceptedPage extends StatefulWidget {
  const acceptedPage({Key? key});

  @override
  State<acceptedPage> createState() => _acceptedPageState();
}

class _acceptedPageState extends State<acceptedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController=TextEditingController();
  String _selectedCategory = 'College Project';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Pending Jobs',
          style: mPlusRoundedText.copyWith(fontSize: 18),),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Column(
          children: [
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
                labelText:'Search',
                onSelected:(selectedItem){
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
                          onTap: (){
                            setState((){
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
                  stream: FirebaseFirestore.instance.collection('accepted')
                      .where('category', isEqualTo: _selectedCategory)
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
                                      subject: data['subject'],
                                      date: data['createdAt'],
                                      description: data['description'],
                                      priceRange: data['priceRange'],
                                      userName: cleanUpUserName(data['emailid']),
                                      finalDate: data['finalDate'],
                                      postid: data['postId'],
                                    ),
                                  ),
                                );
                              },
                              child: JobCard(
                                category: _selectedCategory,
                                subject: data['subject'],
                                date: data['createdAt'],
                                description: data['description'],
                                priceRange: data['priceRange'],
                                userName: cleanUpUserName(data['emailid']),
                                finalDate: finalDate,
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No accepted posts'),
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
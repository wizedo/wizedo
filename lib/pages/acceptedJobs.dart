import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizedo/components/JobCard.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/FliterChip.dart';
import '../components/myCustomAppliedCard.dart';
import '../components/searchable_dropdown.dart';
import 'detailsPage.dart';

class acceptedPage extends StatefulWidget {
  const acceptedPage({Key? key});

  @override
  State<acceptedPage> createState() => _acceptedPageState();
}

class _acceptedPageState extends State<acceptedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedCategory = 'College Project';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: WhiteText(
          'Pending Jobs',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
          Padding(
          padding: const EdgeInsets.only(top: 0,right: 20,left: 20,bottom: 10),
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
            labelText: 'Search your applied jobs',
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
                            label: 'Applied',
                            selectedCategory: _selectedCategory,
                            onTap: () {
                              setState(() {
                                _selectedCategory = 'Applied';
                              });
                              print('Applied');
                            },
                            width: 140,
                            height: 30,
                          ),
                          FilterChipWidget(
                            label: 'Recieved',
                            selectedCategory: _selectedCategory,
                            onTap: () {
                              setState(() {
                                _selectedCategory = 'Recieved';
                              });
                              print('Personal Chip tapped!');
                            },
                            width: 160,
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

              Center(
                child: Container(
                  width: 360,
                  height: 500,
                  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: getUserAcceptedPosts(),
                    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        final userAcceptedPosts = snapshot.data!.docs;
                        print(userAcceptedPosts);
                        if (userAcceptedPosts.isNotEmpty) {
                          return ListView.builder(
                            itemCount: userAcceptedPosts.length,
                            itemBuilder: (BuildContext context, int index) {
                              var data = userAcceptedPosts[index].data() as Map<String, dynamic>?; // Change this line
                              if (data != null) { // Add a null check
                                Timestamp date = data['createdAt'];
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
                                          // priceRange: data['priceRange'].toString(), // Convert int to String
                                          finalDate: data['finalDate'],
                                          postid: data['postId'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: MyCustomCard(
                                    subject: data['subject'],
                                    date: '1st jan 2023',
                                    priceRange: data['priceRange'].toString(), // Convert int to String
                                    icon: Icons.star,
                                    description: 'hello',
                                  ),
                                );

                              } else {
                                // Handle the case where data is null
                                return const Center(
                                  child: Text('No posts'),
                                );
                              }
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
              ),
// ...

            ],
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserAcceptedPosts() async {
    final user = _auth.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final email = user.email!;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await firestore.collection('accepted').doc(email).collection('acceptedPosts').get();
      return querySnapshot;

    } else {
      throw Exception('User not logged in');
    }
  }


}

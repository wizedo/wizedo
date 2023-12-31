import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:wizedo/components/my_elevatedbutton.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:wizedo/pages/PostPage.dart';
import '../components/boxDecoration.dart';
import '../components/mPlusRoundedText.dart';

class DetailsScreen extends StatefulWidget {
  final String category;
  final String? subject;
  final Timestamp? date;
  final String description;
  final int? priceRange;
  final String? postid;
  final String? finalDate;

  const DetailsScreen({
    Key? key,
     required this.category,
     this.subject,
     this.date,
     required this.description,
     this.priceRange,
     this.finalDate,
     this.postid,
  }) : super(key: key);


  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController _projectName = TextEditingController();
  final TextEditingController _descriptionText = TextEditingController();
  final TextEditingController _datePicker = TextEditingController();
  final TextEditingController _paymentDetails = TextEditingController();

  String _selectedCategory = '';
  bool _isNumberOfPagesVisible = false;

  DateTime _selectedDate = DateTime.now();

  void initState() {
    super.initState();
    // Print out values in the initState method
    print('Category: ${widget.category}');
    print('Subject: ${widget.subject}');
    print('Date: ${widget.date}');
    print('Description: ${widget.description}');
    print('Price Range: ${widget.priceRange}');
    print('Post ID: ${widget.postid}');
    print('Final Date: ${widget.finalDate}');
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Details',
          style: mPlusRoundedText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Description Tile
            Container(
              decoration: boxDecoration,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                children: [
                  // Text 1 - Graphic Designing
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: WhiteText(
                          '${widget.subject}',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Text 2 - Due Date
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: WhiteText(
                          'Due Date : ${widget.finalDate}',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            Icon(Icons.location_on_rounded,color: Colors.white,size: 20,),
                            SizedBox(width: 5),
                            Expanded(
                              child: WhiteText(
                                'International Institute of Business Studies (IIBS) Bangalore',
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            // payment details
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: WhiteText(
                    'Expected Pay : ',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 0),
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    WhiteText(
                      widget.priceRange.toString(),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            // description
            Align(
              alignment: Alignment.centerLeft,
              child: WhiteText(
                'Description : ',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: WhiteText(
                widget.description,
                fontSize: 12,
              ),
            ),
            // attachments
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: boxDecoration,
                    child: Column(
                      children: [
                        Image.asset('lib/images/pdf.png',height: 30),
                        SizedBox(height: 5), // Adjust the spacing as needed
                        Text(
                          'Assignment.pdf',
                          style: TextStyle(
                            color: Colors.white, // Set the text color
                            fontSize: 12, // Set the text font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // ad
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: boxDecorationColor,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 15),
          child: MyElevatedButton(
            buttonText: 'Apply',
            fontWeight: FontWeight.bold,
            onPressed: () {
              addToAcceptedCollection(
                category: widget.category,
                subject: widget.subject,
                finalDate: widget.finalDate,
                description: widget.description,
                priceRange: widget.priceRange,
                postid: widget.postid,
              );
          },

          ),
        )
      ),

    );
  }
}

Future<void> addToAcceptedCollection({
  required String? category,
  required String? subject,
  required String? finalDate,
  required String? description,
  required int? priceRange,
  required String? postid,
}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final email = user.email!;

      // Fetch user collegee from Firestore
      final userDoc = await firestore.collection('usersDetails').doc(email).get();
      String userCollegee = userDoc['college'] ?? 'Unknown College';
      print(userCollegee);

      final userDocRef = firestore.collection('accepted').doc(email);

      // Check if the document with the given postid already exists
      final docSnapshot = await userDocRef.collection('acceptedPosts').doc(postid).get();

      if (docSnapshot.exists) {
        // Document with the given postid already exists
        Get.snackbar('Already Applied', 'You have already applied for this job.');
      } else {
        // Document with the given postid doesn't exist, add the details
        await userDocRef.collection('acceptedPosts').doc(postid).set({
          'category': category,
          'subject': subject,
          'finalDate': finalDate,
          'description': description,
          'priceRange': priceRange,
          'status': 'applied',
          'postid': postid,
          'emailid': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Get.snackbar('Success', 'Details added to the accepted collection');

        // Update the status of the post in the 'collegePosts' collection
        await firestore.collection('colleges').doc(userCollegee).collection('collegePosts').doc(postid).update({
          'status': 'applied',
        });
      }
    }
  } catch (error) {
    print('Error adding to accepted collection: $error');
    Get.snackbar('Error', 'Failed to add details to accepted collection');
  }
}



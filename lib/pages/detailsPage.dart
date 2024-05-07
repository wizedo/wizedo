import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:wizedo/components/BlackText.dart';
import 'package:wizedo/components/my_elevatedbutton.dart';
import 'package:wizedo/components/white_text.dart';
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
  final String? emailid;
  final String? college;
  final String? googledrivelink;

  const DetailsScreen({
    Key? key,
    required this.category,
    this.subject,
    this.date,
    required this.description,
    this.priceRange,
    this.finalDate,
    this.postid,
    this.emailid,
    this.college,
    this.googledrivelink
  }) : super(key: key);


  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  // this is for banner
  bool isBannerLoaded=false;
  late BannerAd bannerAd;

  inilizeBannerAd() async{
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-1022421175188483/1458721551',
        listener: BannerAdListener(
            onAdLoaded: (ad){
              setState(() {
                isBannerLoaded=true;
              });
            },
            onAdFailedToLoad: (ad, error){
              ad.dispose();
              isBannerLoaded=false;
              print('add failed to load below is error');
              print(error);
            }
        ),
        request: AdRequest());
    bannerAd.load();
  }

  bool isIntersitalLoaded=false;
  late InterstitialAd interstitialAd;

  adloaded() async{
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-1022421175188483/4256627905',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad){
              setState(() {
                interstitialAd=ad;
                isIntersitalLoaded=true;
              });
            },
            onAdFailedToLoad: (error){
              print(error);
              interstitialAd.dispose();
              isIntersitalLoaded=false;
            }
        )
    );
  }
  //***


  DateTime _selectedDate = DateTime.now();
  RxInt selectedRadio = 0.obs; // Initialize to 0 to indicate no selection

  void initState() {
    super.initState();
    inilizeBannerAd();
    adloaded();
    // Print out values in the initState method
    print('Category: ${widget.category}');
    print('Subject: ${widget.subject}');
    print('Date: ${widget.date}');
    print('Description: ${widget.description}');
    print('Price Range: ${widget.priceRange}');
    print('Post ID: ${widget.postid}');
    print('Final Date: ${widget.finalDate}');
    selectedRadio.value=0;
  }

  setSelectedRadio(int val) {
    selectedRadio.value = val;
  }

  Widget _buildRadioListTile(String text, int value) {
    return GestureDetector(
      onTap: () {
        setSelectedRadio(value);
      },
      child: ListTile(
        title: Transform.translate(
          offset: Offset(-17, 0),
          child: BlackText(text),
        ),
        leading: Obx(
              () => Radio<int>(
            value: value,
            groupValue: selectedRadio.value,
            activeColor: Color(0xFF955AF2),
            onChanged: (val) {
              print(val);
              setSelectedRadio(val!);
            },
          ),
        ),
      ),
    );
  }


  Future<void> reportPost(String userCollegee, String postId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final collegePostRef = firestore
          .collection('colleges')
          .doc(userCollegee)
          .collection('collegePosts')
          .doc(postId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(collegePostRef);

        if (snapshot.exists) {
          // Get the current value of the 'report' field
          final currentReports = snapshot.get('report') ?? 0;

          // Increment the 'report' field by one
          transaction.update(collegePostRef, {
            'report': currentReports + 1,
          });
        } else {
          print('Document does not exist!');
          // Handle case where the document does not exist
        }
      });

      // Report updated successfully
    } catch (error) {
      print('Error updating report: $error');
      // Handle error
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
        actions: [
          IconButton(
            icon: Icon(Icons.report, color: Colors.white, size: 24,),
            onPressed: () {
              Get.defaultDialog(
                title: 'Report Post',
                titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                titleStyle: GoogleFonts.mPlusRounded1c(
                  textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding: EdgeInsets.only(top: 25,bottom: 25),
                content: Column(
                  children: [
                    _buildRadioListTile('Inappropriate Content', 1),
                    _buildRadioListTile('Spam or Advertisement', 2),
                    _buildRadioListTile('Harassment or Bullying', 3),
                    _buildRadioListTile('Other', 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Align(
                        child: BlackText(
                          'Note:',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5, right: 25),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          children: [
                            TextSpan(
                              text:
                              "Please ensure the accuracy of the content before submitting a report. In situations where someone's safety is at risk, promptly notify local emergency services ASAP.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                confirm: TextButton(
                  onPressed: () async {
                    Get.dialog(
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false, // Prevent user from dismissing the dialog
                    );
                    // Call reportPost function to increment report value by one
                    await reportPost('${widget.college}', '${widget.postid}');

                    if(isIntersitalLoaded==true){
                      interstitialAd.show();
                    }

                    Get.back(); // Close the report dialog
                    Get.back(); // Close the report dialog
                  },

                  child: Text('Report'),
                ),
                cancel: TextButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
              );
            },
          ),
        ],


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
                  SizedBox(height: 10),
                  // Column(
                  //   children: [
                  //     Align(
                  //       alignment: Alignment.bottomLeft,
                  //       child: Row(
                  //         children: [
                  //           Icon(Icons.location_on_rounded,color: Colors.white,size: 20,),
                  //           SizedBox(width: 5),
                  //           Expanded(
                  //             child: WhiteText(
                  //               userCollegee,
                  //               fontSize: 9,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 10),
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
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.centerLeft,
              child: WhiteText(
                'Reference Material: ',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 3.5,sigmaY: 3),
                child: InkWell(
                  onTap: () {
                    final snackbar = SnackBar(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red.shade400,
                      duration: Duration(seconds: 5),
                      content: SizedBox(
                        child: WhiteText('Access more details by applying'),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  child: WhiteText(
                    widget.googledrivelink != null && widget.googledrivelink != '' ? widget.googledrivelink! : 'No reference material available',
                    fontSize: 12,
                  ),
                ),

              ),
            ),
            // attachments
            SizedBox(height: 140),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add the interstitial ad here if it's loaded
                if (isBannerLoaded)
                  Container(
                    height: 50,
                    child: AdWidget(ad: bannerAd),
                  ),
                SizedBox(height: 10),
                MyElevatedButton(
                  width: 320,
                  buttonText: 'Apply',
                  fontWeight: FontWeight.bold,
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      if (widget.emailid != null) {
                        final userEmail = user.email!;
                        final userDocRef = FirebaseFirestore.instance.collection('usersDetails').doc(userEmail);
                        final userDocSnapshot = await userDocRef.get();
                        final totalApplied = userDocSnapshot.data()?['totalapplied'] ?? 0;
                        if (user.email == widget.emailid) {
                          Get.showSnackbar(
                            GetSnackBar(
                              borderRadius: 8,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              animationDuration: Duration(milliseconds: 800),
                              duration: Duration(milliseconds: 4500),
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              snackPosition: SnackPosition.TOP,
                              isDismissible: true,
                              backgroundColor: Color(0xFF955AF2),
                              titleText: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  WhiteText(
                                    'Attention',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              messageText: WhiteText(
                                "You can't apply for your own post.",
                                fontSize: 12,
                              ),
                            ),
                          );
                        }else if(userDocSnapshot.exists && totalApplied >= 5){
                          Get.showSnackbar(
                            GetSnackBar(
                              borderRadius: 8,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              animationDuration: Duration(milliseconds: 800),
                              duration: Duration(milliseconds: 4500),
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              snackPosition: SnackPosition.TOP,
                              isDismissible: true,
                              backgroundColor: Color(0xFF955AF2),
                              titleText: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  WhiteText(
                                    'Attention',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              messageText: WhiteText(
                                "A user can apply for a maximum of 5 projects or tasks.",
                                fontSize: 12,
                              ),
                            ),
                          );
                        } else {
                          // Show confirmation dialog before applying
                          Get.defaultDialog(
                            title: 'Confirmation',
                            titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 0), // Add padding above the title
                            titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Set font size of the title
                            contentPadding: EdgeInsets.all(25),
                            middleText: "Are you sure you want to apply for this post?",
                            confirm: TextButton(
                              onPressed: () async {
                                // Add your logic to apply for the post here
                                addToAcceptedCollection(
                                  category: widget.category,
                                  subject: widget.subject,
                                  finalDate: widget.finalDate,
                                  description: widget.description,
                                  priceRange: widget.priceRange,
                                  postid: widget.postid,
                                  emailid: widget.emailid,
                                  isIntersitalLoaded: isIntersitalLoaded, // Pass isIntersitalLoaded
                                  interstitialAd: interstitialAd, // Pass interstitialAd
                                );
                                Get.back(); // Close the confirmation dialog
                              },
                              child: Text('Yes'),
                            ),
                            cancel: TextButton(
                              onPressed: () {
                                Get.back(); // Close the confirmation dialog
                              },
                              child: Text('No'),
                            ),
                          );

                        }
                      } else {
                        print('Widget emailid is null.');
                      }
                    }
                  },
                ),
              ],
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
  required String? emailid,
  required bool isIntersitalLoaded, // Add this parameter
  required InterstitialAd interstitialAd, // Add this parameter
}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final workeremail = user.email!;

      // Fetch user college from Firestore
      final userDoc = await firestore.collection('usersDetails').doc(workeremail).get();
      String userCollege = userDoc['college'] ?? 'Unknown College';


      // Add the details to the accepted collection
      await firestore.runTransaction((transaction) async {
        // Optionally, add the post to a subcollection under the college document
        final collegePostRef = firestore
            .collection('colleges')
            .doc(userCollege)
            .collection('collegePosts')
            .doc(postid);

        // Update the status of the post in the 'collegePosts' collection
        transaction.update(collegePostRef, {
          'status': 'Applied',
          'pstatus': 2,
          'workeremail': workeremail,
          'recieveremail': emailid,
        });

        final applycheckemail = user?.email!;

        final docRef = FirebaseFirestore.instance.collection('usersDetails').doc(applycheckemail);
        // Use a transaction to update totalapplied
        FirebaseFirestore.instance.runTransaction((transaction) async {
          final totalapplied = await transaction.get(docRef);
          if (totalapplied.exists) {
            // Increment totalapplied by one
            int newTotalApplied = (totalapplied.data()?['totalapplied'] ?? 0) + 1;
            print('new toatal appllied posts are $newTotalApplied');
            transaction.update(docRef, {'totalapplied': newTotalApplied});
          }
        });



        if(isIntersitalLoaded==true){
          interstitialAd.show();
        }

        Get.showSnackbar(
          GetSnackBar(
            borderRadius: 8,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            animationDuration: Duration(milliseconds: 800),
            duration: Duration(milliseconds: 4500),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            snackPosition: SnackPosition.TOP,
            isDismissible: true,
            backgroundColor: Color(0xFF955AF2), // Set your desired color here
            titleText: Row(
              children: [
                Icon(
                  Icons.done_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                WhiteText(
                  'Success',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            messageText: WhiteText(
              'You have successfully applied for the task.',
              fontSize: 12,
            ),
          ),
        );
      });


    }
  } catch (error) {
    print('Error adding to accepted collection: $error');
    Get.snackbar('Error', 'Failed to add details to accepted collection');
  }
}
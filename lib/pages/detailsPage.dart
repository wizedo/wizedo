import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:wizedo/components/BlackText.dart';
import 'package:wizedo/components/my_elevatedbutton.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/boxDecoration.dart';
import '../components/debugcusprint.dart';
import '../components/mPlusRoundedText.dart';
import '../controller/network_controller.dart';

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
    super.key,
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
  });


  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  // this is for banner
  bool isBannerLoaded=false;
  late BannerAd bannerAd;
  final NetworkController _networkController = Get.put(NetworkController());


  inilizeBannerAd() async{
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-1663453972288157/5620565444',
        listener: BannerAdListener(
            onAdLoaded: (ad){
              setState(() {
                isBannerLoaded=true;
              });
            },
            onAdFailedToLoad: (ad, error){
              ad.dispose();
              isBannerLoaded=false;
              debugLog('add failed to load below is error');
              debugLog(error);
            }
        ),
        request: const AdRequest());
    bannerAd.load();
  }

  bool isInterstitialLoaded = false;
  late InterstitialAd interstitialAd;
  DateTime? adLoadedTime;
  Box? box;

  void adLoaded() async {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-1663453972288157/1854927863',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            interstitialAd = ad;
            isInterstitialLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          print(error);
          isInterstitialLoaded = false;
        },
      ),
    );
  }
  //***


  final DateTime _selectedDate = DateTime.now();
  RxInt selectedRadio = 0.obs; // Initialize to 0 to indicate no selection

  @override
  void initState() {
    super.initState();
    inilizeBannerAd();
    adLoaded();
    // debugLog out values in the initState method
    debugLog('Category: ${widget.category}');
    debugLog('Subject: ${widget.subject}');
    debugLog('Date: ${widget.date}');
    debugLog('Description: ${widget.description}');
    debugLog('Price Range: ${widget.priceRange}');
    debugLog('Post ID: ${widget.postid}');
    debugLog('Final Date: ${widget.finalDate}');
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
          offset: const Offset(-17, 0),
          child: BlackText(text),
        ),
        leading: Obx(
              () => Radio<int>(
            value: value,
            groupValue: selectedRadio.value,
            activeColor: const Color(0xFF955AF2),
            onChanged: (val) {
              debugLog(val);
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
          debugLog('Document does not exist!');
          // Handle case where the document does not exist
        }
      });

      // Report updated successfully
    } catch (error) {
      debugLog('Error updating report: $error');
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
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
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
          Obx(() {
            if (!_networkController.isConnected.value) {
              return Container(); // Return an empty container or some other widget when there is no internet connection
            }
            return IconButton(
              icon: const Icon(Icons.report, color: Colors.white, size: 24),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Report Post',
                  titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  titleStyle: GoogleFonts.mPlusRounded1c(
                    textStyle: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 25, bottom: 25),
                  content: Column(
                    children: [
                      _buildRadioListTile('Inappropriate Content', 1),
                      _buildRadioListTile('Spam or Advertisement', 2),
                      _buildRadioListTile('Harassment or Bullying', 3),
                      _buildRadioListTile('Other', 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: BlackText(
                            'Note:',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 5, right: 25),
                        child: RichText(
                          text: const TextSpan(
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
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                        barrierDismissible: false, // Prevent user from dismissing the dialog
                      );
                      // Call reportPost function to increment report value by one
                      await reportPost('${widget.college}', '${widget.postid}');

                      Get.back(); // Close the report dialog
                      Get.back(); // Close the report dialog
                    },
                    child: const Text('Report'),
                  ),
                  cancel: TextButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                );
              },
            );
          }),

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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 10),

                ],
              ),
            ),
            const SizedBox(height: 20),
            // payment details
            Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: WhiteText(
                    'Expected Pay : ',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 0),
                Row(
                  children: [
                    const Icon(
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
            const SizedBox(height: 5),
            // description
            const Align(
              alignment: Alignment.centerLeft,
              child: WhiteText(
                'Description : ',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: WhiteText(
                widget.description,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20,),
            const Align(
              alignment: Alignment.centerLeft,
              child: WhiteText(
                'Reference Material: ',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
                      duration: const Duration(seconds: 5),
                      content: const SizedBox(
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
            const SizedBox(height: 140),
          ],
        ),
        ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add the interstitial ad here if it's loaded
              if (isBannerLoaded)
                SizedBox(
                  height: 50,
                  child: AdWidget(ad: bannerAd),
                ),
              const SizedBox(height: 10),
              Obx(() {
                if (!_networkController.isConnected.value) {
                  return Container();
                }
                return MyElevatedButton(
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
                            const GetSnackBar(
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
                        } else if (userDocSnapshot.exists && totalApplied >= 5) {
                          Get.showSnackbar(
                            const GetSnackBar(
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
                            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // Add padding above the title
                            titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Set font size of the title
                            contentPadding: const EdgeInsets.all(25),
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
                                  isIntersitalLoaded: isInterstitialLoaded, // Pass isIntersitalLoaded
                                  interstitialAd: interstitialAd, // Pass interstitialAd
                                  adLoadedTime: adLoadedTime
                                );
                                Get.back(); // Close the confirmation dialog
                              },
                              child: const Text('Yes'),
                            ),
                            cancel: TextButton(
                              onPressed: () {
                                Get.back(); // Close the confirmation dialog
                              },
                              child: const Text('No'),
                            ),
                          );
                        }
                      } else {
                        debugLog('Widget emailid is null.');
                      }
                    }
                  },
                );
              }),
            ],
          ),
        ),
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
  required adLoadedTime
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

        final applycheckemail = user.email!;

        final docRef = FirebaseFirestore.instance.collection('usersDetails').doc(applycheckemail);
        // Use a transaction to update totalapplied
        FirebaseFirestore.instance.runTransaction((transaction) async {
          final totalapplied = await transaction.get(docRef);
          if (totalapplied.exists) {
            // Increment totalapplied by one
            int newTotalApplied = (totalapplied.data()?['totalapplied'] ?? 0) + 1;
            debugLog('new toatal appllied posts are $newTotalApplied');
            transaction.update(docRef, {'totalapplied': newTotalApplied});
          }
        });

        Get.showSnackbar(
          const GetSnackBar(
            borderRadius: 8,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            animationDuration: Duration(milliseconds: 800),
            duration: Duration(milliseconds: 2000),
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


      Box? box;

      await Future.delayed(const Duration(milliseconds: 2100));

      if (isIntersitalLoaded) {
        box = await Hive.openBox('ad');
        final currentTime = DateTime.now();
        final storedAdLoadedTime = box?.get('adLoadedTime');
        if (storedAdLoadedTime == null || currentTime.difference(DateTime.parse(storedAdLoadedTime)).inSeconds >= 120) {
          interstitialAd.show();
          debugLog('going to show ad');
          box?.put('adLoadedTime', currentTime.toString());
          debugLog('showing ad and time is ${currentTime.toString()}');
        } else {
          debugLog('not showing ad');
        }
      }

      Get.back();
      Get.back();
      Get.back();


    }
  } catch (error) {
    debugLog('Error adding to accepted collection: $error');
    Get.snackbar('Error', 'Failed to add details to accepted collection');
  }
}
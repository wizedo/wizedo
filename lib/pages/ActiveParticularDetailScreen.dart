import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:wizedo/components/my_elevatedbutton.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:wizedo/pages/statusPage.dart';
import '../components/boxDecoration.dart';
import '../components/debugcusprint.dart';
import '../components/mPlusRoundedText.dart';
import '../controller/UserController.dart';
import '../controller/network_controller.dart';

class ActiveParticularDetailScreen extends StatefulWidget {
  final String category;
  final String? subject;
  final Timestamp? date;
  final String description;
  final int? priceRange;
  final String? postid;
  final String? finalDate;
  final String? emailid;
  final String? googledrivelink;
  final String? chatroomid;
  final String? collegename;


  const ActiveParticularDetailScreen({
    super.key,
    required this.category,
    this.subject,
    this.date,
    required this.description,
    this.priceRange,
    this.finalDate,
    this.postid,
    this.emailid,
    this.googledrivelink,
    this.chatroomid,
    this.collegename
  });


  @override
  State<ActiveParticularDetailScreen> createState() => _ActiveParticularDetailScreenState();
}

class _ActiveParticularDetailScreenState extends State<ActiveParticularDetailScreen> {

  // this is for banner
  bool isBannerLoaded=false;
  late BannerAd specificpagebannerAd;
  final UserController userController = Get.find<UserController>();
  final NetworkController _networkController = Get.put(NetworkController());


  inilizeBannerspecificAd() async{
    specificpagebannerAd = BannerAd(
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
    specificpagebannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    inilizeBannerspecificAd();
    // debugLog out values in the initState method
    debugLog('Category: ${widget.category}');
    debugLog('Subject: ${widget.subject}');
    debugLog('Date: ${widget.date}');
    debugLog('Description: ${widget.description}');
    debugLog('Price Range: ${widget.priceRange}');
    debugLog('Post ID: ${widget.postid}');
    debugLog('Final Date: ${widget.finalDate}');
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
              return Container();
            }
            return IconButton(
              icon: const Icon(Icons.delete_rounded, color: Colors.white),
              onPressed: () {
                // Show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text(
                          "Are you sure you want to delete this post?"),
                      actions: [
                        // No button
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("No"),
                        ),
                        // Yes button
                        TextButton(
                          onPressed: () async {
                            try {
                              String userCollegee = userController.college ??
                                  'null set manually2';
                              String postId = widget.postid ?? 'null post id';

                              // Create a reference for the document
                              DocumentReference docRef = FirebaseFirestore
                                  .instance
                                  .collection('colleges')
                                  .doc(userCollegee)
                                  .collection('collegePosts')
                                  .doc(postId);

                              // Log the document path
                              debugLog(
                                  "Deleting document at path: ${docRef.path}");

                              // Delete the document
                              await docRef.delete();
                              debugLog("Post deleted successfully");

                              // Close the dialog and navigate back
                              Navigator.of(context).pop(); // Close the dialog
                              Get.back(); // Navigate back from the screen
                            } catch (error) {
                              debugLog("Failed to delete post: $error");

                              // Close the dialog
                              Navigator.of(context).pop();

                              // Show an error message if deletion fails
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to delete post"),
                                ),
                              );
                            }
                          },
                          child: const Text("Yes"),
                        )
                      ],
                    );
                  },
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
              child: GestureDetector(
                onTap: () async {
                  debugLog('new url tapped');
                  if (widget.googledrivelink != null && widget.googledrivelink!.isNotEmpty) {
                    String? link=widget.googledrivelink;
                    launchUrl(
                        Uri.parse(link!),
                        mode: LaunchMode.inAppBrowserView
                    );
                  }
                },
                child: WhiteText(
                  widget.googledrivelink != null && widget.googledrivelink != '' ? widget.googledrivelink! : 'No reference material available',
                  fontSize: 12,
                ),
              ),
            ),



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
                  SizedBox(
                    height: 50,
                    child: AdWidget(ad: specificpagebannerAd),
                  ),
                const SizedBox(height: 10),
                Obx(() {
                  if (!_networkController.isConnected.value) {
                    return Container();
                  }
                  return MyElevatedButton(
                    width: 320,
                    buttonText: 'Check Status',
                    fontWeight: FontWeight.bold,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              statusPage(
                                  postid: widget.postid,
                                  priceRange: widget.priceRange,
                                  chatroomid: widget.chatroomid
                              ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),

          )
      ),

    );
  }
}








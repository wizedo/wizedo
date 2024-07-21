import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:wizedo/components/cardContainerSettings.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:wizedo/pages/FeedbackForm.dart';
import 'package:wizedo/pages/contactUs.dart';
import 'package:wizedo/pages/privacyPolicy.dart';
import 'package:wizedo/pages/profilepage.dart';
import 'package:wizedo/pages/refundAndCancellation.dart';
import 'package:wizedo/pages/terms&cond.dart';
import '../Widgets/colors.dart';
import '../components/debugcusprint.dart';
import '../components/imagesname.dart';
import '../components/mPlusRoundedText.dart';
import '../controller/UserController.dart';
import 'LoginPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'completedtaskspage.dart';
import 'faq.dart';

class settingScreen extends StatefulWidget {
  final CollectionReference fireStore;

  settingScreen({super.key})
      : fireStore = FirebaseFirestore.instance.collection('usersDetails');

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController userController = Get.find<UserController>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String userCollegee = 'null';

  String userEmail='null';

  String username='null';

  User? user = FirebaseAuth.instance.currentUser;

  call() {
    debugLog(widget.fireStore.id);
    debugLog(user?.email);
  }


  Future<void> _signOut(BuildContext context) async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Disconnect from Google Sign-In (if possible)
      if (await _googleSignIn.isSignedIn()) {
        try {
          await _googleSignIn.disconnect();
          // Open the Hive box
          var userBox = await Hive.openBox('userdetails');

          // Clear all data in the box
          await userBox.clear();

          // Optionally, close the box if no longer needed
          await userBox.close();

          // Clear cache after sign-out actions
          DefaultCacheManager().emptyCache();
          debugLog("signed out through google signin");
        } catch (disconnectError) {
          // Handle specific error related to disconnecting from Google Sign-In
          debugLog('Error disconnecting from Google Sign-In: $disconnectError');
        }
      } else {
        debugLog("signout normally");
      }



      // Show success message and navigate to the login page
      Get.showSnackbar(
        const GetSnackBar(
          borderRadius: 8,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(milliseconds: 3500),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          backgroundColor: Color(0xFF955AF2), // Set your desired color for success
          titleText: Row(
            children: [
              Icon(
                Icons.check_circle,
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
            'Logged out successfully',
            fontSize: 12,
          ),
        ),
      );

      Get.to(const LoginPage());
    } catch (error) {
      // Show error message if there's an issue with sign-out
      Get.snackbar('Error', 'Error signing out: $error');
    }
  }

  Future<void> getData(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot querySnapshot =
      await widget.fireStore.where('id', isEqualTo: user.email).get();
      debugLog('User Email: ${user.email}');

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        final String id = userData['id'];
        final String college = userData['college'];
        final String firstname = userData['firstname'];
        final String lastname =userData['lastname'];
        final String fullName = '$firstname $lastname';
        final String course = userData['course'];
        const int phoneNumber = 1234567898;
        final String avatar=userData['avatar'];
        final Timestamp joinedon=userData['lastUpdated'];

        debugLog(
            'ID: $id, College: $college, Name: $fullName, Course: $course, Phone: $phoneNumber');
        debugLog(userData);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userDetails: UserDetails(
                id: id,
                name: fullName,
                course: course,
                college: college,
                phone: phoneNumber,
                avatar: avatar,
                joinedon: joinedon

              ),
            ),
          ),
        );
      } else {
        debugLog('User not found');
      }
    } else {
      debugLog('User is not authenticated');
    }
  }

  double getFontSize(double fontSize, double screenHeight) {
    if (screenHeight > 600) {
      return fontSize;
    } else if (screenHeight <= 600 && screenHeight > 0) {
      return fontSize * 0.5;
    } else {
      return fontSize;
    }
  }


  Future<void> sendOTP() async {
    const apiKey = "d6EOwRnQ4uLD1NPj7Ui39HXG2SJqtWIb8oxZyfkCsm0AvMazVrRljzV8ugf6AhpnSd2tI37MqDNFTZHO";
    const url = "https://www.fast2sms.com/dev/bulkV2";
    const phoneNumber = "8123341257";
    const otpValue = "5599";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "authorization": apiKey,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "variables_values=$otpValue&route=otp&numbers=$phoneNumber",
    );
    if (response.statusCode == 200) {
      debugLog("OTP sent successfully");
      // Handle success response here
      // You can also access response.body to get the JSON response
      // Example: var jsonResponse = json.decode(response.body);
    } else {
      debugLog("Failed to send OTP. Status code: ${response.statusCode}");
      debugLog("Response body: ${response.body}");
      // Handle the error accordingly
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    userEmail = userController.id;
    username = userController.firstname ?? 'DefaultUsername';
    debugLog(username);
  }

  // Function to find avatar path
  String findAvatarPath() {
    String avatarPath = userController.avatar;
    for (var image in images) {
      if (image['name'] == userController.avatar) {
        avatarPath = image['path']!;
        break;
      }
    }
    return avatarPath;
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor.withOpacity(0.97),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Settings',
            style: mPlusRoundedText.copyWith(fontSize: getFontSize(18, screenHeight)),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 5,left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width*0.85,
                height: Get.height*0.10,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: cardContainerdecoration,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      findAvatarPath(),
                                      width: screenHeight < 600 ? 40 : 60,
                                      height: screenHeight < 600 ? 40 : 60,
                                      fit: BoxFit.cover,
                                    ), 
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WhiteText(
                                        userController.firstname,
                                        fontSize: screenHeight < 600 ? 14 : 16,
                                      ),
                                      SizedBox(
                                        width: 220,
                                        child: WhiteText(
                                          userController.id,
                                          fontSize: screenHeight < 600 ? 9 : 11,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 220,
                                        child: WhiteText(
                                          userController.college,
                                          fontSize: screenHeight < 600 ? 9 : 11,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(const CompletedTasksPage());
                      },
                      child: const cardSettingContainer(text: 'History', iconData: Icons.history),
                    ),
                    InkWell(
                        onTap: (){
                          Get.showSnackbar(
                            const GetSnackBar(
                              borderRadius: 8,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              animationDuration: Duration(milliseconds: 800),
                              duration: Duration(milliseconds: 3000),
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              snackPosition: SnackPosition.TOP,
                              isDismissible: true,
                              backgroundColor: Color(0xFF955AF2),
                              titleText: Row(
                                children: [
                                  Icon(
                                    Icons.payment_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  WhiteText(
                                    'Status',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              messageText: WhiteText(
                                'No payments made or received through the app yet.',
                                fontSize: 12,
                              ),
                            ),
                          );

                          // sendOTP();
                        },
                        child: const cardSettingContainer(text: 'Payment', iconData: Icons.payment)
                    ),
                    InkWell(
                        onTap:(){
                          Get.to(FAQPage());
                        },
                      child:const cardSettingContainer(text: 'FAQ', iconData: Icons.question_answer_sharp),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 10),
              Container(
                decoration: cardContainerdecoration,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        getData(context);
                      },
                      icon: const Icon(Icons.account_circle, color: Colors.white),
                      label: Text('Profile', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Get.to(const RefundAndCancellation());
                      },
                      icon: const Icon(Icons.currency_rupee, color: Colors.white),
                      label: Text('Refund And Cancellation Policy', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    // Divider(height: 0.2, color: Colors.grey),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.privacy_tip_sharp, color: Colors.white),
                      label: Text('Privacy Policy', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    // Divider(height: 0.2, color: Colors.grey),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TermsConditionsPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.label_important, color: Colors.white),
                      label: Text('Terms and Conditions', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ContactUs(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.contact_support, color: Colors.white),
                      label: Text('Contact Us', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FeedbackForm(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.feedback, color: Colors.white),
                      label: Text('Feedback', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    //important snippet
                    // Container(
                    //   child: TextButton.icon(
                    //     onPressed: () {
                    //       Get.to(PhoneNumberVerification());
                    //     },
                    //     icon: Icon(Icons.phone, color: Colors.white),
                    //     label: Text('Phone Number Verification', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                    //     style: ButtonStyle(
                    //       minimumSize: MaterialStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                    //       alignment: Alignment.centerLeft,
                    //     ),
                    //   ),
                    // ),
                    TextButton.icon(
                      onPressed: () {
                        _signOut(context);
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text('Log-Out', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                        alignment: Alignment.centerLeft,
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
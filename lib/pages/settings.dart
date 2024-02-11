import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/cardContainerSettings.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:wizedo/pages/privacyPolicy.dart';
import 'package:wizedo/pages/profilepage.dart';
import 'package:wizedo/pages/terms&cond.dart';
import '../Widgets/colors.dart';
import '../components/mPlusRoundedText.dart';

import 'LoginPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'PhoneNumberVerification.dart';
import 'completedtaskspage.dart';

class settingScreen extends StatefulWidget {
  final CollectionReference fireStore;

  settingScreen({Key? key})
      : fireStore = FirebaseFirestore.instance.collection('usersDetails'),
        super(key: key);

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String userCollegee = 'null';

  String userEmail='null';

  String username='null';

  User? user = FirebaseAuth.instance.currentUser;

  call() {
    print(widget.fireStore.id);
    print(user?.email);
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

  Future<void> _signOut(BuildContext context) async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Disconnect from Google Sign-In (if possible)
      if (await _googleSignIn.isSignedIn()) {
        try {
          await _googleSignIn.disconnect();
          print("signed out through google signin");
        } catch (disconnectError) {
          // Handle specific error related to disconnecting from Google Sign-In
          print('Error disconnecting from Google Sign-In: $disconnectError');
        }
      } else {
        print("signout normally");
      }

      // Clear cache after sign-out actions
      DefaultCacheManager().emptyCache();

      // Show success message and navigate to the login page
      Get.snackbar('Success', 'Sign out successful');
      Get.to(LoginPage());
    } catch (error) {
      // Show error message if there's an issue with sign-out
      Get.snackbar('Error', 'Error signing out: $error');
    }
  }

  Future<void> getData(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot querySnapshot =
      await widget.fireStore.where('id', isEqualTo: user?.email).get();
      print('User Email: ${user?.email}');

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        final String id = userData['id'];
        final String college = userData['college'];
        final String firstname = userData['firstname'];
        final String lastname =userData['lastname'];
        final String fullName = '$firstname $lastname';
        final String course = userData['course'];
        final int phoneNumber = 1234567898;

        print(
            'ID: $id, College: $college, Name: $fullName, Course: $course, Phone: $phoneNumber');
        print(userData);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userDetails: UserDetails(
                id: id,
                name: fullName,
                course: course,
                college: college,
                phone: phoneNumber,
              ),
            ),
          ),
        );
      } else {
        print('User not found');
      }
    } else {
      print('User is not authenticated');
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

  Future<String?> getUserNameLocally(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('userName_$email');
    } catch (error) {
      print('Error getting user name locally: $error');
      return null; // You might want to handle this case appropriately in your app
    }
  }

  Future<void> sendOTP() async {
    final apiKey = "d6EOwRnQ4uLD1NPj7Ui39HXG2SJqtWIb8oxZyfkCsm0AvMazVrRljzV8ugf6AhpnSd2tI37MqDNFTZHO";
    final url = "https://www.fast2sms.com/dev/bulkV2";
    final phoneNumber = "8123341257";
    final otpValue = "5599";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "authorization": apiKey,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "variables_values=$otpValue&route=otp&numbers=$phoneNumber",
    );
    if (response.statusCode == 200) {
      print("OTP sent successfully");
      // Handle success response here
      // You can also access response.body to get the JSON response
      // Example: var jsonResponse = json.decode(response.body);
    } else {
      print("Failed to send OTP. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      // Handle the error accordingly
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
    username = await getUserNameLocally(userEmail) ?? 'DefaultUsername';
    print(username);

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width*0.85,
                // height: screenHeight < 600 ? Get.height*0.20 : 20,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: cardContainerdecoration,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              width: screenHeight < 600 ? 40 : 70,
                              height: screenHeight < 600 ? 40 : 70,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  // color: Colors.black, // Set border color to black
                                  // width:3, // Set border width/
                                ),
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xFF955AF2), // Set container background color to transparent
                              ),
                              child: Center(
                                child: Text(
                                  username[0],
                                  style: GoogleFonts.rubikMicrobe(
                                    fontSize: screenHeight < 600 ? 30 : 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WhiteText(
                                  username,
                                  fontSize: screenHeight < 600 ? 14 : 16,
                                ),
                                Container(
                                  width: 220,
                                  child: WhiteText(
                                    userEmail,
                                    fontSize: screenHeight < 600 ? 9 : 11,
                                  ),
                                ),
                                Container(
                                  width: 220,
                                  child: WhiteText(
                                    userCollegee,
                                    fontSize: screenHeight < 600 ? 9 : 11,
                                  ),
                                ),
                                SizedBox(height: 2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    cardSettingContainer(text: 'Earnings', iconData: Icons.currency_rupee_rounded),
                    InkWell(
                        onTap: (){
                          // sendOTP();
                          // Get.changeTheme(ThemeData.dark());
                          Get.to(PhoneNumberVerification());
                        },
                        child: cardSettingContainer(text: 'Payment', iconData: Icons.payment)),
                    InkWell(
                      onTap: () {
                      },
                      child: cardSettingContainer(text: 'Help', iconData: Icons.help),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: cardContainerdecoration,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: TextButton.icon(
                        onPressed: () {
                          getData(context);
                        },
                        icon: Icon(Icons.account_circle, color: Colors.white),
                        label: Text('Profile', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    // Divider(height: 0, color: Colors.grey),
                    Container(
                      child: TextButton.icon(
                        onPressed: () {
                          Get.to(CompletedTasksPage());
                        },
                        icon: Icon(Icons.history_rounded, color: Colors.white),
                        label: Text('History', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    // Divider(height: 0.2, color: Colors.grey),
                    Container(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PrivacyPolicyPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.privacy_tip_sharp, color: Colors.white),
                        label: Text('Privacy Policy', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    // Divider(height: 0.2, color: Colors.grey),
                    Container(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TermsConditionsPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.label_important, color: Colors.white),
                        label: Text('Terms and Conditions', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton.icon(
                        onPressed: () {
                          Get.to(PhoneNumberVerification());
                        },
                        icon: Icon(Icons.phone, color: Colors.white),
                        label: Text('Phone Number Verification', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    // Divider(height: 0.2, color: Colors.grey),
                    Container(
                      child: TextButton.icon(
                        onPressed: () {
                          _signOut(context);
                        },
                        icon: Icon(Icons.logout, color: Colors.white),
                        label: Text('Log-Out', style: TextStyle(color: Colors.white, fontSize: screenHeight < 600 ? 9 : 12)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, getFontSize(50, screenHeight))),
                          alignment: Alignment.centerLeft,
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
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:wizedo/components/cardContainerSettings.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:wizedo/pages/privacyPolicy.dart';
import 'package:wizedo/pages/profilepage.dart';
import 'package:wizedo/pages/statusPage.dart';
import 'package:wizedo/pages/terms&cond.dart';

import '../Widgets/colors.dart';
import '../components/gradientBoxDecoration.dart';
import '../components/mPlusRoundedText.dart';
import '../components/myCustomAppliedCard.dart';
import 'LoginPage.dart';
import 'package:google_sign_in/google_sign_in.dart';


class settingScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference fireStore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();



  settingScreen({Key? key})
      : fireStore = FirebaseFirestore.instance.collection('usersDetails'),
        super(key: key);

  User? user = FirebaseAuth.instance.currentUser;

  call() {
    print(fireStore.id);
    print(user?.email);
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
      }else{
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
      await fireStore.where('id', isEqualTo: user?.email).get();
      print('User Email: ${user?.email}');

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        final String id = userData['id'];
        final String college = userData['college'];
        final String name = userData['name'];
        final String course = userData['course'];
        final int phoneNumber = userData['phoneNumber'];

        print('ID: $id, College: $college, Name: $name, Course: $course, Phone: $phoneNumber');
        print(userData);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userDetails: UserDetails(
                id: id,
                name: name,
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
          'Settings',
          style: mPlusRoundedText.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 400,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: cardContainerdecoration,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF955AF2),
                            ),
                            child: Center(
                              child: WhiteText(
                                'N',
                                fontSize: 40,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WhiteText(
                                'Naresh',
                                fontSize: 20,
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 220,
                                child: WhiteText(
                                  'tnaresh564@gmail.com',
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 220,
                                child: WhiteText(
                                    'Presidency University, Bangalore',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    cardSettingContainer(text: 'Earnings', iconData: Icons.currency_rupee_rounded),
                    cardSettingContainer(text: 'Payment', iconData: Icons.payment),
                    InkWell(
                      onTap: () {
                        Get.to(statusPage());
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
                padding: EdgeInsets.only(top: 10,bottom: 10),
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
                        label: Text('Profile', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    // Divider(height: 0, color: Colors.grey),
                    Container(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.notification_important, color: Colors.white),
                        label: Text('Notification', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
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
                        label: Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
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
                        label: Text('Terms and Conditions', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
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
                        label: Text('Log-Out', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
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

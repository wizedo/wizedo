import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wizedo/components/my_elevatedbutton.dart';

import '../Widgets/colors.dart';
import '../components/mPlusRoundedText.dart';
import '../components/white_text.dart';
import 'LoginPage.dart';

class UserDetails {
  final String id;
  final String name;
  final String course;
  final String college;
  final int phone;

  UserDetails({
    required this.id,
    required this.name,
    required this.course,
    required this.college,
    required this.phone,
  });
}

class ProfilePage extends StatelessWidget {
  final UserDetails userDetails;

  const ProfilePage({Key? key, required this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final FirebaseAuth auth=FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();


    Future<void> deleteUserAccount() async {
      User? user = auth.currentUser;

      if (user != null) {
        try {
          await user.delete();
          print('User account deleted');

          // Sign out from Firebase
          await auth.signOut();

          // Disconnect from Google Sign-In (if possible)
          if (await googleSignIn.isSignedIn()) {
            try {
              await googleSignIn.disconnect();
              print("Signed out through Google Sign-In");
              final firestore = FirebaseFirestore.instance;
                final docRef = firestore.collection('usersDetails').doc(userDetails.id);
                await firestore.runTransaction((transaction) async {
                  final docSnapshot = await transaction.get(docRef);

                  if (!docSnapshot.exists) {
                    // Handle the case where the document does not exist
                  }
                  // Update the document
                  transaction.set(docRef, {
                    'userDetailsfilled': false
                  });
                });
                Get.showSnackbar(
                  GetSnackBar(
                    borderRadius: 8,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    animationDuration: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 3000),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    snackPosition: SnackPosition.TOP,
                    isDismissible: true,
                    backgroundColor: Color(0xFF955AF2),
                    // Set your desired color here
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
                      'You have account has been successfully deleted',
                      fontSize: 12,
                    ),
                  ),
                );

            } catch (disconnectError) {
              // Handle specific error related to disconnecting from Google Sign-In
              print('Error disconnecting from Google Sign-In: $disconnectError');
            }
          } else {
            print("Signed out normally");
          }

          // Clear cache after sign-out actions
          DefaultCacheManager().emptyCache();
          Get.offAll(LoginPage());

        } catch (e) {
          if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
            print('The user must reauthenticate before this operation can be executed.');
            // Handle reauthentication here
          } else {
            print('Failed to delete user: $e');
          }
        }
      }
    }

    void confirmDeletion() {
      Get.defaultDialog(
        title: 'Confirmation',
        titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 0), // Add padding above the title
        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Set font size of the title
        contentPadding: EdgeInsets.all(25),
        middleText: "Are you sure you want to delete your account?",
        confirm: TextButton(
          onPressed: () async {
            await deleteUserAccount();
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


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF955AF2),
        title: Text('Profile',style: mPlusRoundedText.copyWith(fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: (){
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Container(
                color: Color(0xFF955AF2),
                height: 70,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25,right: 25,left: 25),
                  child: Column(
                    children: [
                      Container(
                        width: screenHeight > 600 ? 125 : 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Set border color to black
                            width:3, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFF955AF2), // Set container background color to transparent
                        ),
                        child: Center(
                          child: Text(
                            userDetails.name.isNotEmpty
                                ? userDetails.name[0].toUpperCase()
                                : '-',
                            style: GoogleFonts.rubikMicrobe(
                              fontSize: screenHeight < 600 ? 50 : 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      buildInfoRow(context,Icons.person, '${userDetails.name}'),
                      SizedBox(height: 20),
                      buildInfoRow(context, Icons.mail_outline_rounded, '${userDetails.id}'),
                      SizedBox(height: 20),
                      buildInfoRow(context, Icons.book_outlined, '${userDetails.course}'),
                      SizedBox(height: 20),
                      buildInfoRow(context, Icons.school, '${userDetails.college}'),
                      // SizedBox(height: 50),
                      // MyElevatedButton(onPressed: confirmDeletion, buttonText: 'Delete Account',customPrimaryColor: Colors.transparent,)
                      // SizedBox(height: 20),
                      // buildInfoRow(context, Icons.phone, '${userDetails.phone}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildInfoRow(BuildContext context,IconData iconData, String text) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(15),
      width: Get.width * 0.99,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
          width: 1.5, // Set border width
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent, // Set container background color to transparent
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: Color(0xFF955AF2),
                size: screenHeight < 600 ? 22 : 32,
              ),
              SizedBox(width: 10),
            ],
          ),
          Expanded(
            child: Text(
              text,
              style: mPlusRoundedText.copyWith(fontSize: screenHeight < 600 ? 9 : 12),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../Widgets/colors.dart';
import '../components/debugcusprint.dart';
import '../components/imagesname.dart';
import '../components/mPlusRoundedText.dart';
import '../components/white_text.dart';
import 'LoginPage.dart';

class UserDetails {
  final String id;
  final String name;
  final String course;
  final String college;
  final int phone;
  final String avatar;
  final Timestamp joinedon;

  UserDetails({
    required this.id,
    required this.name,
    required this.course,
    required this.college,
    required this.phone,
    required this.avatar,
    required this.joinedon
  });
}

class ProfilePage extends StatelessWidget {
  final UserDetails userDetails;

  const ProfilePage({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final FirebaseAuth auth=FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Find the image path based on userDetails.avatar
    String avatarPath = '';
    for (var image in images) {
      if (image['name'] == userDetails.avatar) {
        avatarPath = image['path']!;
        break;
      }
    }

    Future<void> deleteUserAccount() async {
      User? user = auth.currentUser;

      if (user != null) {
        try {
          await user.delete();
          debugLog('User account deleted');

          // Sign out from Firebase
          await auth.signOut();

          // Disconnect from Google Sign-In (if possible)
          if (await googleSignIn.isSignedIn()) {
            try {
              await googleSignIn.disconnect();
              debugLog("Signed out through Google Sign-In");
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
                const GetSnackBar(
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
              debugLog('Error disconnecting from Google Sign-In: $disconnectError');
            }
          } else {
            debugLog("Signed out normally");
          }

          // Open the Hive box
          var userBox = await Hive.openBox('userdetails');

          // Clear all data in the box
          await userBox.clear();

          // Optionally, close the box if no longer needed
          await userBox.close();

          // Clear cache after sign-out actions
          DefaultCacheManager().emptyCache();
          Get.offAll(const LoginPage());

        } catch (e) {
          if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
            debugLog('The user must reauthenticate before this operation can be executed.');
            // Handle reauthentication here
          } else {
            debugLog('Failed to delete user: $e');
          }
        }
      }
    }

    void confirmDeletion() {
      Get.defaultDialog(
        title: 'Confirmation',
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // Add padding above the title
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Set font size of the title
        contentPadding: const EdgeInsets.all(25),
        middleText: "Are you sure you want to delete your account?",
        confirm: TextButton(
          onPressed: () async {
            await deleteUserAccount();
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

    String formattedDate = DateFormat('dd MMMM yyyy').format(userDetails.joinedon.toDate());


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF955AF2),
        title: Text('Profile',style: mPlusRoundedText.copyWith(fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
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
                height: 50,
                color: const Color(0xFF955AF2),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    avatarPath,
                    width: screenHeight < 600 ? 70 : 110,
                    height: screenHeight < 600 ? 70 : 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0,right: 25,left: 25, top: 110),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      buildInfoRow(context, Icons.person, userDetails.name),
                      const SizedBox(height: 20),
                      buildInfoRow(context, Icons.mail_outline_rounded, userDetails.id),
                      const SizedBox(height: 20),
                      buildInfoRow(context, Icons.book_outlined, userDetails.course),
                      const SizedBox(height: 20),
                      buildInfoRow(context, Icons.school, userDetails.college),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WhiteText('Joined $formattedDate'),
                          ElevatedButton(
                              onPressed: confirmDeletion,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.05),
                              elevation: 0,
                                foregroundColor: Colors.red,
                                shape: const StadiumBorder(),
                                side: BorderSide.none
                              ),
                            child: const Text('Delete'),

                          ),
                        ],
                      )
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

  Widget buildInfoRow(BuildContext context, IconData iconData, String text) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(15),
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
                color: const Color(0xFF955AF2),
                size: screenHeight < 600 ? 22 : 32,
              ),
              const SizedBox(width: 10),
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

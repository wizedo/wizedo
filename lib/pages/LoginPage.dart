import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../components/CustomRichText.dart';
import '../components/debugcusprint.dart';
import '../components/rules/PrivacyPolicyDialog.dart';
import '../components/rules/TermsOfServiceDialog.dart';
import '../components/white_text.dart';
import '../controller/UserController.dart';
import '../services/AuthService.dart';
import '../services/email_verification_page.dart';
import 'BottomNavigation.dart';
import 'UserDetailsPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisibility = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final AuthService _authService = AuthService();
  bool loading = false;
  bool isTermsAccepted = false;






  void _showLoadingDialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  void hideLoadingDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }






  Future<void> resetPassword(BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      Get.snackbar('Password Reset Sent',
          'Check your email for the password reset link.');
    } catch (error) {
      String errorMessage = _handleFirebaseError(error);
      Get.snackbar('Password Reset Error',
          'An error occurred while resetting your password.');
      debugLog(errorMessage);
    }
  }

  // Future<void> login(BuildContext context) async {
  //   try {
  //     // Set loading to true to show circular progress indicator
  //     setState(() {
  //       loading = true;
  //       _showLoadingDialog();
  //     });
  //
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: emailController.text,
  //       password: passController.text,
  //     );
  //
  //     User? user = userCredential.user;
  //
  //     if (user != null) {
  //       // Retrieve user document from Firestore
  //       DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
  //           .collection('usersDetails').doc(user.email).get();
  //       if (userDocSnapshot.exists) {
  //         // Check if email is verified
  //         String emailVerified = userDocSnapshot['emailVerified'];
  //         if (emailVerified == 'no') {
  //           // User's email is not verified, navigate to verification screen
  //           Get.to(() =>
  //               EmailVerificationScreen(
  //                 userEmail: emailController.text,
  //                 userPassword: passController.text,
  //               ));
  //         } else {
  //           // User document does not exist
  //           Get.snackbar('Error', 'User data not found.');
  //         }
  //       } else {
  //         // Handle the case where user is null
  //         Get.snackbar('Error', 'Unable to log in. Please try again.');
  //       }
  //     }
  //
  //     Get.showSnackbar(
  //       const GetSnackBar(
  //         borderRadius: 8,
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //         animationDuration: Duration(milliseconds: 800),
  //         duration: Duration(milliseconds: 3000),
  //         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         snackPosition: SnackPosition.TOP,
  //         isDismissible: true,
  //         backgroundColor: Color(0xFF955AF2),
  //         // Set your desired color here
  //         titleText: Row(
  //           children: [
  //             Icon(
  //               Icons.check_circle,
  //               color: Colors.white,
  //               size: 20,
  //             ),
  //             SizedBox(width: 8),
  //             WhiteText(
  //               'Success',
  //               fontSize: 14,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ],
  //         ),
  //         messageText: WhiteText(
  //           'You have successfully logged in',
  //           fontSize: 12,
  //         ),
  //       ),
  //     );
  //
  //
  //     bool userDetailsfilled = await getUserDetailsFilled(emailController.text);
  //
  //     debugLog('belwo is useeemail');
  //     debugLog(emailController.text);
  //
  //     String userName = await getUserName(emailController.text);
  //     debugLog('below is username');
  //     debugLog(userName);
  //
  //     if (userDetailsfilled == true) {
  //       await storeUserCollegeLocally(emailController.text);
  //       Get.offAll(() => const BottomNavigation());
  //     } else {
  //       debugLog('going to userdetails page from login page');
  //       Get.to(() => UserDetails(userEmail: emailController.text));
  //     }
  //   } catch (error) {
  //     debugLog('catch error is $error');
  //     setState(() {
  //       loading = false;
  //       hideLoadingDialog();
  //     });
  //
  //     Get.showSnackbar(
  //       const GetSnackBar(
  //         borderRadius: 8,
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //         animationDuration: Duration(milliseconds: 800),
  //         duration: Duration(milliseconds: 2000),
  //         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         snackPosition: SnackPosition.TOP,
  //         isDismissible: true,
  //         backgroundColor: Color(0xFF955AF2),
  //         // Set your desired color here
  //         titleText: Row(
  //           children: [
  //             Icon(
  //               Icons.warning,
  //               color: Colors.white,
  //               size: 20,
  //             ),
  //             SizedBox(width: 8),
  //             WhiteText(
  //               'Error',
  //               fontSize: 14,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ],
  //         ),
  //         messageText: WhiteText(
  //           'Unable to log in',
  //           fontSize: 12,
  //         ),
  //       ),
  //     );
  //
  //     // Handle the specific FirebaseAuthException
  //     if (error is FirebaseAuthException &&
  //         error.code == 'account-exists-with-different-credential') {
  //       Get.snackbar('Error', 'Account exists with a different credential.');
  //     }
  //   } finally {
  //     setState(() {
  //       loading = false;
  //       hideLoadingDialog();
  //     });
  //   }
  // }

  Future<void> saveUserDetailsLocally(Map<String, dynamic> userDetails) async {
    var box = await Hive.openBox('userdetails');

    // Convert Firestore Timestamp to DateTime if necessary
    if (userDetails['lastUpdated'] is Timestamp) {
      userDetails['lastUpdated'] = (userDetails['lastUpdated'] as Timestamp).toDate();
    }

    await box.putAll(userDetails);
  }


  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        debugLog('User has clicked out of Google sign-in pop-up');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

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
            'You have successfully logged in',
            fontSize: 12,
          ),
        ),
      );

      String userEmail = googleUser.email;
      debugLog("User email through Google sign-in is: $userEmail");

      // Fetch user details from Firestore
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('usersDetails').doc(userEmail);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userDetails = docSnapshot.data()!;
        await saveUserDetailsLocally(userDetails);
      } else {
        debugLog('User details not found in Firestore');
        return null;
      }

      Get.put(UserController());
      final UserController userController = Get.find<UserController>();

      // Retrieve user details from Hive and set them in UserController
      var box = await Hive.openBox('userdetails');
      var storedUserDetails = box.toMap().cast<String, dynamic>();
      userController.setUserDetails(storedUserDetails);

      // Print user details for debugging
      print('Avatar: ${userController.avatar}');
      print('ID: ${userController.id}');
      print('First Name: ${userController.firstname}');
      print('Last Name: ${userController.lastname}');
      print('Country: ${userController.country}');
      print('College: ${userController.college}');
      print('Course: ${userController.course}');
      print('Course Start Year: ${userController.courseStartYear}');
      print('User Details Filled: ${userController.userDetailsfilled}');
      print('Last Updated: ${userController.lastUpdated}');
      print('Email Verified: ${userController.emailVerified}');

      // Now, check userDetailsfilled and redirect the user
      bool userDetailsfilled = docSnapshot['userDetailsfilled'];

      if (userDetailsfilled) {
        Get.offAll(() => const BottomNavigation());
      } else {
        Get.to(() => UserDetails(userEmail: userEmail));
      }

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle exceptions appropriately
      debugLog('Exception -> $e');
      return null;
    }
  }




  String _handleFirebaseError(dynamic error) {
    if (error is FirebaseAuthException) {
      debugLog(error.code);
      switch (error.code) {
        case 'user-not-found':
          debugLog('Debug: User not found for email ${emailController.text}');
          return 'Account not found';
        case 'INVALID_LOGIN_CREDENTIALS':
          return 'Check you credentials..your email or password is wrong';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection and try again.';
        default:
          return 'An unexpected error occurred. Please try again later.';
      }
    } else if (error is PlatformException) {
      switch (error.code) {
        case 'NETWORK_ERROR':
          return 'Network error. Please check your internet connection and try again.';
        case 'DEVICE_NOT_SUPPORTED':
          return 'Your device is not supported. Please try again on a different device.';
        // Add more cases for specific PlatformException errors

        default:
          return 'An unexpected error occurred. Please try again later.';
      }
    } else {
      return 'An unexpected error occurred. Please try again later.';
    }
  }



  Future<bool> getUserDetailsFilled(String userEmail) async {
    try {
      if (userEmail.isEmpty) {
        debugLog('Error: Empty email passed to getUserDetailsFilled');
        return false;
      }
      DocumentReference userDocRef =
          _firestore.collection('usersDetails').doc(userEmail);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        bool userDetailsfilled = userDocSnapshot['userDetailsfilled'];
        debugLog('User details value debugLoged');
        debugLog('userDetailsfilled value for $userEmail: $userDetailsfilled');
        return userDetailsfilled ?? false;
      } else {
        return false;
      }
    } catch (error) {
      debugLog('Error getting user details: $error');
      return false;
    }
  }

  Future<String> getUserName(String userEmail) async {
    try {
      if (userEmail.isEmpty) {
        debugLog('Error: Empty email passed to getUserName');
        return ''; // Return an empty string or handle the error case accordingly
      }
      DocumentReference userDocRef =
          _firestore.collection('usersDetails').doc(userEmail);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        String username = userDocSnapshot['firstname'];
        debugLog('User details value debugLoged');
        // debugLog('username value for $userEmail: $username');
        return username;
      } else {
        return ''; // Return an empty string or handle the case where the document doesn't exist
      }
    } catch (error) {
      debugLog('Error getting user details: $error');
      return ''; // Return an empty string or handle the error case accordingly
    }
  }

  Future<void> showPrivacyPolicy(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PrivacyPolicyDialog();
      },
    );
  }

  Future<void> showTermsOfServiceDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return TermsOfServiceDialog();
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold background transparent
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(1), // Very light white
              const Color(0xFF955AF2), // Your purplish color
            ],
            stops: const [0.5, 1], // Adjust the stops as needed
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 310,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const Flexible(
                        flex: 4, // Adjust flex as needed
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomRichText(
                            firstText: 'Peer',
                            secondText: 'mate',
                            firstColor: Colors.black,
                            secondColor: Color(0xFF955AF2),
                            firstFontSize: 35,
                            secondFontSize: 35,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1, // Adjust flex as needed
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isTermsAccepted,
                                  activeColor: const Color(0xFF955AF2),
                                  onChanged: (newValue) {
                                    setState(() {
                                      isTermsAccepted = newValue ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'I accept the ',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'terms of service',
                                          style: const TextStyle(
                                            color: Color(0xFF955AF2),
                                            fontWeight: FontWeight.bold
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                            if (kDebugMode) {
                                              debugLog('terms inside');
                                            }
                                            showTermsOfServiceDialog(context);
                                            },
                                        ),
                                        const TextSpan(
                                          text: ' & ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        TextSpan(
                                          text: 'privacy policy',
                                          style: const TextStyle(
                                            color: Color(0xFF955AF2),
                                            fontWeight: FontWeight.bold
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              if (kDebugMode) {
                                                debugLog('privacy inside');
                                              }
                                              showPrivacyPolicy(context);
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                if (isTermsAccepted) {
                                  signInWithGoogle();
                                } else {
                                  Get.showSnackbar(
                                    GetSnackBar(
                                      borderRadius: 8,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      animationDuration: const Duration(milliseconds: 600),
                                      duration: const Duration(milliseconds: 3350),
                                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      snackPosition: SnackPosition.BOTTOM,
                                      isDismissible: true,
                                      backgroundColor: Colors.red.shade400,
                                      // Set your desired color here
                                      messageText: const WhiteText(
                                        'Please review and accept the terms of service and privacy policy.',
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: const Color(0xFF955AF2),
                                  width: 300,
                                  height: 55,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'lib/images/google.png',
                                          width: 45,
                                          height: 45,
                                        ),
                                        const SizedBox(width: 18),
                                        const Center(
                                          child: WhiteText(
                                            'Sign in with Google',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
            ),
          ),
        )
      ),
    );
  }

}

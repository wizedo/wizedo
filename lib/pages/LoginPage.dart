import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/colors/sixty.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_text_field.dart';
import '../components/my_textbutton.dart';
import '../components/white_text.dart';
import '../components/purple_text.dart';
import '../services/AuthService.dart';
import '../services/email_verification_page.dart';
import 'BottomNavigation.dart';
import 'HomePage.dart';
import 'RegisterPage.dart';
import 'UserDetailsPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisibility = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final AuthService _authService = AuthService();
  bool loading = false;

  Future<void> storeUserCollegeLocally(String userEmail) async {
    try {
      print("in try block of storeusercollegelocally");
      final docSnapshot =
          await _firestore.collection('usersDetails').doc(userEmail).get();
      if (docSnapshot.exists) {
        final userData = docSnapshot.data() as Map<String, dynamic>;
        final userCollege = userData['college'];
        print('User College stored locally: $userCollege');

        // Store the user's college name locally
        await saveCollegeLocally(userCollege, userEmail);
      } else {
        print('User details document does not exist');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

  Future<void> saveCollegeLocally(String collegeName, String userEmail) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('selectedCollege_$userEmail', collegeName);
    } catch (error) {
      print('Error saving college locally: $error');
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      Center(
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


  Future<void> setUserDetailsFilledLocally(String email, bool value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('userDetailsFilled_$email', value);
    } catch (error) {
      print('Error setting user details locally: $error');
    }
  }

  Future<void> setUserNameLocally(String email, String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName_$email', name);
    } catch (error) {
      print('Error setting user name locally: $error');
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
      print(errorMessage);
    }
  }

  Future<void> login(BuildContext context) async {
    try {
      // Set loading to true to show circular progress indicator
      setState(() {
        loading = true;
        _showLoadingDialog();
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Retrieve user document from Firestore
        DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
            .collection('usersDetails').doc(user.email).get();
        if (userDocSnapshot.exists) {
          // Check if email is verified
          bool emailVerified = userDocSnapshot['emailVerified'] == 'yes';
          if (!emailVerified) {
            // User's email is not verified, navigate to verification screen
            Get.to(() =>
                EmailVerificationScreen(
                  userEmail: emailController.text,
                  userPassword: passController.text,
                ));
            return;
          } else {
            // User document does not exist
            // Get.snackbar('Error', 'User data not found.');
          }
        } else {
          // Handle the case where user is null
          Get.snackbar('Error', 'Unable to log in. Please try again.');
        }
      }

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
            'You have successfully logged in',
            fontSize: 12,
          ),
        ),
      );

      // Save user Gmail ID locally using shared preferences
      await saveUserEmailLocally(emailController.text);

      bool userDetailsfilled = await getUserDetailsFilled(emailController.text);
      await setUserDetailsFilledLocally(
          emailController.text, userDetailsfilled);
      print('belwo is useeemail');
      print(emailController.text);

      String userName = await getUserName(emailController.text);
      await setUserNameLocally(emailController.text, userName);
      print('below is username');
      print(userName);

      if (userDetailsfilled == true) {
        await storeUserCollegeLocally(emailController.text);
        Get.offAll(() => BottomNavigation());
      } else {
        print('going to userdetails page from login page');
        Get.to(() => UserDetails(userEmail: emailController.text));
      }
    } catch (error) {
      setState(() {
        loading = false;
        hideLoadingDialog();
      });

      Get.showSnackbar(
        GetSnackBar(
          borderRadius: 8,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(milliseconds: 2000),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          backgroundColor: Color(0xFF955AF2),
          // Set your desired color here
          titleText: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              WhiteText(
                'Error',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          messageText: WhiteText(
            'Unable to log in',
            fontSize: 12,
          ),
        ),
      );

      // Handle the specific FirebaseAuthException
      if (error is FirebaseAuthException &&
          error.code == 'account-exists-with-different-credential') {
        Get.snackbar('Error', 'Account exists with a different credential.');
      }
    } finally {
      setState(() {
        loading = false;
        hideLoadingDialog();
      });
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        print('user has clicked out of google sign in pop up');
        return null;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

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
            'You have successfully logged in',
            fontSize: 12,
          ),
        ),
      );

      String userEmail = googleUser.email;
      print("useremail through google sign is: $userEmail");

      // Save user Gmail ID locally using shared preferences
      await saveUserEmailLocally(userEmail);

      // Now, check userDetailsfilled and redirect the user
      bool userDetailsfilled = await getUserDetailsFilled(userEmail);
      String userName = await getUserName(userEmail);
      print(userDetailsfilled);
      print('Below is username');
      print(userName);
      await setUserDetailsFilledLocally(userEmail, userDetailsfilled);
      await setUserNameLocally(userEmail, userName);

      if (userDetailsfilled == true) {
        await storeUserCollegeLocally(userEmail);
        Get.offAll(() => BottomNavigation());
      } else {
        Get.to(() => UserDetails(userEmail: userEmail));
      }

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle exceptions appropriately
      print('exception->$e');
      return null;
    }
  }

  String _handleFirebaseError(dynamic error) {
    if (error is FirebaseAuthException) {
      print(error.code);
      switch (error.code) {
        case 'user-not-found':
          print('Debug: User not found for email ${emailController.text}');
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

  Future<void> saveUserEmailLocally(String userEmail) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', userEmail);
    } catch (error) {
      print('Error saving user email locally: $error');
    }
  }

  Future<bool> getUserDetailsFilled(String userEmail) async {
    try {
      if (userEmail.isEmpty) {
        print('Error: Empty email passed to getUserDetailsFilled');
        return false;
      }
      DocumentReference userDocRef =
          _firestore.collection('usersDetails').doc(userEmail);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        bool userDetailsfilled = userDocSnapshot['userDetailsfilled'];
        print('User details value printed');
        print('userDetailsfilled value for $userEmail: $userDetailsfilled');
        return userDetailsfilled ?? false;
      } else {
        return false;
      }
    } catch (error) {
      print('Error getting user details: $error');
      return false;
    }
  }

  Future<String> getUserName(String userEmail) async {
    try {
      if (userEmail.isEmpty) {
        print('Error: Empty email passed to getUserName');
        return ''; // Return an empty string or handle the error case accordingly
      }
      DocumentReference userDocRef =
          _firestore.collection('usersDetails').doc(userEmail);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        String username = userDocSnapshot['firstname'];
        print('User details value printed');
        print('username value for $userEmail: $username');
        return username;
      } else {
        return ''; // Return an empty string or handle the case where the document doesn't exist
      }
    } catch (error) {
      print('Error getting user details: $error');
      return ''; // Return an empty string or handle the error case accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorUtil.hexToColor('#211b2e');

    return Scaffold(
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(alignment: Alignment.center, children: [
              SingleChildScrollView(
                child: Container(
                  width: 310,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Image.asset(
                        'lib/images/login_animation.png',
                        width: 400,
                        height: 160,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: WhiteText(
                          'Login',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                            WhiteText('Please login to continue', fontSize: 16),
                      ),
                      SizedBox(height: 25),
                      MyTextField(
                        controller: emailController,
                        label: 'Email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        fontSize: 11.5,
                      ),
                      SizedBox(height: 25),
                      MyTextField(
                        controller: passController,
                        label: 'Password',
                        obscureText: !passwordVisibility,
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              passwordVisibility = !passwordVisibility;
                            });
                          },
                          child: Icon(
                            passwordVisibility
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        fontSize: 11.5,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: MyTextButton(
                          onPressed: () {
                            resetPassword(
                                context); // Call the resetPassword method on button press
                          },
                          buttonText: 'Forgot Password?',
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 15),
                      MyElevatedButton(
                        onPressed: () {
                          login(context);
                        },
                        buttonText: 'Login',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 19),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 1.5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.0, 0.5, 1.0, 1.0],
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFF955AF2),
                                    Color(0xFF955AF2),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: PurpleText(
                                'Or Continue with',
                                fontSize: 12,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 1.5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: [0.0, 0.0, 0.5, 1.0],
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFF955AF2),
                                    Color(0xFF955AF2),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle();
                        },
                        child: Image.asset(
                          'lib/images/google.png',
                          width: 45,
                          height: 45,
                        ),
                      ),

                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WhiteText('Not a member?', fontSize: 12),
                          MyTextButton(
                            onPressed: () {
                              Get.to(() => RegisterPage());
                            },
                            buttonText: 'Register Now',
                            fontSize: 12,
                          ),
                        ],
                      ),
                      // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 150),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

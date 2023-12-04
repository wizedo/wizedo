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

  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      if (userCredential.user != null &&
          userCredential.user!.providerData.any(
                (userInfo) => userInfo.providerId == 'google.com',
          )) {
        Get.snackbar('Error', 'This email is associated with a Google account. Please sign in with Google.');
        return;
      }

      Get.snackbar('Success', 'Sign in successful');

      // Save user Gmail ID locally using shared preferences
      await saveUserEmailLocally(emailController.text);

      bool userDetailsfilled = await getUserDetailsFilled(emailController.text);

      if (userDetailsfilled == true) {
        Get.offAll(() => BottomNavigation());
      } else {
        Get.to(() => UserDetails(userEmail: emailController.text));
      }
    } catch (error) {
      String errorMessage = _handleFirebaseError(error);
      Get.snackbar('Error', errorMessage);

      // Handle the specific FirebaseAuthException
      if (error is FirebaseAuthException && error.code == 'account-exists-with-different-credential') {
        Get.snackbar('Error', 'Account exists with a different credential.');
      }
    }
  }
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _authService.signInWithGoogle();
      print('gmail signin');
      if (googleSignInAccount != null) {
        print('user is signed through gmail ');
        String userEmail = googleSignInAccount.email ?? '';

        print('User signed in with Google. Email: $userEmail');

        DocumentSnapshot userDocSnapshot = await _firestore.collection('usersDetails').doc(userEmail).get();

        if (!userDocSnapshot.exists) {
          await _firestore.collection('usersDetails').doc(userEmail).set({
            'id': userEmail,
            'userDetailsfilled': false,
          });
          print('User document created for $userEmail');
        }

        bool userDetailsfilled = await getUserDetailsFilled(userEmail);

        if (userDetailsfilled == true) {
          Get.offAll(() => BottomNavigation());
        } else {
          Get.to(() => UserDetails(userEmail: userEmail));
        }
      } else {
        Get.snackbar('Error', 'Failed to sign in with Google.');
      }
    } catch (error) {
      Get.snackbar('Error', 'Error signing in with Google: $error');
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
      DocumentReference userDocRef = _firestore.collection('usersDetails').doc(userEmail);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        bool userDetailsfilled = userDocSnapshot['userDetailsfilled'];
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

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorUtil.hexToColor('#211b2e');

    return Scaffold(
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
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
                      child: WhiteText('Please login to continue', fontSize: 16),
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
                          passwordVisibility ? Icons.visibility_off : Icons.visibility,
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
                          Get.to(BottomNavigation());
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      signInWithGoogle(context);
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
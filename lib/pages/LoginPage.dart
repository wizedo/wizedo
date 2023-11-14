// import 'package:wizedo/Pages/homepage.dart';
// import 'package:wizedo/Pages/register_page.dart';
// import 'package:wizedo/Services/AuthService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wizedo/components/my_button.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:wizedo/pages/UserDetailsPage.dart';
import 'package:wizedo/pages/detailsPage.dart';
import '../components/colors/sixty.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_textbutton.dart';
import '../components/purple_text.dart';
import '../services/AuthService.dart';
import 'BottomNavigation.dart';
import 'HomePage.dart';
import 'RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';





class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool passwordVisibility = false;
  FocusNode myFocusNode = FocusNode();
  String hexColor = '#211b2e';
  RxBool loading = false.obs;
  bool userDetailsfilled = false; // Initialize userDetailsfilled as false

  //instance of auth
  FirebaseAuth _auth=FirebaseAuth.instance;  //creaing instance for easier use through _auth

  //instance of firestore
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;


  //signin user
  final emailController =TextEditingController();
  final passController =TextEditingController();

  //this below code is to sign in with google - currently under test
  final AuthService _authService = AuthService();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> getUserDetailsFilled(String userEmail) async {
    try {
      // Get a reference to the document for the specific user
      DocumentReference userDocRef = _firestore.collection('usersDetails').doc(userEmail);

      // Get the document snapshot
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Check if the document exists
      if (userDocSnapshot.exists) {
        // Extract the userDetailsfilled value from the document data
        bool userDetailsfilled = userDocSnapshot['userDetailsfilled'];

        // Print userDetailsfilled value to the console for debugging
        print('userDetailsfilled value for $userEmail: $userDetailsfilled');
        return userDetailsfilled ?? false; // Default to false if userDetailsfilled is not present
      } else {
        // Document does not exist, return false
        return false;
      }
    } catch (error) {
      print('Error getting user details: $error');
      return false;
    }
  }


  // signin logic
  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      // Check if the user is linked with a Google account
      if (userCredential.user != null &&
          userCredential.user!.providerData.any(
                (userInfo) => userInfo.providerId == 'google.com',
          )) {
        Get.snackbar('Error',
            'This email is associated with a Google account. Please sign in with Google.');
        return;
      }
      Get.snackbar('Success', 'Sign in successful');
      bool userDetailsfilled = await getUserDetailsFilled(emailController.text);
      if (userDetailsfilled==true) {
        print(userDetailsfilled);
        print('homepage');
        Get.offAll(() => BottomNavigation());
      } else {
        print('userdetails');
        Get.to(() => UserDetails(userEmail: emailController.text));
        // User details are not filled, send to userdetailspage
      }
      // Navigate to the next screen upon successful sign-in.
    } catch (error) {
      Get.snackbar('Error', 'Error signing in: $error');
    } finally {
      loading.value = false;
    }
  }


  // loginwithgoogle
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _authService.signInWithGoogle();
      print('gmail signin');
      if (googleSignInAccount != null) {
        print('user is signed through gmail ');
        // Get the user email from the GoogleSignInAccount
        String userEmail = googleSignInAccount.email ?? '';

        // Print the user email for debugging
        print('User signed in with Google. Email: $userEmail');

        // Check if a document already exists for this user
        DocumentSnapshot userDocSnapshot = await _firestore.collection('usersDetails').doc(userEmail).get();

        if (!userDocSnapshot.exists) {
          // If the document does not exist, create one
          await _firestore.collection('usersDetails').doc(userEmail).set({
            'id': userEmail,
            'userDetailsfilled': false,
          });
          print('User document created for $userEmail');
        }
        // Check userDetailsfilled for the retrieved email
        bool userDetailsfilled = await getUserDetailsFilled(userEmail);

        if (userDetailsfilled==true) {
          // print('Homepage');
          // Get.offAll(() => HomePage());
        } else {
          print('Userdetails');
          Get.to(() => UserDetails(userEmail: userEmail));
          // User details are not filled, send to userdetailspage
        }
      } else {
        Get.snackbar('Error', 'Failed to sign in with Google.');
      }
    } catch (error) {
      Get.snackbar('Error', 'Error signing in with Google: $error');
    } finally {
      loading.value = false;
    }
  }




  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorUtil.hexToColor(hexColor);

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
                            passwordVisibility = !passwordVisibility; // Toggle visibility for password field
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
                          // Handle forgot password logic
                        },
                        buttonText: 'Forgot Password?',
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 15),

                    MyElevatedButton(onPressed: (){
                      login(context);
                    }, buttonText: 'Login',fontWeight: FontWeight.bold,),

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
                        // Handle Google sign-in logic
                        _authService.signInWithGoogle();
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
                        MyTextButton(onPressed: (){
                          Get.to(() => RegisterPage());
                        }, buttonText: 'Register Now',fontSize: 12,)
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
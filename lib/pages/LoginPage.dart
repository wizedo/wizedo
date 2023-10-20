// import 'package:wizedo/Pages/homepage.dart';
// import 'package:wizedo/Pages/register_page.dart';
// import 'package:wizedo/Services/AuthService.dart';
import 'package:wizedo/components/my_button.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/colors/sixty.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_textbutton.dart';
import '../components/purple_text.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String hexColor = '#211b2e';
  // RxBool loading = false.obs;
  //
  // //instance of auth
  // FirebaseAuth _auth=FirebaseAuth.instance;  //creaing instance for easier use through _auth
  //
  // //instance of firestore
  // final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  //
  //signin user
  final emailController =TextEditingController();
  final passController =TextEditingController();

  // final AuthService _authService = AuthService();


  //signin logic
  // Future<void> login(BuildContext context) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: emailController.text,
  //       password: passController.text,
  //     );
  //
  //     // Check if the user is linked with a Google account
  //     if (userCredential.user != null && userCredential.user!.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
  //       Get.snackbar('Error', 'This email is associated with a Google account. Please sign in with Google.');
  //       return;
  //     }
  //
  //     // after creating the user, create a new document for the user in the users collection
  //     _firestore.collection('users').doc(userCredential.user!.uid).set({
  //       'uid': userCredential.user!.uid,
  //       'email': emailController.text,
  //     });
  //     Get.snackbar('Success', 'Sign in successful');
  //     // Navigate to the next screen upon successful sign-in.
  //     // Get.offAll(() => HomePage());
  //   } catch (error) {
  //     Get.snackbar('Error', 'Error signing in: $error');
  //   } finally {
  //     loading.value = false;
  //   }
  // }



  //loginwithgoogle
  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     UserCredential? userCredential = await _authService.signInWithGoogle();
  //     if (userCredential != null) {
  //       // Create a new document for the user in the 'users' collection
  //       await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
  //         'uid': userCredential.user!.uid,
  //         'email': userCredential.user!.email,
  //         // Add other user details as needed
  //       });
  //
  //       Get.snackbar('Success', 'Sign in with Google successful');
  //
  //       // Navigate to the next screen upon successful sign-in.
  //       Get.offAll(() => HomePage());
  //     }
  //   } catch (error) {
  //     Get.snackbar('Error', 'Error signing in with Google: $error');
  //   } finally {
  //     loading.value = false;
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorUtil.hexToColor(hexColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea( // this will just avoid notch bit
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Container(
                width: 308,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50,),

                    //logo
                    Icon(
                      Icons.supervised_user_circle_outlined,
                      size: 90,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(height: 50,),
                    //welcome back message
                    Align(
                      alignment: Alignment.topLeft,
                      child: WhiteText('Login',fontSize: 36 ,),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: WhiteText('Please login in to continue',fontSize: 16,),
                    ),
                    const SizedBox(height: 25,),

                    //email textfield
                    MyTextField(
                        controller: emailController,
                        label: 'Email',
                        obsecureText: false,
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                    ),
                    const SizedBox(height: 25,),

                    //password textfield
                    MyTextField(
                        controller: passController,
                        label: 'Password',
                        obsecureText: true,
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: MyTextButton(onPressed: (){
                        //login function call
                      },
                        buttonText: 'Forgot Password?',
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 19,),

                    //sign in button
                    MyElevatedButton(onPressed: (){
                      // login(context);
                    },
                      buttonText: 'Login',
                    ),
                    const SizedBox(height: 19),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Divider(
                                color: Color(0xFF955AF2),
                                thickness: 1.5,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              PurpleText('Or Continue with',fontSize: 15)
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Divider(
                                color: Color(0xFF955AF2),
                                thickness: 1.5,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // _authService.signInWithGoogle();
                          },
                          child: Image.asset(
                            'lib/images/google.png', // Replace with your Google Sign-In button image
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 19),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WhiteText('Not a member?',fontSize: 15,),
                          MyTextButton(onPressed: (){
                            // Get.to(RegisterPage());
                          }, buttonText: 'Register Now',fontSize: 17,),
                        ],
                      ),
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
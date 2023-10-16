// import 'package:wizedo/Pages/homepage.dart';
// import 'package:wizedo/Pages/register_page.dart';
// import 'package:wizedo/Services/AuthService.dart';
import 'package:wizedo/components/my_button.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/colors/sixty.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_textbutton.dart';




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
                  Text(
                    "Welcome back you've been missed",
                    style: TextStyle(
                        fontSize: 16
                    ),),
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

                  Padding(
                    padding: const EdgeInsets.only(left: 200),
                    child: MyTextButton(onPressed: (){
                    },
                      buttonText: 'Forgot Password?',
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2,),

                  //sign in button
                  MyElevatedButton(onPressed: (){
                    // login(context);
                  },
                    buttonText: 'Login',
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?'),
                      const SizedBox(width:5,),
                      MyTextButton(onPressed: (){
                        // Get.to(RegisterPage());
                      }, buttonText: 'Register Now'),
                    ],
                  ),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}
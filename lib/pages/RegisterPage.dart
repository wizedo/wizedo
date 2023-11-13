import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/HomePage.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_text_field.dart';
import '../components/my_textbutton.dart';
import '../components/white_text.dart';
import '../services/email_verification_page.dart';
import 'LoginPage.dart';
import 'UserDetailsPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;
  bool isTermsAccepted = false;
  final unameController = TextEditingController();
  final phonenoController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  //instance of firestore
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;


  //terms and conditions instructions agreement
  Future<void> showTermsOfServiceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Terms of Service"),
          content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text(
                    'Terms and Conditions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'Please read these terms carefully before using the app.',
                    style: TextStyle(fontSize: 10),),
                  SizedBox(height: 10),
                  Text(
                    '1.User Registration:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'Users must provide accurate and complete information during the registration process. Users are responsible for maintaining the confidentiality of their account credentials.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '2.Content Sharing:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'Users can share knowledge, collaborate, and assign tasks within the app. Users are solely responsible for the content they post. Inappropriate, offensive, or illegal content is strictly prohibited.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '3.Payments:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'Users can make and receive payments within the app for completed tasks. Payments are processed securely, and the app is not responsible for any payment disputes between users.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '4.Safety and Security:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'Users are responsible for their own safety when meeting others in person. The app does not conduct background checks on users. Users are advised to meet in public places and exercise caution.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '5.Prohibited Activities:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'Users are prohibited from engaging in fraudulent activities, spamming, hacking, or any other illegal or unauthorized use of the app.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '6.Termination:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'The app reserves the right to suspend or terminate user accounts that violate these terms and conditions.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '7.Changes to Terms:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'The app reserves the right to modify these terms and conditions at any time. Users will be notified of any changes.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'By using our app, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions. If you do not agree with these terms, please do not use the app.',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                  ),
                ],
              )

          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showPrivacyPolicy() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Privacy Policy"),
          content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This Privacy Policy describes how we collect, use, and disclose personal information when you use our peer-to-peer learning app.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '1.Information We Collect:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'We collect personal information such as name, email address, phone number, and payment details when you register an account, post content, or make payments within the app.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '2.How We Use Your Information:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'We use your personal information to provide and improve our services, process payments, communicate with you, and ensure the security of our app. By using our app, you consent to the collection and use of your information as described in this Privacy Policy.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '3.Sharing Your Information:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'We may share your information with other users within the app as necessary for the peer-to-peer learning process. Your payment information will be securely processed through a third-party payment gateway.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '4.Data Security:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'We take appropriate measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no data transmission over the internet or stored on a server can be guaranteed to be 100% secure. Therefore, while we strive to protect your privacy, we cannot guarantee its absolute security.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '5.Your Choices:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'You can review, update, or delete your account and personal information at any time. Please contact us if you need assistance with these options.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '6.Changes to Privacy Policy:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    'We reserve the right to modify this Privacy Policy at any time. You will be notified of any changes, and your continued use of the app after such modifications will constitute your acknowledgment and acceptance of the updated Privacy Policy.',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'By using our app, you acknowledge that you have read, understood, and agreed to the terms of this Privacy Policy. If you do not agree with this Privacy Policy, please do not use the app.',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
                  ),
                ],
              )


          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> registerWithEmailAndPassword(BuildContext context) async {
    try {
      if (passController.text == confirmController.text) {
        // Pass email, password, and confirm password to EmailVerificationScreen
        Get.to(() => EmailVerificationScreen(
          userEmail: emailController.text,
          userPassword: passController.text,
        ));
      } else {
        Get.snackbar('', 'Passwords do not match...');
      }
    } catch (error) {
      print('Error registering user: $error');
      // Display an error message to the user.
    }
  }



  @override
  Widget build(BuildContext context) {
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: WhiteText(
                        'Create Account',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: WhiteText('Join Us: Create Your Account Now!', fontSize: 12),
                    ),
                    Image.asset(
                      'lib/images/signup.png',
                      height: 200,
                    ),
                    SizedBox(height: 25),
                    MyTextField(
                      controller: emailController,
                      label: 'Email',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email,
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
                        Icons.password_rounded,
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
                    SizedBox(height: 25),
                    MyTextField(
                      controller: confirmController,
                      label: 'Confirm Password',
                      obscureText: !confirmPasswordVisibility,
                      prefixIcon: Icon(
                        Icons.password_rounded,
                        color: Colors.white,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            confirmPasswordVisibility = !confirmPasswordVisibility;
                          });
                        },
                        child: Icon(
                          confirmPasswordVisibility ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      fontSize: 11.5,
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Checkbox(
                          value: isTermsAccepted,
                          onChanged: (newValue) {
                            setState(() {
                              isTermsAccepted = newValue ?? false;
                            });
                          },
                        ),
                        Flexible(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                text: 'I accept the ',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'terms of service',
                                    style: TextStyle(
                                      color: Color(0xFF955AF2),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showTermsOfServiceDialog();
                                        // Add functionality to navigate to terms of service page
                                      },
                                  ),
                                  TextSpan(
                                    text: ' & ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'privacy policy',
                                    style: TextStyle(
                                      color: Color(0xFF955AF2),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showPrivacyPolicy();
                                        // Add functionality to navigate to privacy policy page
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    MyElevatedButton(
                      onPressed: () {
                        if (isTermsAccepted) {
                          registerWithEmailAndPassword(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please accept the terms of service and privacy policy.'),
                            ),
                          );
                        }
                      },
                      buttonText: 'Sign Up',
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WhiteText('Already have an account?', fontSize: 12),
                        MyTextButton(
                          onPressed: () {
                            Get.to(() => LoginPage());
                          },
                          buttonText: 'Login Now',
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/UserDetailsPage.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_text_field.dart';
import '../components/my_textbutton.dart';
import '../components/white_text.dart';
import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;
  final unameController = TextEditingController();
  final phonenoController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmpassword = TextEditingController();

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
                      obscureText: false, // Set obscureText to false here
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
                      obscureText: !passwordVisibility, // Use passwordVisibility for password field
                      prefixIcon: Icon(
                        Icons.password_rounded,
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
                    SizedBox(height: 25),
                    MyTextField(
                      controller: confirmpassword,
                      label: 'Confirm Password',
                      obscureText: !confirmPasswordVisibility, // Use confirmPasswordVisibility for confirm password field
                      prefixIcon: Icon(
                        Icons.password_rounded,
                        color: Colors.white,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            confirmPasswordVisibility = !confirmPasswordVisibility; // Toggle visibility for confirm password field
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


                    SizedBox(height: 40),
                    MyElevatedButton(onPressed: () {
                      Get.to(()=>UserDetails());
                    }, buttonText: 'Sign Up', fontWeight: FontWeight.bold,),
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
                        )
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

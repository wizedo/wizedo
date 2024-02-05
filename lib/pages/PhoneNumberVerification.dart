import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/my_elevatedbutton.dart';
import 'package:wizedo/pages/OtpScreen.dart';
import 'dart:math';
import '../Widgets/colors.dart';
import '../components/mPlusRoundedText.dart';
import '../components/my_text_field.dart';
import '../components/white_text.dart';

class PhoneNumberVerification extends StatefulWidget {
  const PhoneNumberVerification({super.key});

  @override
  State<PhoneNumberVerification> createState() => _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  bool isFinished = false;


  final TextEditingController phonenoController = TextEditingController();

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  bool _validateInputs() {
    bool isValid = errors.isEmpty;

    if (!isValid) {
      Get.rawSnackbar(message: "Please Give a valid INPUT");
    }
    return isValid;
  }

  String generateOtp(String phoneNumber) {
    // Use the phoneNumber and a random number to generate a four-digit OTP
    String otp = '';

    // Add the first two digits of the phoneNumber
    otp += phoneNumber.substring(0, 2);

    // Add two random digits
    otp += '${Random().nextInt(10)}${Random().nextInt(10)}';

    return otp;
  }

  Future<void> setUserOtpLocally(String email, String otp) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userOtp_$email', otp);
    } catch (error) {
      print('Error setting user OTP locally: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Set this to false to remove the back button
        title: Text(
          'Verification',
          style: mPlusRoundedText.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Center(
                      //   child: Image.asset(
                      //     'lib/images/phonescreen.png',
                      //     width: Get.width*0.8,
                      //     height: Get.width*0.5,
                      //   ),
                      // ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: WhiteText('Enter Your Mobile Number',fontWeight: FontWeight.bold,)),
                      SizedBox(height: 5,),

                      // Use the updated WhiteText widget with bold style
                      // Or using WhiteText for each part
                      Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: WhiteText(
                                  'We will send you a Verification Code',
                                  fontSize: 16.0,
                                ),
                              ),
                              // WidgetSpan(
                              //   child: WhiteText(
                              //     'One Time Password',
                              //     fontSize: 16.0,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              // WidgetSpan(
                              //   child: WhiteText(
                              //     ' on your phone number',
                              //     fontSize: 16.0,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: MyTextField(
                          controller: phonenoController,
                          width: Get.width*0.9,
                          label: 'Phone Number',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          textColor: Color(0xFFdacfe6),
                          prefixIcon: Center(
                            child: Text(
                              '+91',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          fontSize: 12,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              addError(error: 'Phone Number is required');
                              return 'Phone Number is required';
                            } else {
                              removeError(error: 'Phone Number is required');
                            }
                            if (value != null && value.length < 10) {
                              addError(error: 'Enter full 10 digit number');
                              return 'Enter full 10 digit number';
                            } else {
                              removeError(error: 'Enter full 10 digit number');
                            }
                            if (value != null && value.length > 10) {
                              addError(error: 'Maximum Numbers allowed is 10');
                              return 'Maximum Numbers allowed is 10';
                            } else {
                              removeError(error: 'Maximum Numbers allowed is 10');
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 150,),
                    ],
                  ),
                ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 10 , right: 10 , bottom: 5),
          child: MyElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                bool isValid = _validateInputs();

                if (isValid) {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final firestore = FirebaseFirestore.instance;
                      final email = user.email!;
                      final docRef = firestore.collection('usersDetails').doc(email);
                      print('user email in phone number page is :');
                      print(email);

                      // Check if the phone number already exists
                      final existingPhoneNumber = await firestore
                          .collection('usersDetails')
                          .where('phonenumber', isEqualTo: phonenoController.text)
                          .get();

                      if (existingPhoneNumber.docs.isNotEmpty) {
                        Get.snackbar('Error', 'Phone number already exists');
                        return;
                      }

                      await firestore.runTransaction((transaction) async {
                        final docSnapshot = await transaction.get(docRef);

                        if (!docSnapshot.exists) {
                          // Handle the case where the document does not exist
                        }
                        // Update the document
                        transaction.update(docRef, {
                          'phonenumber': phonenoController.text,
                        });
                      });

                      Get.snackbar('Success', 'Updated phone number value');
                      final otp=generateOtp(phonenoController.text);
                      print('below is otp number');
                      await setUserOtpLocally(email, otp);
                      print(otp);

                      await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: OtpScreen(email:email,otp: otp,phonenumber:phonenoController.text),
                        ),
                      );

                      setState(() {
                        isFinished = false;
                      });
                    }
                  } catch (error) {
                    print('Error updating user details: $error');
                    Get.snackbar('Error', 'Failed to update user details');
                  }
                }
              }
            }, buttonText: 'Send OTP',


          ),

        ),

      ),
    );
  }
}

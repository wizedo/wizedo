import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Widgets/colors.dart';
import '../components/my_elevatedbutton.dart';
import '../components/mPlusRoundedText.dart';
import '../components/my_text_field.dart';
import '../components/white_text.dart';
import 'OtpScreen.dart';

class PhoneNumberVerification extends StatefulWidget {
  const PhoneNumberVerification({Key? key});

  @override
  State<PhoneNumberVerification> createState() => _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  final TextEditingController _phonenoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _errors = [];
  bool _isFinished = false;

  void _addError({required String error}) {
    if (!_errors.contains(error)) {
      setState(() {
        _errors.add(error);
      });
    }
  }

  void _removeError({required String error}) {
    if (_errors.contains(error)) {
      setState(() {
        _errors.remove(error);
      });
    }
  }

  bool _validateInputs() {
    bool isValid = _errors.isEmpty;

    if (!isValid) {
      Get.rawSnackbar(message: "Please provide valid input");
    }
    return isValid;
  }

  String _generateOtp(String phoneNumber) {
    String otp = '';
    otp += phoneNumber.substring(0, 2);
    otp += '${Random().nextInt(10)}${Random().nextInt(10)}';
    return otp;
  }

  int _otpAttempts = 0; // Track the number of OTP attempts
  bool _snackbarShown = false; // Track whether the Snackbar has been shown

  void navigateToPhoneNumberVerification() {
    print("navigate to phoneverification executed");
    Get.back(); // Navigate back to PhoneNumberVerification page
    Navigator.pop(context);
    _otpAttempts=0;
  }

  void navigateBackAfterDelay() {
    print("navigate back to previouspage after 5 seconds and 3 wrong attempt");
    Future.delayed(Duration(seconds: 5), () {
      navigateToPhoneNumberVerification();
    });
  }

  void _sendOTP(String phoneNumber) async {
    try {
      final url = "http://192.168.1.105:3000/send-otp"; // Update the URL with your server address
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"phoneNumber": phoneNumber}),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(response.body);
        final receivedOTP = responseData['otp'];

        // Navigate to OTP screen with phone number and OTP
        navigateToOtpScreen(phoneNumber, receivedOTP);
      } else {
        print("Failed to send OTP request to server. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        // Handle the error accordingly
        Get.snackbar('Error', 'Failed to send OTP');
      }
      Get.snackbar('Success', 'OTP sent successfully');
    } catch (error) {
      print('Error sending OTP: $error');
      Get.snackbar('Error', 'Failed to send OTP');
    }
  }

  void navigateToOtpScreen(String phoneNumber, int receivedOTP) {
    Get.to(() => OtpScreen(
      phoneNumber: phoneNumber,
      otp: receivedOTP.toString(),
      onOtpVerified: (bool isVerified) async {
        if (isVerified) {
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final firestore = FirebaseFirestore.instance;
              final email = user.email!;
              final docRef = firestore.collection('usersDetails').doc(email);

              // Update Firebase after OTP verification
              await firestore.runTransaction((transaction) async {
                final docSnapshot = await transaction.get(docRef);
                if (!docSnapshot.exists) {
                  // Handle the case where the document does not exist
                }
                // Update the document
                transaction.update(docRef, {
                  'phonenumber': phoneNumber,
                  'verification': 'verified',
                });
              });

              Get.snackbar('Success', 'Phone number verified and updated in Firebase');
              // If verification is successful, navigate back to PhoneNumberVerification page
              navigateBackAfterDelay();
            }
          } catch (error) {
            print('Error updating user details: $error');
            Get.snackbar('Error', 'Failed to update user details');
          }
        } else {
          // If verification fails, increase OTP attempts and check if it exceeds the limit
          _otpAttempts++;
          print("otp attempts$_otpAttempts");
          if (_otpAttempts >= 3) {
            Get.snackbar('Error', 'Verification failed. Please try again later.');
            navigateBackAfterDelay(); // Navigate back after a delay
          } else {
            if (!_snackbarShown) {
              Get.snackbar('Error', 'Verification failed. Please try again.');
              _snackbarShown = true; // Set the flag to true
            }
          }
        }
      },
    ));
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: WhiteText(
                        'Enter Your Mobile Number',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: MyTextField(
                        controller: _phonenoController,
                        width: Get.width * 0.9,
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
                            _addError(error: 'Phone Number is required');
                            return 'Phone Number is required';
                          } else {
                            _removeError(error: 'Phone Number is required');
                          }
                          if (value != null && value.length < 10) {
                            _addError(error: 'Enter full 10 digit number');
                            return 'Enter full 10 digit number';
                          } else {
                            _removeError(error: 'Enter full 10 digit number');
                          }
                          if (value != null && value.length > 10) {
                            _addError(error: 'Maximum Numbers allowed is 10');
                            return 'Maximum Numbers allowed is 10';
                          } else {
                            _removeError(error: 'Maximum Numbers allowed is 10');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
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
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
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

                      // Check if the phone number already exists
                      final existingPhoneNumber = await firestore
                          .collection('usersDetails')
                          .where('phonenumber', isEqualTo: _phonenoController.text)
                          .get();

                      if (existingPhoneNumber.docs.isNotEmpty) {
                        Get.snackbar('Error', 'Phone number already exists');
                        return;
                      }

                      Get.snackbar('Success', 'Updated phone number value');

                      // Send OTP to the provided phone number
                      _sendOTP(_phonenoController.text);

                      setState(() {
                        _isFinished = false;
                      });
                    }
                  } catch (error) {
                    print('Error updating user details: $error');
                    Get.snackbar('Error', 'Failed to update user details');
                  }
                }
              }
            },
            buttonText: 'Send OTP',
          ),
        ),
      ),
    );
  }
}

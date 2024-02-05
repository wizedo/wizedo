import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/my_elevatedbutton.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:wizedo/pages/HomePage.dart';

import '../Widgets/colors.dart';
import '../components/mPlusRoundedText.dart';
import '../components/my_textbutton.dart';
import 'RegisterPage.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String otp;
  final String phonenumber;

  const OtpScreen({Key? key, required this.email, required this.otp,required this.phonenumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;
  late Timer _timer;
  int _timerSeconds = 90;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (index) => FocusNode());
    controllers = List.generate(4, (index) => TextEditingController());
    Get.snackbar('error', widget.otp);
    print('below is user stored otp ');
    printUserOtp(widget.email);
    startTimer();

    // Add listeners to controllers to check for auto-verification
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (areAllControllersFilled()) {
          verifyOtp();
        }
      });
    }
  }

  Future<String?> getUserOtpLocally(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('userOtp_$email');
    } catch (error) {
      print('Error getting user OTP locally: $error');
      return null; // Handle the error appropriately in your application
    }
  }

  Future<void> printUserOtp(String email) async {
    try {
      String? storedOtp = await getUserOtpLocally(email);

      if (storedOtp != null) {
        print('Stored OTP for $email: $storedOtp');
      } else {
        print('No stored OTP found for $email');
      }
    } catch (error) {
      print('Error printing user OTP: $error');
    }
  }

  bool areAllControllersFilled() {
    for (TextEditingController controller in controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  void verifyOtp() async {
    String enteredOtp = '';
    for (TextEditingController controller in controllers) {
      enteredOtp += controller.text;
    }

    String? storedOtp = await getUserOtpLocally(widget.email);

    if (enteredOtp == storedOtp) {
      print('OTP Verified. Navigating to Settings page.');
      Get.to(() => HomePage());
    } else {
      Get.snackbar('Error', 'Invalid OTP. Please try again.');
    }
  }

  String getFormattedTime(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      return '$minutes min $remainingSeconds sec';
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          // Stop the timer when it reaches 0
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
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
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      WhiteText('Enter the OTP sent to +91 '),
                      WhiteText(
                        widget.phonenumber,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Image.asset(
                    'lib/images/password.png',
                    width: Get.width * 0.9,
                    height: 160,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OtpEditText(focusNode: focusNodes[0], controller: controllers[0]),
                    SizedBox(width: 10),
                    OtpEditText(focusNode: focusNodes[1], controller: controllers[1]),
                    SizedBox(width: 10),
                    OtpEditText(focusNode: focusNodes[2], controller: controllers[2]),
                    SizedBox(width: 10),
                    OtpEditText(focusNode: focusNodes[3], controller: controllers[3]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WhiteText("Didn't receive OTP?", fontSize: 12),
                    MyTextButton(
                      onPressed: () {
                        Get.to(() => RegisterPage());
                      },
                      buttonText: 'Resend',
                      fontSize: 12,
                    ),
                  ],
                ),
                SizedBox(width: 8),
                WhiteText('${getFormattedTime(_timerSeconds)}', fontSize: 12),
                SizedBox(height: 100),
              ],
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
              verifyOtp(); // Call verification directly when the button is pressed
            },
            buttonText: 'Verify',
          ),
        ),
      ),
    );
  }
}

class OtpEditText extends StatefulWidget {
  const OtpEditText({Key? key, required this.focusNode, required this.controller}) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  _OtpEditTextState createState() => _OtpEditTextState();
}

class _OtpEditTextState extends State<OtpEditText> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _internalController.addListener(_onTextChanged);
  }

  _onTextChanged() {
    if (_internalController.text.isNotEmpty && !RegExp(r'^[0-9]*$').hasMatch(_internalController.text)) {
      // If the entered value is not a number, show a snackbar
      Get.snackbar('Error', 'Please enter a valid number');
      // Clear the invalid input
      _internalController.clear();
      return;
    }

    if (_internalController.text.isNotEmpty && _internalController.selection.start == 0) {
      widget.focusNode.previousFocus();
    } else if (_internalController.text.length >= 1) {
      // Move focus to the next widget when a digit is entered
      widget.focusNode.nextFocus();
    }

    // Set the controller text after handling focus changes
    widget.controller.text = _internalController.text;

    // Verify OTP if all controllers are filled
    if (_internalController.text.isNotEmpty && areAllControllersFilled()) {
      (context as Element).reassemble();
    }
  }

  bool areAllControllersFilled() {
    for (TextEditingController controller in [
      _internalController,
      widget.controller,
    ]) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextFormField(
        maxLength: 1,
        controller: _internalController,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: '*',
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}

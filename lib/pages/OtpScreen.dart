import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/colors.dart';
import '../components/mPlusRoundedText.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_textbutton.dart';
import '../components/white_text.dart';
import 'PhoneNumberVerification.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  final Function(bool)? onOtpVerified;

  const OtpScreen({Key? key, required this.phoneNumber, required this.otp, this.onOtpVerified}) : super(key: key);

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
    startTimer();
  }

  Future<String?> getUserOtpLocally(String phoneNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('userOtp_$phoneNumber');
    } catch (error) {
      print('Error getting user OTP locally: $error');
      return null;
    }
  }

  Future<void> printUserOtp(String phoneNumber) async {
    try {
      String? storedOtp = await getUserOtpLocally(phoneNumber);
      if (storedOtp != null) {
        print('Stored OTP for $phoneNumber: $storedOtp');
      } else {
        print('No stored OTP found for $phoneNumber');
      }
    } catch (error) {
      print('Error printing user OTP: $error');
    }
  }

  void verifyOtp() async {
    String enteredOtp = controllers.map((controller) => controller.text).join();

    if (enteredOtp == widget.otp) {
      print('OTP Verified. Navigating to next page.');
      widget.onOtpVerified?.call(true);
    } else {
      Get.snackbar('Error', 'Invalid OTP. Please try again.');
      widget.onOtpVerified?.call(false);
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
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
                        widget.phoneNumber,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                        (index) => OtpEditText(
                      focusNode: focusNodes[index],
                      controller: controllers[index],
                      nextFocusNode: index < 3 ? focusNodes[index + 1] : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WhiteText("Didn't receive OTP?", fontSize: 12),
                    MyTextButton(
                      onPressed: () {
                        Get.back();
                      },
                      buttonText: 'Resend',
                      fontSize: 12,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                WhiteText('${getFormattedTime(_timerSeconds)}', fontSize: 12),
                SizedBox(height: 50),
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
              verifyOtp();
            },
            buttonText: 'Verify',
          ),
        ),
      ),
    );
  }
}

class OtpEditText extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final FocusNode? nextFocusNode;

  const OtpEditText({Key? key, this.focusNode, this.controller, this.nextFocusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextFormField(
        maxLength: 1,
        controller: controller,
        focusNode: focusNode,
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
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}

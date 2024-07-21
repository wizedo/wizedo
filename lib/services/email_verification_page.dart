import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:get/get.dart';
import '../components/debugcusprint.dart';
import '../components/white_text.dart';
import '../pages/LoginPage.dart';
import '../pages/UserDetailsPage.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  const EmailVerificationScreen({super.key, required this.userEmail, required this.userPassword});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  int _elapsedSeconds = 90;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _sendEmailVerification();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (timer) {
        setState(() {
          _elapsedSeconds--;
          if (_elapsedSeconds <= 0) {
            // If not verified within one minute, delete the user account
            _deleteUserAccount();
          } else {
            // Check email verification status every second
            _checkEmailVerification();
          }
        });
      },
    );
  }

  Future<void> _sendEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      }
    } catch (error) {
      debugLog('Error sending email verification: $error');
    }
  }

  Future<void> _deleteUserAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        Get.offAll(const LoginPage());
        Get.showSnackbar(
          const GetSnackBar(
            borderRadius: 8,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            animationDuration: Duration(milliseconds: 800),
            duration: Duration(milliseconds: 3000),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            snackPosition: SnackPosition.TOP,
            isDismissible: true,
            backgroundColor: Color(0xFF955AF2),
            // Set your desired color here
            titleText: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                WhiteText(
                  'Account Creation Failed',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            messageText: WhiteText(
              'Email verification failed. Please try registering again.',
              fontSize: 12,
            ),
          ),
        );
      }
    } catch (error) {
      debugLog('Error deleting user account: $error');
    }
  }

  Future<void> _checkEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
        // Set emailVerified to true in Firestore
        await FirebaseFirestore.instance
            .collection('usersDetails')
            .doc(widget.userEmail)
            .update({'emailVerified': 'yes'});

        _timer?.cancel();
        setState(() {
          _isEmailVerified = true;
        });
        Get.to(() => UserDetails(userEmail: widget.userEmail));
        Get.showSnackbar(
          const GetSnackBar(
            borderRadius: 8,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            animationDuration: Duration(milliseconds: 800),
            duration: Duration(milliseconds: 3000),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            snackPosition: SnackPosition.TOP,
            isDismissible: true,
            backgroundColor: Color(0xFF955AF2),
            // Set your desired color here
            titleText: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                WhiteText(
                  'Email Verified',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            messageText: WhiteText(
              'Your email has been verified successfully.',
              fontSize: 12,
            ),
          ),
        );
      }
    } catch (error) {
      debugLog('Error checking email verification: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Intercept back button press
        await _deleteUserAccount(); // Delete user account when navigating back to registration page
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email Verification'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50,left: 8 ,right: 8),
            child: Column(
              children: <Widget>[
                // Countdown Timer
                Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF955AF2),
                  ),
                  child: Center(
                    child: Text(
                      '$_elapsedSeconds',
                      style: const TextStyle(
                        fontFamily: 'MPlusRounded1c',
                        fontSize: 60, // Adjust font size as needed
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'MPlusRounded1c',
                      fontSize: 16, // Adjust font size as needed
                      color: Colors.black, // Set text color to black
                    ),
                    children: [
                      const TextSpan(
                        text: 'An email has been sent to ',
                      ),
                      TextSpan(
                        text: widget.userEmail,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Make userEmail extra bold
                        ),
                      ),
                      const TextSpan(
                        text: ' for verification.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Please verify your email within 1 minute.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'MPlusRounded1c'),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _checkEmailVerification();
                  },
                  child: const Text('Check Email Verification'),
                ),
                const SizedBox(height: 20),
                if (_isEmailVerified)
                  const Text(
                    'Email verified successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontFamily: 'MPlusRounded1c'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

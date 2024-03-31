import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:get/get.dart';
import '../pages/LoginPage.dart';
import '../pages/UserDetailsPage.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  const EmailVerificationScreen({Key? key, required this.userEmail, required this.userPassword}) : super(key: key);

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
      print('Error sending email verification: $error');
    }
  }

  Future<void> _deleteUserAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        Get.offAll(LoginPage());
        Get.snackbar(
          'Account Creation Failed',
          'Email verification failed. Please try registering again.',
        );
      }
    } catch (error) {
      print('Error deleting user account: $error');
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
        Get.snackbar('Email Verified', 'Your email has been verified successfully.');
      }
    } catch (error) {
      print('Error checking email verification: $error');
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
          title: Text('Email Verification'),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF955AF2),
                  ),
                  child: Center(
                    child: Text(
                      '$_elapsedSeconds',
                      style: TextStyle(
                        fontFamily: 'MPlusRounded1c',
                        fontSize: 60, // Adjust font size as needed
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'MPlusRounded1c',
                      fontSize: 16, // Adjust font size as needed
                      color: Colors.black, // Set text color to black
                    ),
                    children: [
                      TextSpan(
                        text: 'An email has been sent to ',
                      ),
                      TextSpan(
                        text: widget.userEmail,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make userEmail extra bold
                        ),
                      ),
                      TextSpan(
                        text: ' for verification.',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  'Please verify your email within 1 minute.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'MPlusRounded1c'),
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _checkEmailVerification();
                  },
                  child: Text('Check Email Verification'),
                ),
                SizedBox(height: 20),
                if (_isEmailVerified)
                  Text(
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

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/LoginPage.dart';
import '../pages/UserDetailsPage.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword; // Make password optional
  // Remove userConfirmPassword since it's no longer needed

  const EmailVerificationScreen({
    Key? key,
    required this.userEmail,
    this.userPassword = '', // Provide a default value for userPassword
  }) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  int countdown = 30; // Countdown duration in seconds
  //instance of auth
  FirebaseAuth _auth=FirebaseAuth.instance;  //creaing instance for easier use through _auth
  //instance of firestore
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final fireStore=FirebaseFirestore.instance.collection('users').snapshots();
  //collection for firstore
  CollectionReference ref=FirebaseFirestore.instance.collection('usersDetails');



  @override
  void initState() {
    super.initState();
    createAccountAndSendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateCountdown());
  }

  createAccountAndSendEmailVerification() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.userEmail,
        password: widget.userPassword,
      );
      // Send email verification
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } catch (e) {
      // print(e);
      debugPrint('$e');
      // Handle error creating account or sending verification email
      // If an error occurs, delete the created user account
      await FirebaseAuth.instance.currentUser?.delete();
      // Check if the error message indicates that the user is already registered
      if (e.toString().contains('email-already-in-use')) {
        // Show a Snackbar indicating that the user is already registered
        Get.snackbar('Invalid', 'User is already registered. Click below to login Now.');
        Get.to(() => LoginPage());
      } else {
        // Show a generic error Snackbar
        Get.snackbar('Error', 'Registration failed. Please try again later.');
      }
      // Optionally, navigate back to the login page or display an error message
    }
  }

  updateCountdown() {
    checkEmailVerified();
    if (countdown > 0) {
      setState(() {
        countdown--;
      });
    } else {
      // Countdown reached, delete the user and perform any additional actions
      deleteAndNavigate();
    }
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      await _firestore.collection('users').doc(widget.userEmail).set({
        'uid': _auth.currentUser!.uid,
        'email': widget.userEmail,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      // Creating a collection
      final fireStore = FirebaseFirestore.instance.collection('usersDetails');
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        await fireStore.doc(email).set({
          'id': email,
          'userDetailsfilled': false,
        }).then((value) {
          Get.snackbar('Success', 'Updated successfully');
        });
      }
      // Redirect to UserDetailsPage after email is verified
      Get.to(() => UserDetails(userEmail: widget.userEmail));
      timer?.cancel();
    }
  }


  deleteAndNavigate() async {
    await FirebaseAuth.instance.currentUser?.delete();
    // Optionally, navigate back to the login page or display an error message
    Get.to(() => LoginPage());
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Check your \n Email',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you an Email on  ${widget.userEmail}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Verifying email....',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  child: const Text('Resend'),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Resend in $countdown seconds',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
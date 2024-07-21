import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wizedo/components/BlackText.dart';
import 'package:wizedo/components/my_elevatedbutton.dart';
import 'dart:math';

import '../components/my_textmultiline_field.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionText = TextEditingController();
  List<String> errors = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: BlackText('Feedback Form', fontSize: 18)),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyTextMulitilineField(
                        controller: _descriptionText,
                        hint: 'Enter your feedback here',
                        obscureText: false,
                        width: Get.width * 0.9,
                        hintTextColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.black,
                        height: Get.height * 0.4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            addError(error: 'Description is required');
                            return 'Description is required';
                          } else {
                            removeError(error: 'Description is required');
                          }

                          // Check for leading spaces
                          if (value.startsWith(' ')) {
                            addError(error: 'Leading spaces at the beginning are not allowed in description');
                            return 'Leading spaces at the beginning are not allowed in description';
                          } else {
                            removeError(error: 'Leading spaces at the beginning are not allowed in description');
                          }

                          // Check for trailing spaces
                          if (value.endsWith(' ')) {
                            addError(error: 'Spaces at the end are not allowed in description');
                            return 'Spaces at the end are not allowed in description';
                          } else {
                            removeError(error: 'Spaces at the end are not allowed in description');
                          }

                          // Check for consecutive spaces
                          if (value.contains(RegExp(r'\s{2,}'))) {
                            addError(error: 'Consecutive spaces are not allowed in description');
                            return 'Consecutive spaces are not allowed in description';
                          } else {
                            removeError(error: 'Consecutive spaces are not allowed in description');
                          }

                          if (value.replaceAll(RegExp(r'\s'), '').length < 20) {
                            addError(error: 'Description should be of at least 10 words');
                            return 'Description should be of at least 10 words';
                          } else {
                            removeError(error: 'Description should be of at least 10 words');
                          }
                          if (value.replaceAll(RegExp(r'\s'), '').length > 250) {
                            addError(error: 'Maximum characters allowed in description is 250');
                            return 'Maximum characters allowed in description is 250';
                          } else {
                            removeError(error: 'Maximum characters allowed in description is 250');
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: MyElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool isValid = _validateInputs();
                        if (isValid) {
                          // Get current user's email
                          String? userEmail = FirebaseAuth.instance.currentUser?.email;
                          if (userEmail != null) {
                            // Generate a random unique ID using current timestamp and user email
                            String docId = '${userEmail}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';

                            // Write data to Firestore with the generated document ID
                            await FirebaseFirestore.instance.collection('feedback').doc(docId).set({
                              'feedback': _descriptionText.text,
                              'timestamp': FieldValue.serverTimestamp(),
                            }).then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Feedback submitted successfully')),
                              );
                              _descriptionText.clear();
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to submit feedback')),
                              );
                            });
                          }
                        }
                      }
                    },
                    buttonText: 'Submit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    bool isValid = true; // Start assuming inputs are valid

    // Check for Description
    if (_descriptionText.text.isEmpty) {
      addError(error: 'Description is required');
      if (isValid) {
        Get.rawSnackbar(message: "Description is required");
      }
      isValid = false;
    } else if (_descriptionText.text.startsWith(' ')) {
      addError(error: 'Leading spaces at the beginning are not allowed in description');
      if (isValid) {
        Get.rawSnackbar(message: "Leading spaces at the beginning are not allowed in description");
      }
      isValid = false;
    } else if (_descriptionText.text.endsWith(' ')) {
      addError(error: 'Spaces at the end are not allowed in description');
      if (isValid) {
        Get.rawSnackbar(message: "Spaces at the end are not allowed in description");
      }
      isValid = false;
    } else if (_descriptionText.text.contains(RegExp(r'\s{2,}'))) {
      addError(error: 'Consecutive spaces are not allowed in description');
      if (isValid) {
        Get.rawSnackbar(message: "Consecutive spaces are not allowed in description");
      }
      isValid = false;
    } else if (_descriptionText.text.replaceAll(RegExp(r'\s'), '').length < 20) {
      addError(error: 'Description should be of at least 10 words');
      if (isValid) {
        Get.rawSnackbar(message: "Description should be of at least 10 words");
      }
      isValid = false;
    } else if (_descriptionText.text.replaceAll(RegExp(r'\s'), '').length > 250) {
      addError(error: 'Maximum characters allowed in description is 250');
      if (isValid) {
        Get.rawSnackbar(message: "Maximum characters allowed in description is 250");
      }
      isValid = false;
    } else {
      removeError(error: 'Description is required');
      removeError(error: 'Leading spaces at the beginning are not allowed in description');
      removeError(error: 'Spaces at the end are not allowed in description');
      removeError(error: 'Consecutive spaces are not allowed in description');
      removeError(error: 'Description should be of at least 10 words');
      removeError(error: 'Maximum characters allowed in description is 250');
    }
    return isValid;
  }

  @override
  void dispose() {
    _descriptionText.dispose();
    super.dispose();
  }
}

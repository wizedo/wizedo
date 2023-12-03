import 'dart:io';
import 'dart:math';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:intl/intl.dart';
import 'package:wizedo/components/YearPickerTextField.dart';
import 'package:wizedo/components/datePickerTextField.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import 'package:wizedo/components/my_text_field.dart';

import '../components/MyUploadButton.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_post_text_field.dart';
import '../components/my_textmultiline_field.dart';
import 'BottomNavigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isFinished = false;
  bool _sliderValue = false;
  final TextEditingController _projectName = TextEditingController();
  final TextEditingController _numberOfPages = TextEditingController();
  final TextEditingController _descriptionText = TextEditingController();
  final TextEditingController _pdf = TextEditingController();
  final TextEditingController _datePicker = TextEditingController();
  final TextEditingController _paymentDetails = TextEditingController();
  String? _selectedCategory; // Change the type to String?
  bool _isNumberOfPagesVisible = false;
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? buttonText;

  Future<firebase_storage.UploadTask?> uploadFile(File file, User? user) async {
    if (file == null) {
      Get.snackbar('Error', 'Unable to Upload');
      print('No file was picked');
      return null;
    }

    try {
      firebase_storage.UploadTask uploadTask;

      // Generate a unique filename using timestamp, random identifier, and user UID
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String randomIdentifier = Random().nextInt(10000).toString();
      String fileName = 'file_${user?.uid ?? 'unknown'}_$timestamp$randomIdentifier.pdf';

      // Create a Reference to the file with the generated filename
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Reference Files')
          .child(fileName);

      final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path},
      );

      print("Uploading..!");
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
      print("done..!");

      return Future.value(uploadTask);
    } catch (error) {
      print('Error uploading file: $error');
      Get.snackbar('Error', 'Failed to upload file');
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Post',
          style: mPlusRoundedText.copyWith(fontSize: 33),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category:',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 51,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFF39304D), // Adjust the color as needed
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      hint: Row(
                        children: [
                          Text(
                            _selectedCategory != null ? _selectedCategory! : 'Select Your Category',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      value: _selectedCategory,
                      items: ['Assignment', 'Personal Development', 'College Project']
                          .map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: _selectedCategory == item ? Color(0xFFdacfe6) : Colors.black,
                              fontSize: 12
                            ),
                          ),
                        );
                      })
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value;
                          _isNumberOfPagesVisible =
                              _selectedCategory == 'Assignment';
                        });
                        print('Selected item: $value');
                      },
                      validator: (value) {
                        if (value == null) {
                          addError(error: 'Please select your category');
                        } else {
                          removeError(error: 'Please select your category');
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Project Name:',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: MyPostTextField(
                      controller: _projectName,
                      obscureText: false,
                      hint: 'Name',
                      keyboardType: TextInputType.name,
                      fontSize: 12,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          addError(error: 'Project Name is required');
                          return 'Project Name is required';
                        } else {
                          removeError(error: 'Project Name is required');
                        }
                        if (value != null && value.length < 10) {
                          addError(error: 'Project Name should be of at least 10 characters');
                          return 'Project Name should be of at least 10 characters';
                        } else {
                          removeError(error: 'Project Name should be of at least 10 characters');
                        }
                        if (value != null && value.length > 25) {
                          addError(error: 'Maximum characters allowed is 25');
                          return 'Maximum characters allowed is 25';
                        } else {
                          removeError(error: 'Maximum characters allowed is 15');
                        }
                        if (value != null && RegExp(r'[0-9]').hasMatch(value)) {
                          addError(error: 'Should not contain numbers');
                          return 'Should not contain numbers';
                        } else {
                          removeError(error: 'Should not contain numbers');
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: MyTextMulitilineField(
                      controller: _descriptionText,
                      obscureText: false,
                      hint: 'Description (max 150 words)',
                      keyboardType: TextInputType.name,
                      height: 185,
                      width: 400,
                      fontSize: 12,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          addError(error: 'Description is required');
                          return 'Description is required';
                        } else {
                          removeError(error: 'Description is required');
                        }
                        if (value != null && value.length < 100) {
                          addError(error: 'Description should be of at least 100 characters');
                          return 'Description should be of at least 100 characters';
                        } else {
                          removeError(error: 'Description should be of at least 100 characters');
                        }
                        if (value != null && value.length > 250 ) {
                          addError(error: 'Maximum characters allowed is 250');
                          return 'Maximum characters allowed is 250';
                        } else {
                          removeError(error: 'Maximum characters allowed is 250');
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),

                  if (_isNumberOfPagesVisible)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total/Approx pages requiring assistance:',
                          style: mPlusRoundedText.copyWith(fontSize: 12),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 400,
                          child: MyPostTextField(
                            controller: _numberOfPages,
                            obscureText: false,
                            hint: 'Number of pages',
                            keyboardType: TextInputType.number,
                            fontSize: 12,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.info,color: Colors.deepPurple,),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  Text(
                    'Due Date: ',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Row(
                      children: [
                        DateSelector(
                          controller: _datePicker,
                          hint: 'Select Date (yyyy-mm-dd)',
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: Color(0xFF955AF2),
                          ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                addError(error: 'Due date is required');
                                return 'Due date is required';
                              } else {
                                removeError(error: 'Due date is required');
                              }
                              return null;
                            },
                        )
                      ],
                    ),
                  ),
                  //lib/images/pdf.png
                  SizedBox(height: 10),
                  Text(
                    'Upload a reference file: ',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  MyUploadButton(
                    onPressed: () async {
                      final path = await FlutterDocumentPicker.openDocument();
                      if (path != null && path.isNotEmpty) {
                        print(path);
                        // Do not upload the file here; just update the _pdf controller
                        setState(() {
                          _pdf.text = path;
                          String fileName = path.split('/').last;
                          if (fileName.length > 30) {
                            fileName = fileName.substring(0, 30) + '...pdf'; // Truncate the file name
                          }
                          buttonText = fileName;
                        });
                      } else {
                        Get.snackbar('Error', 'No file selected');
                      }
                    },
                    suffixIcon: Icon(Icons.upload, color: Color(0xFF955AF2)),
                    buttonText: buttonText ?? 'Upload a pdf',
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Your offer:',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: MyPostTextField(
                      prefixIcon: Icon(Icons.currency_rupee_rounded, color: Colors.yellow),
                      fontSize: 12,
                      controller: _paymentDetails,
                      obscureText: false,
                      hint: 'Amount you are ready to pay',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          addError(error: 'Expected pay is required');
                          return 'Expected pay is required';
                        } else {
                          removeError(error: 'Expected pay is required');
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],

              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
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

                    // Generate a unique postId
                    String postId = firestore.collection('posts').doc().id;

                    // Upload the file only if a file is selected
                    firebase_storage.UploadTask? uploadTask;
                    if (_pdf.text.isNotEmpty) {
                      File file = File(_pdf.text);
                      uploadTask = await uploadFile(file, user);
                    }

                    // Use a transaction for the Firestore write operations
                    await firestore.runTransaction((transaction) async {
                      // Retrieve the post reference
                      final postRef = firestore.collection('posts').doc(postId);

                      // Read the post to ensure its existence
                      final postSnapshot = await transaction.get(postRef);
                      if (postSnapshot.exists) {
                        throw Exception('Post already exists'); // Or handle it appropriately
                      }

                      // Write the post data
                      transaction.set(postRef, {
                        'userId': user.uid,
                        'emailid': email,
                        'category': _selectedCategory,
                        'subCategory': _projectName.text,
                        'description': _descriptionText.text,
                        'pages': _numberOfPages.text,
                        'dueDate': DateFormat('yyyy-MM-dd').format(_selectedDate),
                        // 'referencePDF': 'URL_TO_PDF', // Replace with the actual URL or path
                        'totalPayment': int.tryParse(_paymentDetails.text) ?? 0,
                        'status': 'Pending',
                      });
                    });

                    Get.snackbar('Success', 'Post created successfully');

                    // Redirect to the desired screen, e.g., BottomNavigation
                    await Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: BottomNavigation(),
                      ),
                    );

                    setState(() {
                      isFinished = false;
                    });
                  }
                } catch (error) {
                  print('Error creating post: $error');
                  Get.snackbar('Error', 'Failed to create post');
                }
              }
            }
          },
          buttonText: 'Get Answers Now',
          fontWeight: FontWeight.bold,
        ),

      ),
    );
  }

  bool _validateInputs() {
    bool isValid = errors.isEmpty;

    if (!isValid) {
      Get.rawSnackbar(message: "Please Give a valid INPUT");
    }
    return isValid;
  }
}

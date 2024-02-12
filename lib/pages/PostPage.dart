import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:intl/intl.dart';
import 'package:wizedo/components/datePickerTextField.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
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
  final TextEditingController _datePicker = TextEditingController();
  final TextEditingController _paymentDetails = TextEditingController();
  final TextEditingController _googledrivefilelink=TextEditingController();
  String? _selectedCategory; // Change the type to String?
  bool _isNumberOfPagesVisible = false;
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? buttonText;



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


  Future<String?> getSelectedCollegeLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('selectedCollege');
    } catch (error) {
      print('Error getting selected college locally: $error');
      return null;
    }
  }

  bool isGoogleDriveLink(String link) {
    // Updated Google Drive link format
    RegExp regex = RegExp(r'^https:\/\/drive\.google\.com\/(file\/d\/|open\?id=)([a-zA-Z0-9_-]+)\/?.*');
    return regex.hasMatch(link);
  }





  @override
  void dispose() {
    print("controllers diposed");
    // Clean up controllers when the state is removed
    _projectName.dispose();
    _numberOfPages.dispose();
    _descriptionText.dispose();
    _datePicker.dispose();
    _paymentDetails.dispose();
    _googledrivefilelink.dispose();
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
          'Post',
          style: mPlusRoundedText.copyWith(fontSize: 24),
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
                        // Check for leading spaces
                        if (value != null && value.startsWith(' ')) {
                          addError(error: 'Leading spaces at the beginning are not allowed');
                          return 'Leading spaces at the beginning are not allowed';
                        } else {
                          removeError(error: 'Leading spaces at the beginning are not allowed');
                        }
                        // Check for trailing spaces
                        if (value != null && value.endsWith(' ')) {
                          addError(error: 'Spaces at the end are not allowed');
                          return 'Spaces at the end are not allowed';
                        } else {
                          removeError(error: 'Spaces at the end are not allowed');
                        }
                        // Check for consecutive spaces
                        if (value != null && value.contains(RegExp(r'\s{2,}'))) {
                          addError(error: 'Consecutive spaces are not allowed');
                          return 'Consecutive spaces within the text are not allowed';
                        } else {
                          removeError(error: 'Consecutive spaces are not allowed');
                        }
                        if (value != null && value.replaceAll(RegExp(r'\s'), '').length < 10) {
                          addError(error: 'Project Name should be of at least 10 characters');
                          return 'Project Name should be of at least 10 characters';
                        } else {
                          removeError(error: 'Project Name should be of at least 10 characters');
                        }
                        if (value != null && value.replaceAll(RegExp(r'\s'), '').length > 24) {
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

                          // Check for leading spaces
                          if (value != null && value.startsWith(' ')) {
                            addError(error: 'Leading spaces at the beginning are not allowed');
                            return 'Leading spaces at the beginning are not allowed';
                          } else {
                            removeError(error: 'Leading spaces at the beginning are not allowed');
                          }

                          // Check for trailing spaces
                          if (value != null && value.endsWith(' ')) {
                            addError(error: 'Spaces at the end are not allowed');
                            return 'Spaces at the end are not allowed';
                          } else {
                            removeError(error: 'Spaces at the end are not allowed');
                          }

                          // Check for consecutive spaces
                          if (value != null && value.contains(RegExp(r'\s{2,}'))) {
                            addError(error: 'Consecutive spaces are not allowed');
                            return 'Consecutive spaces within the text are not allowed';
                          } else {
                            removeError(error: 'Consecutive spaces are not allowed');
                          }

                          if (value != null && value.replaceAll(RegExp(r'\s'), '').length < 100) {
                            addError(error: 'Description should be of at least 20 words');
                            return 'Description should be of at least 20 words';
                          } else {
                            removeError(error: 'Description should be of at least 20 words');
                          }
                          if (value != null && value.replaceAll(RegExp(r'\s'), '').length > 250) {
                            addError(error: 'Maximum characters allowed is 250');
                            return 'Maximum characters allowed is 250';
                          } else {
                            removeError(error: 'Maximum characters allowed is 250');
                          }

                          // Rest of your validation logic...

                          return null;
                        },
                      )


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
                              onPressed: () {

                              },
                            ),
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                addError(error: 'Number of pages is required');
                                return 'Number of pages is required';
                              } else {
                                removeError(error: 'Number of pages is required');
                              }
                            },
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
                        Expanded(
                          child: DateSelector(
                            width: Get.width * 0.85,
                            controller: _datePicker,
                            hint: 'Select Date (yyyy-mm-dd)',
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Color(0xFF955AF2),
                              size: 20,
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
                          ),
                        )
                      ],
                    ),
                  ),
                  //lib/images/pdf.png
                  SizedBox(height: 10),
                  Text(
                    'Upload a reference file link: ',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: MyPostTextField(
                      prefixIcon: Icon(Icons.link, color: Colors.red),
                      fontSize: 12,
                      controller: _googledrivefilelink,
                      obscureText: false,
                      hint: 'Google Drive Link',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          addError(error: 'Google Drive link is required');
                          return 'Google Drive link is required';
                        } else {
                          removeError(error: 'Google Drive link is required');
                        }

                        // Check if the entered link is a valid Google Drive link
                        if (!isGoogleDriveLink(value)) {
                          addError(error: 'Invalid Google Drive link');
                          return 'Invalid Google Drive link';
                        } else {
                          removeError(error: 'Invalid Google Drive link');
                        }

                        // Check if the link is too long
                        if (value.length > 200) {
                          addError(error: 'Google Drive link is too long');
                          return 'Google Drive link is too long';
                        } else {
                          removeError(error: 'Google Drive link is too long');
                        }

                        return null;
                      },
                    ),
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
                      print('User email: $email');

                      String? userCollege = await getSelectedCollegeLocally();
                      String userCollegee = userCollege ?? 'null set manually2';
                      print(userCollegee);


                      // If college name is not available locally, fetch it from Firestore
                      if (userCollege == null) {
                        final userDoc = await firestore.collection('usersDetails').doc(email).get();
                        if (userDoc.exists) {
                          userCollegee = userDoc['college'] ?? 'Unknown College';
                          print('User college from Firestore: $userCollegee');
                        }
                      }

                      // Generate a unique postId using date, time, and user email
                      String postId = '${DateTime.now().millisecondsSinceEpoch}_${user.email.hashCode}';

                      if (userCollege == null) {
                        final userDoc = await firestore.collection('usersDetails').doc(email).get();
                        if (userDoc.exists) {
                          userCollegee = userDoc['college'] ?? 'Unknown College';
                          print('User college from Firestore: $userCollegee');
                        }
                      }








                      // Use a transaction for the Firestore write operations
                      await firestore.runTransaction((transaction) async {
                        // Optionally, add the post to a subcollection under the college document
                        final collegePostRef = firestore
                            .collection('colleges')
                            .doc(userCollegee)
                            .collection('collegePosts')
                            .doc(postId);
                        transaction.set(collegePostRef, {
                          'postId': postId,
                          'postId':postId,
                          'googledrivelink':_googledrivefilelink.text,
                          'pstatus':1,
                          'userId': user.uid,
                          'emailid': email,
                          'collegeName': userCollegee, // Add the college name to the post
                          'category': _selectedCategory,
                          'subCategory': _projectName.text.isNotEmpty
                              ? _projectName.text[0].toUpperCase() + _projectName.text.substring(1)
                              : _projectName.text,
                          'description': _descriptionText.text.isNotEmpty
                              ? _descriptionText.text[0].toUpperCase() + _descriptionText.text.substring(1)
                              : _descriptionText.text,
                          'pages': _numberOfPages.text,
                          'dueDate': DateFormat('yyyy-MM-dd').format(_selectedDate),
                          'totalPayment': int.tryParse(_paymentDetails.text) ?? 0,
                          'status': 'active', // active or rejected or applied
                          'createdAt': FieldValue.serverTimestamp(),
                          'college':userCollegee
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
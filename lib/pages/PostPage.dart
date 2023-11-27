import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:intl/intl.dart';
import 'package:wizedo/components/YearPickerTextField.dart';
import 'package:wizedo/components/datePickerTextField.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:wizedo/components/searchable_dropdown.dart';
import 'package:wizedo/components/white_text.dart';

import '../components/boxDecoration.dart';
import '../components/my_elevatedbutton.dart';
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
  final TextEditingController _descriptionText = TextEditingController();
  final TextEditingController _datePicker = TextEditingController();
  final TextEditingController _paymentDetails = TextEditingController();
  String? _selectedCategory; // Change the type to String?
  bool _isNumberOfPagesVisible = false;
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];

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
                    width: 310,
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
                              _selectedCategory == 'Assignment' || _selectedCategory == 'College Project';
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
                    child: MyTextField(
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
                          child: MyTextField(
                            controller: _descriptionText,
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
                            color: Colors.deepPurple,
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
                  SizedBox(height: 10),
                  Text(
                    'Upload a reference file: ',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 310,
                    decoration: boxDecoration,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('lib/images/pdf.png', width: 30),
                        SizedBox(width: 10),
                        WhiteText('Upload a file',
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Pay:',
                    style: mPlusRoundedText.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: MyTextField(
                      prefixIcon: Icon(Icons.currency_rupee_rounded, color: Colors.yellow),
                      fontSize: 12,
                      controller: _paymentDetails,
                      obscureText: false,
                      hint: 'Enter Expected pay',
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
          onPressed: () {
            // Handle button press
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

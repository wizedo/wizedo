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
                      height: 120,
                      width: 400,
                      fontSize: 12,
                    ),
                  ),
                  if (_isNumberOfPagesVisible)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Total/Approx pages requiring assistance',
                          style: mPlusRoundedText.copyWith(fontSize: 12),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 400,
                          child: MyTextField(
                            controller: _descriptionText,
                            obscureText: false,
                            hint: 'Number of pages',
                            keyboardType: TextInputType.name,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.info, color: Colors.blue),
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
                      fontSize: 12,
                      controller: _paymentDetails,
                      obscureText: false,
                      hint: 'Enter Expected pay',
                      keyboardType: TextInputType.number,
                      suffixIcon: Icon(Icons.attach_money, color: Colors.yellow),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                      width: double.infinity,
                      height: 51,
                      child: SwipeableButtonView(
                        onFinish: () async {
                          if(_formKey.currentState!.validate() && _validateInputs()){
                            _formKey.currentState!.save();
                            print("updated post detials");

                          }
                          await Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: BottomNavigation()));

                          setState(() {
                            isFinished = false;
                          });
                        },
                        isFinished: isFinished,
                        onWaitingProcess: () {
                          Future.delayed(Duration(seconds: 0), () {
                            setState(() {
                              isFinished = true;
                            });
                          });
                        },
                        activeColor: Color(0xFF955AF2),
                        buttonWidget: Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        buttonText: 'Swipe to Join',
                        borderRadius: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],

              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: 60,
          //     decoration: BoxDecoration(
          //       color: Colors.grey,
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: Center(
          //       child: Text(
          //         'Ad',
          //         style: TextStyle(color: Colors.grey.shade50, fontSize: 12),
          //       ),
          //     ),
          //   ),
          // ),
        ],
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

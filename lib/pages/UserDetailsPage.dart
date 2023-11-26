import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:wizedo/components/YearPickerTextField.dart';
import 'package:wizedo/components/colors/sixty.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/CollegeData.dart';
import 'LoginPage.dart';
import 'BottomNavigation.dart';

class UserDetails extends StatefulWidget {
  final String userEmail;

  const UserDetails({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  List<String> errors = [];
  List<String> collegeItems = [];
  String? _selectedState;
  String? _selectedCollege;
  String? _selectedCourse;
  bool isFinished = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _universityNameController = TextEditingController();
  final TextEditingController unameController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();
  final TextEditingController userYearController = TextEditingController();
  bool _sliderValue = false;
  final _formKey = GlobalKey<FormState>();

  String hexColor = '#211b2e';

  Future<void> setUserDetailsFilledLocally(bool value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('userDetailsFilled', value);
    } catch (error) {
      print('Error setting user details locally: $error');
    }
  }

  Future<bool> getUserDetailsFilledLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool userDetailsFilledLocally = prefs.getBool('userDetailsFilled') ?? false;
      return userDetailsFilledLocally;
    } catch (error) {
      print('Error getting user details locally: $error');
      return false;
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
    Color backgroundColor = ColorUtil.hexToColor(hexColor);
    String email = widget.userEmail;
    print('User email in UserDetails: ${widget.userEmail}');
    return Scaffold(
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/images/userdetails.png',
                    width: 300,
                    height: 150,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: WhiteText(
                      "Let's Get To Know You!",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    controller: unameController,
                    label: 'Your Name',
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    textColor: Color(0xFFdacfe6),
                    prefixIcon: Image.asset(
                      'lib/images/uname.png',
                      color: Colors.white,
                    ),
                    fontSize: 12,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        addError(error: 'Name is required');
                        return 'Name is required';
                      } else {
                        removeError(error: 'Name is required');
                      }
                      if (value != null && value.length < 5) {
                        addError(error: 'Name should be at least 5 characters');
                        return 'Name should be at least 5 characters';
                      } else {
                        removeError(error: 'Name should be at least 5 characters');
                      }
                      if (value != null && value.length > 27) {
                        addError(error: 'Maximum characters allowed is 27');
                        return 'Maximum characters allowed is 27';
                      } else {
                        removeError(error: 'Maximum characters allowed is 30');
                      }
                      if (value != null && RegExp(r'[0-9]').hasMatch(value)) {
                        addError(error: 'Name should not contain numbers');
                        return 'Name should not contain numbers';
                      } else {
                        removeError(error: 'Name should not contain numbers');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 15),
                  MyTextField(
                    controller: phonenoController,
                    label: 'Phone Number',
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    textColor: Color(0xFFdacfe6),
                    prefixIcon: Center(
                      child: Text(
                        '+91',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    fontSize: 12,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        addError(error: 'Phone Number is required');
                        return 'Phone Number is required';
                      } else {
                        removeError(error: 'Phone Number is required');
                      }
                      if (value != null && value.length < 10) {
                        addError(error: 'Enter full 10 digit number');
                        return 'Enter full 10 digit number';
                      } else {
                        removeError(error: 'Enter full 10 digit number');
                      }
                      if (value != null && value.length > 10) {
                        addError(error: 'Maximum Numbers allowed is 10');
                        return 'Maximum Numbers allowed is 10';
                      } else {
                        removeError(error: 'Maximum Numbers allowed is 10');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),


                  // DropdownButton2 for state
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 7),
                        child: WhiteText(
                          'Current State',
                          fontSize: 10,
                        ),
                      ),
                      Container(
                        width: 310,
                        height: 51,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFF39304D), // Adjust the color as needed
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15),
                            ),
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  _selectedState != null ? _selectedState! : 'Select Your State',
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                            value: _selectedState,
                            items: CollegeData.collegeData.keys.toList().map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _selectedState == item ? Color(0xFFdacfe6) : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedState = value;
                                collegeItems = CollegeData.getCollegesByState(_selectedState!);
                                _selectedCollege = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // DropdownButton2 for college
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 7),
                        child: WhiteText(
                          'College',
                          fontSize: 10,
                        ),
                      ),
                      Container(
                        width: 310,
                        height: 51,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFF39304D), // Adjust the color as needed
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.white,
                              ),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Icon(
                                      Icons.school_rounded,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Select Your College',
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                ),
                                value: _selectedCollege,
                                items: collegeItems
                                    .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedCollege == item ? Color(0xFFdacfe6) : Colors.black,
                                    ),
                                  ),
                                ))
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedCollege = value;
                                  });
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),



                  SizedBox(height: 10),

                  // DropdownButton2 for course
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 7),
                        child: WhiteText(
                          'Course',
                          fontSize: 10,
                        ),
                      ),
                      Container(
                        width: 310,
                        height: 51,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFF39304D), // Adjust the color as needed
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.book,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Select Your Course',
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                            value: _selectedCourse,
                            items: [
                              'Bachelor of Arts (BA)',
                              'Bachelor of Science (BSc)',
                              'Bachelor of Commerce (BCom)',
                              'Bachelor of Technology (BTech)',
                              'Bachelor of Business Administration (BBA)',
                              'Bachelor of Computer Applications (BCA)',
                              'Bachelor of Education (BEd)',
                              'Bachelor of Medicine, Bachelor of Surgery (MBBS)',
                              'Bachelor of Dental Surgery (BDS)',
                              'Bachelor of Pharmacy (BPharm)',
                              'Bachelor of Law (LLB)',
                              'Master of Arts (MA)',
                              'Master of Science (MSc)',
                              'Master of Commerce (MCom)',
                              'Master of Technology (MTech)',
                              'Master of Business Administration (MBA)',
                              'Master of Computer Applications (MCA)',
                              'Master of Social Work (MSW)',
                              'Master of Education (MEd)',
                              'Doctor of Philosophy (PhD)',
                              'Chartered Accountancy (CA)',
                              'Company Secretary (CS)',
                              'Cost and Management Accountancy (CMA)',
                            ].map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _selectedCourse == item ? Color(0xFFdacfe6) : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedCourse = value;
                              });
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),





                  SizedBox(height: 20),

                  YearSelector(
                    controller: userYearController,
                    label: 'When did your course begin?',
                    suffixIcon: Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        width: 308,
                        height: 51,
                        child: SwipeableButtonView(
                          onFinish: () async {
                            if (_formKey.currentState!.validate() && _validateInputs()) {
                              _formKey.currentState!.save();
                              final fireStore = FirebaseFirestore.instance.collection('usersDetails');
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                String email = user.email!;
                                String phoneNumberString = phonenoController.text;
                                int phoneNumber = int.tryParse(phoneNumberString) ?? 0;

                                fireStore.doc(email).set({
                                  'id': email,
                                  'name': unameController.text.toString(),
                                  'phoneNumber': phoneNumber,
                                  'country': _selectedState,
                                  'college': _selectedCollege,
                                  'course': _selectedCourse,
                                  'courseStartYear': userYearController.text,
                                  'userDetailsfilled': true,
                                }).then((value) async {
                                  await setUserDetailsFilledLocally(true);
                                  bool userDetailsFilledLocally = await getUserDetailsFilledLocally();
                                  print('userDetailsFilledLocally: $userDetailsFilledLocally');
                                  Get.snackbar('Success', 'Updated successfully');
                                }).catchError((error) {
                                  print('Error updating user details: $error');
                                  Get.snackbar('Error', 'Failed to update your details');
                                });

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
                            }
                          },
                          isFinished: isFinished,
                          buttonText: 'Swipe to Join',
                          borderRadius: 15,
                          onWaitingProcess: () {
                            Future.delayed(Duration(seconds: 0), () {
                              setState(() {
                                isFinished = true;
                              });
                            });
                          },
                          activeColor: Color(0xFF955AF2),
                          buttonWidget: Icon(Icons.arrow_forward_rounded,color: Colors.white,), // Set active color to orange
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

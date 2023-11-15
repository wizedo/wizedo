import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/components/YearPickerTextField.dart';
import 'package:wizedo/components/colors/sixty.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:wizedo/components/searchable_dropdown.dart';
import 'package:wizedo/components/white_text.dart';
import 'LoginPage.dart';
import 'BottomNavigation.dart';

class UserDetails extends StatefulWidget {
  final String userEmail;

  const UserDetails({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String? _selectedState;
  String? _selectedCollege;
  String? _selectedCourse;
  bool isFinished = false;
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _universityNameController = TextEditingController();
  final TextEditingController unameController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();
  final TextEditingController userYearController = TextEditingController();
  bool _sliderValue = false;

  String hexColor = '#211b2e';
  bool userDetailsfilled = false;

  Future<void> setUserDetailsFilledLocally(bool value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('userDetailsFilled', value); // Change the key to 'userDetailsFilled'
    } catch (error) {
      print('Error setting user details locally: $error');
    }
  }

  Future<bool> getUserDetailsFilledLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool userDetailsFilledLocally = prefs.getBool('userDetailsFilled') ?? false; // Change the key to 'userDetailsFilled'
      return userDetailsFilledLocally;
    } catch (error) {
      print('Error getting user details locally: $error');
      return false;
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
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  Container(
                    width: 310,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/images/userdetails.png',
                          width: 300,
                          height: 150,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
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
                          prefixIcon: Image.asset(
                            'lib/images/uname.png',
                            color: Colors.white,
                          ),
                          fontSize: 12,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                              return 'Enter only alphabets';
                            }
                            if (value.length > 30) {
                              return 'Maximum characters allowed is 30';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                        MyTextField(
                          controller: phonenoController,
                          label: 'Phone Number',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          prefixIcon: Center(
                            child: Text(
                              '+91',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          fontSize: 12,
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                          width: 310,
                          height: 51,
                          child: SearchableDropdownTextField(
                            items: [
                              'Andhra Pradesh',
                              'Arunachal Pradesh',
                              'Assam',
                              'Bihar',
                              'Chhattisgarh',
                              'Goa',
                              'Gujarat',
                              'Haryana',
                              'Himachal Pradesh',
                              'Jharkhand',
                              'Karnataka',
                              'Kerala',
                              'Madhya Pradesh',
                              'Maharashtra',
                              'Manipur',
                              'Meghalaya',
                              'Mizoram',
                              'Nagaland',
                              'Odisha',
                              'Punjab',
                              'Rajasthan',
                              'Sikkim',
                              'Tamil Nadu',
                              'Telangana',
                              'Tripura',
                              'Uttar Pradesh',
                              'Uttarakhand',
                              'West Bengal'
                            ],
                            labelText: 'Current College State',
                            onSelected: (selectedItem) {
                              setState(() {
                                _selectedState = selectedItem;
                              });
                              print('Selected item: $selectedItem');
                            },
                            suffix: Icon(
                              Icons.location_city_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                          width: 310,
                          height: 51,
                          child: SearchableDropdownTextField(
                            items: [
                              'Andhra Pradesh',
                              'Arunachal Pradesh',
                              'Assam',
                              'Bihar',
                              'Chhattisgarh',
                              'Goa',
                              'Gujarat',
                              'Haryana',
                              'Himachal Pradesh',
                              'Jharkhand',
                              'Karnataka',
                              'Kerala',
                              'Madhya Pradesh',
                              'Maharashtra',
                              'Manipur',
                              'Meghalaya',
                              'Mizoram',
                              'Nagaland',
                              'Odisha',
                              'Punjab',
                              'Rajasthan',
                              'Sikkim',
                              'Tamil Nadu',
                              'Telangana',
                              'Tripura',
                              'Uttar Pradesh',
                              'Uttarakhand',
                              'West Bengal'
                            ],
                            labelText: 'Select Your College',
                            onSelected: (selectedItem) {
                              setState(() {
                                _selectedCollege = selectedItem;
                              });
                              print('Selected item: $selectedItem');
                            },
                            suffix: Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                          width: 310,
                          height: 51,
                          child: SearchableDropdownTextField(
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
                            ],
                            labelText: 'Select Your Course',
                            onSelected: (selectedItem) {
                              setState(() {
                                _selectedCourse = selectedItem;
                              });
                              print('Selected item: $selectedItem');
                            },
                            suffix: Icon(
                              Icons.book,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        YearSelector(
                          controller: userYearController,
                          label: 'When did your course begin?',
                          suffixIcon: Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                      width: 308,
                      height: 51,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_validateInputs()) {
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
                                Get.snackbar('Error', 'Failed to update user details');
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
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF955AF2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(
                            //   Icons.arrow_forward_rounded,
                            //   color: Colors.white,
                            // ),
                            // SizedBox(width: 10),
                            Text(
                              'Swipe to Join',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
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
    if (unameController.text.isEmpty ||
        phonenoController.text.isEmpty ||
        _selectedState == null ||
        _selectedCollege == null ||
        _selectedCourse == null ||
        userYearController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all the required fields.');
      return false;
    }
    return true;
  }
}

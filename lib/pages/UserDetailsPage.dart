import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:wizedo/components/YearPickerTextField.dart';
import 'package:wizedo/components/colors/sixty.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/CollegeData.dart';
import '../components/debugcusprint.dart';
import '../components/imagesname.dart';
import '../controller/UserController.dart';
import 'BottomNavigation.dart';

class UserDetails extends StatefulWidget {
  final String userEmail;

  const UserDetails({super.key, required this.userEmail});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> with WidgetsBindingObserver {
  List<String> errors = [];
  List<String> collegeItems = [];
  String? _selectedState;
  String? _selectedCollege;
  String? _selectedCourse;
  bool isFinished = false;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _universityNameController = TextEditingController();
  final TextEditingController unameController = TextEditingController();
  final TextEditingController ulastnameController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();
  final TextEditingController userYearController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String hexColor = '#211b2e';

  Future<void> setUserDetailsFilledLocally(String email, bool value) async {
    try {
      var box = Hive.box('userdetails');
      await box.put('userDetailsFilled_$email', value);
    } catch (error) {
      debugLog('Error setting user details locally: $error');
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Dispose of your controllers to free up resources
    _searchController.dispose();
    _universityNameController.dispose();
    unameController.dispose();
    ulastnameController.dispose();
    phonenoController.dispose();
    userYearController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Future<void> saveUserDetailsLocally(Map<String, dynamic> userDetails) async {
    var box = await Hive.openBox('userdetails');

    // Convert Firestore Timestamp to DateTime if necessary
    if (userDetails['lastUpdated'] is Timestamp) {
      userDetails['lastUpdated'] = (userDetails['lastUpdated'] as Timestamp).toDate();
    }

    await box.putAll(userDetails);
  }


  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        debugLog('User has clicked out of Google sign-in pop-up');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

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
          titleText: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              WhiteText(
                'Success',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          messageText: WhiteText(
            'You have successfully logged in',
            fontSize: 12,
          ),
        ),
      );

      String userEmail = googleUser.email;
      debugLog("User email through Google sign-in is: $userEmail");

      // Fetch user details from Firestore
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('usersDetails').doc(userEmail);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userDetails = docSnapshot.data()!;
        await saveUserDetailsLocally(userDetails);
      } else {
        debugLog('User details not found in Firestore');
        return null;
      }

      Get.put(UserController());
      final UserController userController = Get.find<UserController>();

      // Retrieve user details from Hive and set them in UserController
      var box = await Hive.openBox('userdetails');
      var storedUserDetails = box.toMap().cast<String, dynamic>();
      userController.setUserDetails(storedUserDetails);

      // Print user details for debugging
      print('Avatar: ${userController.avatar}');
      print('ID: ${userController.id}');
      print('First Name: ${userController.firstname}');
      print('Last Name: ${userController.lastname}');
      print('Country: ${userController.country}');
      print('College: ${userController.college}');
      print('Course: ${userController.course}');
      print('Course Start Year: ${userController.courseStartYear}');
      print('User Details Filled: ${userController.userDetailsfilled}');
      print('Last Updated: ${userController.lastUpdated}');
      print('Email Verified: ${userController.emailVerified}');

      // Now, check userDetailsfilled and redirect the user
      bool userDetailsfilled = storedUserDetails['userDetailsfilled'];
      String userName = storedUserDetails['id'];
      debugLog(userDetailsfilled);
      debugLog('Below is username');
      debugLog(userName);

      if (userDetailsfilled) {
        Get.offAll(() => const BottomNavigation());
      } else {
        Get.to(() => UserDetails(userEmail: userEmail));
      }

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle exceptions appropriately
      debugLog('Exception -> $e');
      return null;
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // App is paused (backgrounded or closed)
      // Set userDetailsFilled to false
      await setUserDetailsFilledLocally(widget.userEmail, false);
      debugLog('UserDetailsFilled set to false because the app is paused.');
    }
  }


  String _capitalizeFirstLetter(String text) {
    if (text.isNotEmpty) {
      return text[0].toUpperCase() + text.substring(1);
    }
    return text;
  }

  String _selectedImage = 'lib/images/click.png';
  String _selectedImageName = 'null';

  void _showImageSelectionDialog(BuildContext context) {
    List<Map<String, String>> shuffledImages = List.from(images);
    shuffledImages.shuffle(Random());

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(8),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              children: shuffledImages.map((image) => _buildImageOption(context, image)).toList(),
            ),
          ),
        );
      },
    );
  }


  Widget _buildImageOption(BuildContext context, Map<String, String> image) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedImage = image['path']!;
          _selectedImageName = image['name']!;
        });
        Navigator.of(context).pop();
      },
      child: Image.asset(image['path']!, width: 100, height: 100),
    );
  }


  @override
  Widget build(BuildContext context) {
    String email = widget.userEmail;
    debugLog('User email in UserDetails: ${widget.userEmail}');
    return WillPopScope(
      onWillPop: () async {
        // Disable back navigation
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF211B2E),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugLog('click on avatar');
                        _showImageSelectionDialog(context);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WhiteText('Avatar',fontSize: 14,fontWeight: FontWeight.bold,),
                          SizedBox(height: 10.0), // Space between image and text
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFF955AF2).withOpacity(0.45), // Outer color with opacity
                                  Colors.transparent, // Inner color (transparent)
                                ],
                                stops: [0.5, 1.0], // Adjust stops for gradient effect
                              ),
                            ),
                            child: Image.asset(
                              _selectedImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    )
                    ,
                    SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.center,
                      child: WhiteText(
                        "Let's Get To Know You!",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    MyTextField(
                      controller: unameController,
                      label: 'First Name',
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      textColor: const Color(0xFFdacfe6),
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
                        // Capitalize the first letter of the name
                        final capitalizedValue = _capitalizeFirstLetter(value);

                        if (capitalizedValue.isEmpty) {
                          addError(error: 'Name should be at least 1 characters');
                          return 'Name should be at least 1 characters';
                        } else {
                          removeError(error: 'Name should be at least 1 characters');
                        }

                        if (capitalizedValue.startsWith(' ')) {
                          addError(error: 'Leading spaces at the beginning are not allowed');
                          return 'Leading spaces at the beginning are not allowed';
                        } else {
                          removeError(
                              error: 'Leading spaces at the beginning are not allowed');
                        }

                        // Check for trailing spaces
                        if (capitalizedValue.endsWith(' ')) {
                          addError(error: 'Spaces at the end are not allowed');
                          return 'Spaces at the end are not allowed';
                        } else {
                          removeError(error: 'Spaces at the end are not allowed');
                        }

                        // Check for consecutive spaces
                        if (capitalizedValue.contains(RegExp(r'\s{2,}'))) {
                          addError(error: 'Consecutive spaces are not allowed');
                          return 'Consecutive spaces within the text are not allowed';
                        } else {
                          removeError(error: 'Consecutive spaces are not allowed');
                        }

                        if (capitalizedValue.length > 40) {
                          addError(error: 'Maximum characters allowed is 40');
                          return 'Maximum characters allowed is 40';
                        } else {
                          removeError(error: 'Maximum characters allowed is 40');
                        }
                        if (RegExp(r'[0-9]').hasMatch(capitalizedValue)) {
                          addError(error: 'Name should not contain numbers');
                          return 'Name should not contain numbers';
                        } else {
                          removeError(error: 'Name should not contain numbers');
                        }
                        return null;
                      },
                    ),


                    const SizedBox(height: 15),
                    //phone number controller or text field
                    // MyTextField(
                    //   controller: phonenoController,
                    //   label: 'Phone Number',
                    //   obscureText: false,
                    //   keyboardType: TextInputType.number,
                    //   textColor: Color(0xFFdacfe6),
                    //   prefixIcon: Center(
                    //     child: Text(
                    //       '+91',
                    //       style: TextStyle(fontSize: 12, color: Colors.white),
                    //     ),
                    //   ),
                    //   fontSize: 12,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       addError(error: 'Phone Number is required');
                    //       return 'Phone Number is required';
                    //     } else {
                    //       removeError(error: 'Phone Number is required');
                    //     }
                    //     if (value != null && value.length < 10) {
                    //       addError(error: 'Enter full 10 digit number');
                    //       return 'Enter full 10 digit number';
                    //     } else {
                    //       removeError(error: 'Enter full 10 digit number');
                    //     }
                    //     if (value != null && value.length > 10) {
                    //       addError(error: 'Maximum Numbers allowed is 10');
                    //       return 'Maximum Numbers allowed is 10';
                    //     } else {
                    //       removeError(error: 'Maximum Numbers allowed is 10');
                    //     }
                    //     return null;
                    //   },
                    // ),
                    //*****************************************

                    MyTextField(
                      controller: ulastnameController,
                      label: 'Last Name',
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      textColor: const Color(0xFFdacfe6),
                      prefixIcon: Image.asset(
                        'lib/images/uname.png',
                        color: Colors.white,
                      ),
                      fontSize: 12,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          addError(error: 'Last Name is required');
                          return 'Last Name is required';
                        } else {
                          removeError(error: 'Last Name is required');
                        }


                        // Capitalize the first letter of the name
                        final capitalizedValue = _capitalizeFirstLetter(value);

                        if (capitalizedValue.isEmpty) {
                          addError(error: 'Last Name should be at least 1 characters');
                          return 'Last Name should be at least 1 characters';
                        } else {
                          removeError(error: 'Last Name should be at least 1 characters');
                        }

                        // Check for leading spaces
                        if (capitalizedValue.startsWith(' ')) {
                          addError(error: 'Leading spaces at the beginning are not allowed');
                          return 'Leading spaces at the beginning are not allowed';
                        } else {
                          removeError(
                              error: 'Leading spaces at the beginning are not allowed');
                        }

                        // Check for trailing spaces
                        if (capitalizedValue.endsWith(' ')) {
                          addError(error: 'Spaces at the end are not allowed');
                          return 'Spaces at the end are not allowed';
                        } else {
                          removeError(error: 'Spaces at the end are not allowed');
                        }

                        // Check for consecutive spaces
                        if (capitalizedValue.contains(RegExp(r'\s{2,}'))) {
                          addError(error: 'Consecutive spaces are not allowed');
                          return 'Consecutive spaces within the text are not allowed';
                        } else {
                          removeError(error: 'Consecutive spaces are not allowed');
                        }


                        if (capitalizedValue.length > 40) {
                          addError(error: 'Maximum characters allowed is 40');
                          return 'Maximum characters allowed is 40';
                        } else {
                          removeError(error: 'Maximum characters allowed is 40');
                        }
                        if (RegExp(r'[0-9]').hasMatch(capitalizedValue)) {
                          addError(error: 'Last Name should not contain numbers');
                          return 'Last Name should not contain numbers';
                        } else {
                          removeError(error: 'Last Name should not contain numbers');
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),


                    // DropdownButton2 for state
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15, bottom: 7),
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
                            color: const Color(0xFF39304D), // Adjust the color as needed
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white,
                            ),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                              ),
                              hint: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _selectedState != null ? _selectedState! : 'Select Your State',
                                    style: const TextStyle(fontSize: 12, color: Colors.white),
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
                                      color: _selectedState == item ? const Color(0xFFdacfe6) : Colors.black,
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
                              validator: (value) {
                                if (value == null) {
                                  addError(error: 'Please select your state');
                                } else {
                                  removeError(error: 'Please select your state');
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // DropdownButton2 for college
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15, bottom: 7),
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
                            color: const Color(0xFF39304D), // Adjust the color as needed
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
                                  hint: const Row(
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
                                        color: _selectedCollege == item ? const Color(0xFFdacfe6) : Colors.black,
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedCollege = value;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      addError(error: 'Please select your college');
                                    }else {
                                      removeError(error: 'Please select your college');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // DropdownButton2 for course
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15, bottom: 7),
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
                            color: const Color(0xFF39304D), // Adjust the color as needed
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white,
                            ),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              hint: const Row(
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
                                      color: _selectedCourse == item ? const Color(0xFFdacfe6) : Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedCourse = value;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  addError(error: 'Please select your course');
                                }else {
                                  removeError(error: 'Please select your course');
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    YearSelector(
                      controller: userYearController,
                      label: 'When did your course begin?',
                      suffixIcon: const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          addError(error: 'Please select your course begin date');
                        }else {
                          removeError(error: 'Please select your course begin date');
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 35),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: SizedBox(
                        width: 308,
                        height: 51,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _joinButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF955AF2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator() // Show loading indicator
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tap to Join',
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
      ),
    );
  }

  void _joinButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Set loading to true when validation passes
      });

      _formKey.currentState!.save();

      bool isValid = _validateInputs();

      if (isValid) {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final firestore = FirebaseFirestore.instance;
            final email = user.email!;
            final docRef = firestore.collection('usersDetails').doc(email);

            await firestore.runTransaction((transaction) async {
              final docSnapshot = await transaction.get(docRef);

              if (!docSnapshot.exists) {
                // Handle the case where the document does not exist
                transaction.set(docRef, {}); // Ensure the document exists
              }

              // Update the document
              transaction.set(docRef, {
                'avatar': _selectedImageName,
                'id': email,
                'firstname': _capitalizeFirstLetter(unameController.text),
                'lastname': _capitalizeFirstLetter(ulastnameController.text),
                'country': _selectedState,
                'college': _selectedCollege,
                'course': _selectedCourse,
                'courseStartYear': userYearController.text,
                'userDetailsfilled': true,
                'lastUpdated': FieldValue.serverTimestamp(),
                'emailVerified': 'yes',
              }, SetOptions(merge: true)); // Use merge to update only the provided fields
            });

            await signInWithGoogle();

            setState(() {
              _isLoading = false; // Set loading to false when operation is complete
            });
          }
        } catch (error) {
          debugLog('Error updating user details: $error');
          setState(() {
            _isLoading = false; // Set loading to false when operation fails
          });
        }
      } else {
        setState(() {
          _isLoading = false; // Set loading to false when inputs are invalid
        });
      }
    }
  }

  bool _validateInputs() {
    bool isValid = true;

    if(_selectedImageName=='null'){
      Get.rawSnackbar(message: "Please choose your avatar");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    }

    if (unameController.text.isEmpty) {
      Get.rawSnackbar(message: "First Name is required");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    } else if (RegExp(r'[0-9]').hasMatch(unameController.text)) {
      Get.rawSnackbar(message: "First Name should not contain numbers");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    } else if (unameController.text.length > 40) {
      Get.rawSnackbar(message: "First Name should not exceed 40 characters");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    } else if (unameController.text.startsWith(' ') ||
        unameController.text.endsWith(' ') ||
        unameController.text.contains(RegExp(r'\s{2,}'))) {
      Get.rawSnackbar(message: "First Name should not have leading, trailing, or consecutive spaces");
      isValid = false;
    }



    if (ulastnameController.text.isEmpty) {
      Get.rawSnackbar(message: "Last Name is required");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    } else if (RegExp(r'[0-9]').hasMatch(ulastnameController.text)) {
      Get.rawSnackbar(message: "Last Name should not contain numbers");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    } else if (ulastnameController.text.length > 40) {
      Get.rawSnackbar(message: "Last Name should not exceed 40 characters");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    } else if (ulastnameController.text.startsWith(' ') || ulastnameController.text.endsWith(' ') || ulastnameController.text.contains(RegExp(r'\s{2,}'))) {
      Get.rawSnackbar(message: "Last Name should not have leading, trailing, or consecutive spaces");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    }

    if (_selectedState == null) {
      Get.rawSnackbar(message: "Please select your state");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    }

    if (_selectedCollege == null) {
      Get.rawSnackbar(message: "Please select your college");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    }

    if (_selectedCourse == null) {
      Get.rawSnackbar(message: "Please select your course");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    }

    if (userYearController.text.isEmpty) {
      Get.rawSnackbar(message: "Please select your course start year");
      isValid = false;
      setState(() {
        _isLoading = false;
      });
    }

    return isValid;
  }


}
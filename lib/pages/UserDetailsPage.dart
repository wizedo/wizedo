import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('userDetailsFilled_$email', value);
    } catch (error) {
      print('Error setting user details locally: $error');
    }
  }

  Future<bool> getUserDetailsFilledLocally(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool userDetailsFilledLocally = prefs.getBool('userDetailsFilled_$email') ?? false;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
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
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        print('user has clicked out of google sign in pop up');
        return null;
      }

      final GoogleSignInAuthentication? googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      Get.showSnackbar(
        GetSnackBar(
          borderRadius: 8,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(milliseconds: 3000),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          backgroundColor: Color(0xFF955AF2),
          // Set your desired color here
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
      print("useremail through google sign is: $userEmail");

      // Save user Gmail ID locally using shared preferences
      await saveUserEmailLocally(userEmail);

      // Now, check userDetailsfilled and redirect the user
      bool userDetailsfilled = await getUserDetailsFilled(userEmail);
      String userName = await getUserName(userEmail);
      print(userDetailsfilled);
      print('Below is username');
      print(userName);
      await setUserDetailsFilledLocally(userEmail, userDetailsfilled);
      await setUserNameLocally(userEmail, userName);

      if (userDetailsfilled == true) {
        await storeUserCollegeLocally(userEmail);
        Get.offAll(() => BottomNavigation());
      } else {
        Get.to(() => UserDetails(userEmail: userEmail));
      }

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle exceptions appropriately
      print('exception->$e');
      return null;
    }
  }


  Future<void> storeUserCollegeLocally(String userEmail) async {
    try {
      print("in try block of storeusercollegelocally");
      final docSnapshot =
      await _firestore.collection('usersDetails').doc(userEmail).get();
      if (docSnapshot.exists) {
        final userData = docSnapshot.data() as Map<String, dynamic>;
        final userCollege = userData['college'];
        print('User College stored locally: $userCollege');

        // Store the user's college name locally
        await saveCollegeLocally(userCollege, userEmail);
      } else {
        print('User details document does not exist');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

  Future<void> setUserNameLocally(String email, String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName_$email', name);
    } catch (error) {
      print('Error setting user name locally: $error');
    }
  }

  Future<void> saveUserEmailLocally(String userEmail) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', userEmail);
    } catch (error) {
      print('Error saving user email locally: $error');
    }
  }

  Future<bool> getUserDetailsFilled(String userEmail) async {
    try {
      if (userEmail.isEmpty) {
        print('Error: Empty email passed to getUserDetailsFilled');
        return false;
      }
      DocumentReference userDocRef =
      _firestore.collection('usersDetails').doc(userEmail);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        bool userDetailsfilled = userDocSnapshot['userDetailsfilled'];
        print('User details value printed');
        print('userDetailsfilled value for $userEmail: $userDetailsfilled');
        return userDetailsfilled ?? false;
      } else {
        return false;
      }
    } catch (error) {
      print('Error getting user details: $error');
      return false;
    }
  }

  Future<String> getUserName(String userEmail) async {
    try {
      if (userEmail.isEmpty) {
        print('Error: Empty email passed to getUserName');
        return ''; // Return an empty string or handle the error case accordingly
      }
      DocumentReference userDocRef =
      _firestore.collection('usersDetails').doc(userEmail);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        String username = userDocSnapshot['firstname'];
        print('User details value printed');
        print('username value for $userEmail: $username');
        return username;
      } else {
        return ''; // Return an empty string or handle the case where the document doesn't exist
      }
    } catch (error) {
      print('Error getting user details: $error');
      return ''; // Return an empty string or handle the error case accordingly
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // App is paused (backgrounded or closed)
      // Set userDetailsFilled to false
      await setUserDetailsFilledLocally(widget.userEmail, false);
      print('UserDetailsFilled set to false because the app is paused.');
    }
  }

  Future<void> saveCollegeLocally(String collegeName, String userEmail) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('selectedCollege_$userEmail', collegeName);
    } catch (error) {
      print('Error saving college locally: $error');
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isNotEmpty) {
      return text[0].toUpperCase() + text.substring(1);
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorUtil.hexToColor(hexColor);
    String email = widget.userEmail;
    print('User email in UserDetails: ${widget.userEmail}');
    return WillPopScope(
      onWillPop: () async {
        // Disable back navigation
        return false;
      },
      child: Scaffold(
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
                      label: 'First Name',
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
                        // Capitalize the first letter of the name
                        final capitalizedValue = _capitalizeFirstLetter(value);

                        if (capitalizedValue.length < 1) {
                          addError(error: 'Name should be at least 1 characters');
                          return 'Name should be at least 1 characters';
                        } else {
                          removeError(error: 'Name should be at least 1 characters');
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


                    SizedBox(height: 15),
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
                      textColor: Color(0xFFdacfe6),
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

                        if (capitalizedValue.length < 1) {
                          addError(error: 'Last Name should be at least 1 characters');
                          return 'Last Name should be at least 1 characters';
                        } else {
                          removeError(error: 'Last Name should be at least 1 characters');
                        }

                        // Check for leading spaces
                        if (capitalizedValue != null && capitalizedValue.startsWith(' ')) {
                        addError(error: 'Leading spaces at the beginning are not allowed');
                        return 'Leading spaces at the beginning are not allowed';
                        } else {
                          removeError(
                              error: 'Leading spaces at the beginning are not allowed');
                        }

                        // Check for trailing spaces
                        if (capitalizedValue != null && capitalizedValue.endsWith(' ')) {
                          addError(error: 'Spaces at the end are not allowed');
                          return 'Spaces at the end are not allowed';
                        } else {
                          removeError(error: 'Spaces at the end are not allowed');
                        }

                        // Check for consecutive spaces
                        if (capitalizedValue != null && capitalizedValue.contains(RegExp(r'\s{2,}'))) {
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

                    SizedBox(height: 20),

                    YearSelector(
                      controller: userYearController,
                      label: 'When did your course begin?',
                      suffixIcon: Icon(
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

                    SizedBox(height: 35),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        width: 308,
                        height: 51,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
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
                                      }

                                      // Update the document
                                      transaction.set(docRef, {
                                        'id': email,
                                        'firstname': _capitalizeFirstLetter(unameController.text),
                                        'lastname': _capitalizeFirstLetter(ulastnameController.text),
                                        // 'phoneNumber': int.tryParse(phonenoController.text) ?? 0,
                                        'country': _selectedState,
                                        'college': _selectedCollege,
                                        'course': _selectedCourse,
                                        'courseStartYear': userYearController.text,
                                        'userDetailsfilled': true,
                                        'lastUpdated': FieldValue.serverTimestamp(),
                                        'emailVerified': 'yes',
                                      });
                                      // Store the selected college locally
                                      saveCollegeLocally(_selectedCollege!, email);
                                    });

                                    await setUserDetailsFilledLocally(email, true);
                                    bool userDetailsFilledLocally = await getUserDetailsFilledLocally(email);
                                    print('userDetailsFilledLocally: $userDetailsFilledLocally');

                                    // Get.snackbar('Success', 'Please login into your account');

                                    await signInWithGoogle();
                                    // await Navigator.push(
                                    //   context,
                                    //   PageTransition(
                                    //     type: PageTransitionType.fade,
                                    //     child:BottomNavigation(),
                                    //   ),
                                    // );

                                    setState(() {
                                      _isLoading = false; // Set loading to false when operation is complete
                                    });
                                  }
                                } catch (error) {
                                  print('Error updating user details: $error');
                                  // Get.snackbar('Error', 'Failed to update user details');
                                  setState(() {
                                    _isLoading = false; // Set loading to false when operation fails
                                  });
                                }
                              }else {
                                setState(() {
                                  _isLoading = false; // Set loading to false when inputs are invalid
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF955AF2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator() // Show loading indicator
                              : Row(
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

  bool _validateInputs() {
    bool isValid = true;

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

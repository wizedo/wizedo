import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:wizedo/components/datePickerTextField.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_post_text_field.dart';
import '../components/my_textmultiline_field.dart';
import '../components/white_text.dart';
import 'BottomNavigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with WidgetsBindingObserver{
  bool isFinished = false;
  final TextEditingController _projectName = TextEditingController();
  final TextEditingController _numberOfPages = TextEditingController();
  final TextEditingController _descriptionText = TextEditingController();
  final TextEditingController _datePicker = TextEditingController();
  final TextEditingController _paymentDetails = TextEditingController();
  final TextEditingController _googledrivefilelink=TextEditingController();
  RxString _selectedCategory = 'College Project'.obs;
  bool _isNumberOfPagesVisible = false;
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? buttonText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    // loadSavedValues();
    adloaded();
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



  // Future<void> loadSavedValues() async {
  //   print('getting field values from locally');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _projectName.text = prefs.getString('projectName') ?? '';
  //     _numberOfPages.text = prefs.getString('numberOfPages') ?? '';
  //     _descriptionText.text = prefs.getString('descriptionText') ?? '';
  //     _datePicker.text = prefs.getString('datePicker') ?? '';
  //     _paymentDetails.text = prefs.getString('paymentDetails') ?? '';
  //     _googledrivefilelink.text = prefs.getString('googledrivefilelink') ?? '';
  //     _selectedCategory.value = prefs.getString('selectedCategory') ?? 'College Project';
  //
  //   });
  // }
  //
  // Future<void> saveLastOpenedPageAndData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //     print('setting values normally');
  //     // Save the values normally
  //     prefs.setString('lastOpenedPage', 'RegisterScreen');
  //     prefs.setString('projectName', _projectName.text);
  //     prefs.setString('numberOfPages', _numberOfPages.text);
  //     prefs.setString('descriptionText', _descriptionText.text);
  //     prefs.setString('datePicker', _datePicker.text);
  //     prefs.setString('paymentDetails', _paymentDetails.text);
  //     prefs.setString('googledrivefilelink', _googledrivefilelink.text);
  //     prefs.setString('selectedCategory', _selectedCategory.value);
  //
  // }
  //
  //
  // Future<void> resetSharedPreferencesValues() async {
  //   print('resetting the values');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('lastOpenedPage', 'seteverythingtoreset');
  //   prefs.setString('projectName', '');
  //   prefs.setString('numberOfPages', '');
  //   prefs.setString('descriptionText', '');
  //   prefs.setString('datePicker', '');
  //   prefs.setString('paymentDetails', '');
  //   prefs.setString('googledrivefilelink', '');
  //   prefs.setString('selectedCategory', '');
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (state == AppLifecycleState.paused) {
  //     // Save the last opened page and form data when the app is in the background
  //     await saveLastOpenedPageAndData();
  //   }else if(state==AppLifecycleState.detached){
  //     print('reset  detached state called');
  //     prefs.setString('lastOpenedPage', 'seteverythingtoreset');
  //     await resetSharedPreferencesValues();
  //     prefs.setString('lastOpenedPage', 'seteverythingtoreset');
  //     prefs.setString('lastOpenedPage', 'seteverythingtoreset');
  //
  //     print('Detached state values reset');
  //   }
  // }

  void _showLoadingDialog() {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  void hideLoadingDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  bool isIntersitalLoaded=false;
  late InterstitialAd interstitialAd;

  adloaded() async{
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-1022421175188483/4256627905',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad){
              setState(() {
                interstitialAd=ad;
                isIntersitalLoaded=true;
              });
            },
            onAdFailedToLoad: (error){
              print(error);
              interstitialAd.dispose();
              isIntersitalLoaded=false;
            }
        )
    );
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
    WidgetsBinding.instance!.removeObserver(this);
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
            Get.to(BottomNavigation());
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
                            _selectedCategory.value != null ? _selectedCategory.value! : 'Select Your Category',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      value: _selectedCategory.value,
                      items: ['Assignment', 'Personal Development', 'College Project']
                          .map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                                color: _selectedCategory.value == item ? Color(0xFFdacfe6) : Colors.black,
                                fontSize: 12
                            ),
                          ),
                        );
                      })
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory.value = value! as String;
                          _isNumberOfPagesVisible =
                              _selectedCategory.value == 'Assignment';
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
                  Row(
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
                        _selectedCategory.refresh();
                        if (_selectedCategory.value == 'Assignment') {
                          // Validate the Google Drive link only if the selected category is "Assignment"
                          if (value == null || value.isEmpty) {
                            addError(error: 'Google Drive link is required for assignments');
                            return 'Google Drive link is required for assignments';
                          } else {
                            removeError(error: 'Google Drive link is required for assignments');
                          }
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
                    _showLoadingDialog();
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

                      //get usere who is posting his firstname
                      final userDoc = await firestore.collection('usersDetails').doc(email).get();
                      String firstname = (userDoc['firstname'] ?? 'unknown').toString().toLowerCase();


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
                          'category': _selectedCategory.value,
                          'subCategory': _projectName.text.isNotEmpty
                              ? _projectName.text[0].toUpperCase() + _projectName.text.substring(1)
                              : _projectName.text,
                          'description': _descriptionText.text.isNotEmpty
                              ? _descriptionText.text[0].toUpperCase() + _descriptionText.text.substring(1)
                              : _descriptionText.text,
                          'pages': _numberOfPages.text,
                          'dueDate': _datePicker.text,
                          'totalPayment': int.tryParse(_paymentDetails.text) ?? 0,
                          'status': 'active', // active or rejected or applied
                          'createdAt': FieldValue.serverTimestamp(),
                          'college':userCollegee,
                          'report':0,
                          'firstname':firstname
                        });
                      });

                      Get.showSnackbar(
                        GetSnackBar(
                          borderRadius: 8,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          animationDuration: Duration(milliseconds: 800),
                          duration: Duration(milliseconds: 3000),
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          snackPosition: SnackPosition.TOP,
                          isDismissible: true,
                          backgroundColor: Color(0xFF955AF2), // Set your desired color here
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
                            'Task posted successfully!',
                            fontSize: 12,
                          ),
                        ),
                      );

                      if(isIntersitalLoaded==true){
                        interstitialAd.show();
                      }

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
                    hideLoadingDialog();
                  }finally{
                    hideLoadingDialog();
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

    // Check for empty due date
    if (_datePicker.text.isEmpty || _datePicker.text == 'null') {
      addError(error: 'Please select a valid due date');
      isValid = false;
    } else {
      removeError(error: 'Please select a valid due date');
    }

    // Check for null due date
    if (_datePicker.text == null || _datePicker.text.trim().isEmpty) {
      addError(error: 'Due date cannot be null');
      isValid = false;
    } else {
      removeError(error: 'Due date cannot be null');
    }

    if (!isValid) {
      Get.rawSnackbar(message: "Please give a valid input");
    }

    return isValid;
  }


}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:wizedo/components/datePickerTextField.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import '../components/badWords.dart';
import '../components/debugcusprint.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_post_text_field.dart';
import '../components/my_textmultiline_field.dart';
import '../components/white_text.dart';
import '../controller/UserController.dart';
import '../controller/network_controller.dart';
import 'BottomNavigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
  final RxString _selectedCategory = 'College Project'.obs;
  bool _isNumberOfPagesVisible = false;
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? buttonText;
  final UserController userController = Get.find<UserController>();
  final NetworkController _networkController = Get.put(NetworkController());



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // loadSavedValues();
    adLoaded();
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


  void _showLoadingDialog() {
    Get.dialog(
      const Center(
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


  bool isInterstitialLoaded = false;
  late InterstitialAd interstitialAd;
  DateTime? adLoadedTime;
  Box? box;

  void adLoaded() async {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-1663453972288157/1854927863',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            interstitialAd = ad;
            isInterstitialLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          print(error);
          isInterstitialLoaded = false;
        },
      ),
    );
  }

  @override
  void dispose() {
    debugLog("controllers diposed");
    // Clean up controllers when the state is removed
    _projectName.dispose();
    _numberOfPages.dispose();
    _descriptionText.dispose();
    _datePicker.dispose();
    _paymentDetails.dispose();
    _googledrivefilelink.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool isValid = _validateInputs();

      if (isValid) {

        bool warning = true;

        // Check number of pages and show confirmation if necessary
        if (_selectedCategory == 'Assignment') {
          debugLog('It is an assignment');
          int numPages = int.parse(_numberOfPages.text);
          double expectedPay = double.parse(_paymentDetails.text);
          debugLog(numPages);
          debugLog(expectedPay);
          int greaterthanprice=numPages * 20;

          if (expectedPay < greaterthanprice) {
            warning = false;
            debugLog('Condition true');

            bool? confirmResult = await Get.defaultDialog<bool>(
              title: 'Confirmation',
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // Add padding above the title
              titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Set font size of the title
              contentPadding: const EdgeInsets.all(25),
              content: Text(
                "Your offer price is too low to attract helpers. Consider raising it above ₹${greaterthanprice} or proceed with the current price. Do you want to continue?",
                textAlign: TextAlign.left,
              ),
              confirm: TextButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: const Text('Yes'),
              ),
              cancel: TextButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: const Text('No'),
              ),
            );
            warning = confirmResult ?? false;
          } else {
            debugLog('Condition not true');
          }
        }

        if(warning==true){
          try {
            _showLoadingDialog();
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final firestore = FirebaseFirestore.instance;
              final email = user.email!;
              debugLog('User email: $email');

              String? userCollege = userController.college;
              String userCollegee = userCollege ?? 'null set manually2';
              debugLog(userCollegee);

              // If college name is not available locally, fetch it from Firestore
              if (userCollege == null) {
                final userDoc = await firestore.collection('usersDetails').doc(email).get();
                if (userDoc.exists) {
                  userCollegee = userDoc['college'] ?? 'Unknown College';
                  debugLog('User college from Firestore: $userCollegee');
                }
              }

              // Generate a unique postId using date, time, and user email
              String postId = '${DateTime.now().millisecondsSinceEpoch}_${user.email.hashCode}';

              if (userCollege == null) {
                final userDoc = await firestore.collection('usersDetails').doc(email).get();
                if (userDoc.exists) {
                  userCollegee = userDoc['college'] ?? 'Unknown College';
                  debugLog('User college from Firestore: $userCollegee');
                }
              }

              // Get user who is posting his firstname
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
                  'googledrivelink': _googledrivefilelink.text,
                  'pstatus': 1,
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
                  'college': userCollegee,
                  'report': 0,
                  'firstname': firstname
                });
              });

              Get.showSnackbar(
                const GetSnackBar(
                  borderRadius: 8,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  animationDuration: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 2000),
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

              await Future.delayed(const Duration(milliseconds: 2100));

              if (isInterstitialLoaded) {
                box = await Hive.openBox('ad');
                final currentTime = DateTime.now();
                final storedAdLoadedTime = box?.get('adLoadedTime');
                if (storedAdLoadedTime == null || currentTime.difference(DateTime.parse(storedAdLoadedTime)).inSeconds >= 120) {
                  interstitialAd.show();
                  debugLog('going to show ad');
                  box?.put('adLoadedTime', currentTime.toString());
                  debugLog('showing ad and time is ${currentTime.toString()}');
                } else {
                  debugLog('not showing ad');
                }
              }

              // Redirect to the desired screen, e.g., BottomNavigation
              await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const BottomNavigation(),
                ),
              );

              setState(() {
                isFinished = false;
              });
            }

          } catch (error) {
            debugLog('Error creating post: $error');
            Get.snackbar('Error', 'Failed to create post');
            hideLoadingDialog();
          } finally {
            hideLoadingDialog();
          }

        }


      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Get.to(const BottomNavigation());
          },
        ),
        title: InkWell(
          onTap: () async {
            box = await Hive.openBox('ad');
            final storedAdLoadedTime = box?.get('adLoadedTime');
            debugLog('time in seconds is : $storedAdLoadedTime');
          },
          child: Text(
            'Post',
            style: mPlusRoundedText.copyWith(fontSize: 24),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (!_networkController.isConnected.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded, color: Colors.white, size: 70),
                SizedBox(height: 10),
                WhiteText('No Internet Connection',fontSize: 16,fontWeight: FontWeight.bold,),
              ],
            ),
          ); // Return an empty container or some other widget when there is no internet connection
        }
        return Stack(
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
                    const SizedBox(height: 10),
                    Container(
                      height: 51,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(
                            0xFF39304D), // Adjust the color as needed
                      ),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        hint: Row(
                          children: [
                            Text(
                              _selectedCategory.value ?? 'Select Your Category',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                        value: _selectedCategory.value,
                        items: [
                          'Assignment',
                          'Personal Development',
                          'College Project'
                        ]
                            .map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                  color: _selectedCategory.value == item
                                      ? const Color(0xFFdacfe6)
                                      : Colors.black,
                                  fontSize: 12
                              ),
                            ),
                          );
                        })
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCategory.value = value!;
                            _isNumberOfPagesVisible =
                                _selectedCategory.value == 'Assignment';
                          });
                          debugLog('Selected item: $value');
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

                    const SizedBox(height: 10),
                    Text(
                      'Project Name:',
                      style: mPlusRoundedText.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
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
                          if (value
                              .replaceAll(RegExp(r'\s'), '')
                              .length < 10) {
                            addError(
                                error: 'Project Name should be of at least 10 characters');
                            return 'Project Name should be of at least 10 characters';
                          } else {
                            removeError(
                                error: 'Project Name should be of at least 10 characters');
                          }
                          if (value
                              .replaceAll(RegExp(r'\s'), '')
                              .length > 24) {
                            addError(error: 'Maximum characters allowed is 25');
                            return 'Maximum characters allowed is 25';
                          } else {
                            removeError(
                                error: 'Maximum characters allowed is 15');
                          }
                          if (RegExp(r'[0-9]').hasMatch(value)) {
                            addError(error: 'Should not contain numbers');
                            return 'Should not contain numbers';
                          } else {
                            removeError(error: 'Should not contain numbers');
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Description: ',
                      style: mPlusRoundedText.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
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
                            if (value
                                .replaceAll(RegExp(r'\s'), '')
                                .length < 100) {
                              addError(
                                  error: 'Description should be of at least 20 words');
                              return 'Description should be of at least 20 words';
                            } else {
                              removeError(
                                  error: 'Description should be of at least 20 words');
                            }
                            if (value
                                .replaceAll(RegExp(r'\s'), '')
                                .length > 250) {
                              addError(
                                  error: 'Maximum characters allowed in description is 250');
                              return 'Maximum characters allowed in description is 250';
                            } else {
                              removeError(
                                  error: 'Maximum characters allowed in description is 250');
                            }
                            return null;
                          },
                        )
                    ),

                    const SizedBox(height: 10),

                    if (_isNumberOfPagesVisible)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total/Approx pages requiring assistance:',
                            style: mPlusRoundedText.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 400,
                            child: MyPostTextField(
                              controller: _numberOfPages,
                              obscureText: false,
                              hint: 'Number of pages',
                              keyboardType: TextInputType.number,
                              fontSize: 12,
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.info, color: Colors.deepPurple,),
                                onPressed: () {

                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  addError(
                                      error: 'Number of pages is required');
                                  return 'Number of pages is required';
                                } else {
                                  removeError(
                                      error: 'Number of pages is required');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    Text(
                      'Due Date: ',
                      style: mPlusRoundedText.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DateSelector(
                            width: Get.width * 0.85,
                            controller: _datePicker,
                            hint: 'Select Date (yyyy-mm-dd)',
                            suffixIcon: const Icon(
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
                    const SizedBox(height: 10),
                    Text(
                      'Upload a reference file link:(Optional)',
                      style: mPlusRoundedText.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    // Google Drive Link field with conditional validation
                    SizedBox(
                      width: double.infinity,
                      child: MyPostTextField(
                        prefixIcon: const Icon(Icons.link, color: Colors.red),
                        fontSize: 12,
                        controller: _googledrivefilelink,
                        obscureText: false,
                        hint: 'Google Drive Link',
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      'Your offer:',
                      style: mPlusRoundedText.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: MyPostTextField(
                        prefixIcon: const Icon(Icons.currency_rupee_rounded,
                            color: Colors.yellow),
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

                          if (double.parse(_paymentDetails.text) < 50) {
                            addError(
                                error: 'Expected pay should be equal to or greater than 50');
                            return 'Expected pay should be equal to or greater than 50';
                          } else {
                            removeError(
                                error: 'Expected pay should be equal to or greater than 50');
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                ),
              ),
            ),

          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 10 , right: 10 , bottom: 5),
          child: Obx((){
            if (!_networkController.isConnected.value) {
              return Container(); // Return an empty container or some other widget when there is no internet connection
            }
            return MyElevatedButton(
              onPressed: (){
                Get.defaultDialog(
                  title: 'Confirmation',
                  titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // Add padding above the title
                  titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Set font size of the title
                  contentPadding: const EdgeInsets.all(25),
                  middleText: "Are you sure you want to proceed with this post?",
                  confirm: TextButton(
                    onPressed: () async {
                      _handleSubmit();
                      // Get.back(); later if any should check this
                    },
                    child: const Text('Yes'),
                  ),
                  cancel: TextButton(
                    onPressed: () {
                      Get.back(); // Close the confirmation dialog
                    },
                    child: const Text('No'),
                  ),
                );
              },
              buttonText: 'Get Answers Now',
              fontWeight: FontWeight.bold,
            );
  }),
        ),

      ),
    );
  }

  // Ensure you have a valid context to close the dialog if it's open
  void closeCurrentDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }


  bool _validateInputs() {
    bool isValid = true;

    String projectName = _projectName.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    String description = _descriptionText.text.trim().replaceAll(RegExp(r'\s+'), ' ');

    _projectName.text = projectName;
    _descriptionText.text = description;

    if (_datePicker.text.isEmpty || _datePicker.text == 'null') {
      addError(error: 'Please select a valid due date');
      Get.rawSnackbar(message: "Please select a valid due date");
      isValid = false;
      closeCurrentDialog(context);
    } else {
      removeError(error: 'Please select a valid due date');
    }

    if (_datePicker.text.trim().isEmpty) {
      addError(error: 'Due date cannot be null');
      if (isValid) Get.rawSnackbar(message: "Due date cannot be null");
      isValid = false;
    } else {
      removeError(error: 'Due date cannot be null');
    }

    if (projectName.isEmpty) {
      addError(error: 'Project Name is required');
      if (isValid) Get.rawSnackbar(message: "Project Name is required");
      isValid = false;
    } else if (projectName.replaceAll(RegExp(r'\s'), '').length < 10) {
      addError(error: 'Project Name should be of at least 10 characters');
      if (isValid) Get.rawSnackbar(message: "Project Name should be of at least 10 characters");
      isValid = false;
    } else if (projectName.replaceAll(RegExp(r'\s'), '').length > 24) {
      addError(error: 'Maximum characters allowed in project name is 25');
      if (isValid) Get.rawSnackbar(message: "Maximum characters allowed in project name is 25");
      isValid = false;
    } else if (RegExp(r'[0-9]').hasMatch(projectName)) {
      addError(error: 'Project Name should not contain numbers');
      if (isValid) Get.rawSnackbar(message: "Project Name should not contain numbers");
      isValid = false;
    } else {
      for (String word in badWords) {
        if (RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false).hasMatch(projectName.toLowerCase())) {
          addError(error: 'Project Name contains inappropriate language');
          if (isValid) {
            Get.showSnackbar(GetSnackBar(
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              animationDuration: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 4000),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              snackPosition: SnackPosition.BOTTOM,
              isDismissible: true,
              backgroundColor: Colors.red.shade400,
              messageText: Text.rich(TextSpan(
                children: [
                  const TextSpan(text: 'Project Name contains inappropriate language: ', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  TextSpan(text: '"$word"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                  const TextSpan(text: '. Continuing this behavior may result in a ban.', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              )),
            ));
          }
          isValid = false;
          break;
        }
      }
    }

    if (isValid) {
      removeError(error: 'Project Name is required');
      removeError(error: 'Project Name should be of at least 10 characters');
      removeError(error: 'Maximum characters allowed in project name is 25');
      removeError(error: 'Project Name should not contain numbers');
      removeError(error: 'Project Name contains inappropriate language');
    }

    if (description.isEmpty) {
      addError(error: 'Description is required');
      if (isValid) Get.rawSnackbar(message: "Description is required");
      isValid = false;
    } else if (description.replaceAll(RegExp(r'\s'), '').length < 100) {
      addError(error: 'Description should be of at least 20 words');
      if (isValid) Get.rawSnackbar(message: "Description should be of at least 20 words");
      isValid = false;
    } else if (description.replaceAll(RegExp(r'\s'), '').length > 250) {
      addError(error: 'Maximum characters allowed in description is 250');
      if (isValid) Get.rawSnackbar(message: "Maximum characters allowed in description is 250");
      isValid = false;
    } else {
      for (String word in badWords) {
        if (RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false).hasMatch(description.toLowerCase())) {
          addError(error: 'Description contains inappropriate language');
          if (isValid) {
            Get.showSnackbar(GetSnackBar(
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              animationDuration: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 4000),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              snackPosition: SnackPosition.BOTTOM,
              isDismissible: true,
              backgroundColor: Colors.red.shade400,
              messageText: Text.rich(TextSpan(
                children: [
                  const TextSpan(text: 'Description contains inappropriate language: ', style: TextStyle(color: Colors.white, fontSize: 12)),
                  TextSpan(text: '"$word"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                  const TextSpan(text: '. Continuing this behavior may result in a ban.', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              )),
            ));
          }
          isValid = false;
          break;
        }
      }
    }

    if (isValid) {
      removeError(error: 'Description is required');
      removeError(error: 'Description should be of at least 20 words');
      removeError(error: 'Maximum characters allowed in description is 250');
      removeError(error: 'Description contains inappropriate language');
    }

    if (_paymentDetails.text.isEmpty) {
      addError(error: 'Expected pay is required');
      if (isValid) Get.rawSnackbar(message: "Expected pay is required");
      isValid = false;
    } else {
      removeError(error: 'Expected pay is required');
    }

    if (double.parse(_paymentDetails.text) < 50) {
      addError(error: 'Expected pay should be equal to or greater than 50');
      if (isValid) Get.rawSnackbar(message: "Expected pay should be equal to or greater than 50");
      isValid = false;
    } else {
      removeError(error: 'Expected pay should be equal to or greater than 50');
    }



    return isValid;
  }




}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:wizedo/pages/BottomNavigation.dart';
import '../components/YearPickerTextField.dart';
import '../components/colors/sixty.dart';
import '../components/my_text_field.dart';
import '../components/my_textbutton.dart';
import '../components/searchable_dropdown.dart';
import '../components/white_text.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String? _selectedCountry;
  bool isFinished = false;
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _universityNameController = TextEditingController();
  final TextEditingController unameController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();
  final TextEditingController userYearController=TextEditingController();
  bool _sliderValue=false;


  String hexColor = '#211b2e';

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorUtil.hexToColor(hexColor);


    return Scaffold(
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                        ),
                        SizedBox(height: 25),
                        MyTextField(
                          controller: phonenoController,
                          label: 'Phone Number',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          prefixIcon: Center(
                              child: Text('+91',
                                style: TextStyle(fontSize: 12,color: Colors.white),)),
                          fontSize: 12,
                        ),
                        SizedBox(height: 25,),

                        //Remember to fetch the items list from firestore
                        //searchabledropdownforstate
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
                              // Handle the selected item here
                              print('Selected item: $selectedItem');
                            },
                            suffix: Icon(Icons.location_city_rounded,
                              color: Colors.white,
                              size: 25,
                            ), // Optional suffix widget, you can replace it with any widget you want
                          ),
                        ),
                        SizedBox(height: 25),

                        //Searchabledropdownforcollege
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
                              // Handle the selected item here
                              print('Selected item: $selectedItem');
                            },
                            suffix: Icon(Icons.location_on_rounded,
                              color: Colors.white,
                              size: 20,
                            ), // Optional suffix widget, you can replace it with any widget you want
                          ),
                        ),

                        SizedBox(height: 25,),

                        //Searchabledropdownforcourse
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
                              // Handle the selected item here
                              print('Selected item: $selectedItem');
                            },
                            suffix: Icon(Icons.book,
                              color: Colors.white,
                              size: 20,
                            ), // Optional suffix widget, you can replace it with any widget you want
                          ),
                        ),

                        SizedBox(height: 25,),

                        // YearSelector widget
                        YearSelector(
                          controller: userYearController,
                          label: 'When did your course begin?',
                          suffixIcon: Icon(Icons.calendar_month_rounded,color: Colors.white,),
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
                      child: SwipeableButtonView(
                        onFinish: () async {
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
                        activeColor: Color(0xFF955AF2), // Set active color to orange
                        buttonWidget: Icon(Icons.arrow_forward_rounded,color: Colors.white,), // Set the widget inside the button
                        buttonText: 'Swipe to Join', borderRadius: 15, // Set the button text
                        // borderRadius: 10.0, // Set the border radius of the button
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}

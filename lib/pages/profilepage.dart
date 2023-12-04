import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/colors.dart';
import '../components/mPlusRoundedText.dart';
import '../components/settingsLabel.dart';

class UserDetails {
  final String id;
  final String name;
  final String course;
  final String college;
  final int phone;

  UserDetails({
    required this.id,
    required this.name,
    required this.course,
    required this.college,
    required this.phone,
  });
}

class ProfilePage extends StatelessWidget {
  final UserDetails userDetails;

  const ProfilePage({Key? key, required this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Profile',
          style: mPlusRoundedText.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF955AF2),
                ),
                child: Center(
                  child: Text(
                    'N',
                    style: rubicMicrobe.copyWith(fontSize: 100,fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF39304D), // Adjust the color as needed
                ),
                child:Text('ID : ${userDetails.id}',style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF39304D), // Adjust the color as needed
                ),
                child:Text('NAME : ${userDetails.name}',style: TextStyle(color: Colors.white)),
                ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF39304D), // Adjust the color as needed
                ),
                child:Text('COURSE : ${userDetails.course}',style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF39304D), // Adjust the color as needed
                ),
                child:Text('COLLEGE : ${userDetails.college}',style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF39304D), // Adjust the color as needed
                ),
                child:Text('PHONE : ${userDetails.phone}',style: TextStyle(color: Colors.white)),
              ),
                ]
          ),
        ),
    ),


          );
  }
}

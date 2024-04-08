import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/colors.dart';
import '../components/mPlusRoundedText.dart';

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
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF955AF2),
        title: Text('Profile',style: mPlusRoundedText.copyWith(fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: (){
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Container(
                color: Color(0xFF955AF2),
                height: 70,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25,right: 25,left: 25),
                  child: Column(
                    children: [
                      Container(
                        width: screenHeight > 600 ? 125 : 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Set border color to black
                            width:3, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFF955AF2), // Set container background color to transparent
                        ),
                        child: Center(
                          child: Text(
                            userDetails.name.isNotEmpty
                                ? userDetails.name[0].toUpperCase()
                                : '-',
                            style: GoogleFonts.rubikMicrobe(
                              fontSize: screenHeight < 600 ? 50 : 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      buildInfoRow(context,Icons.person, '${userDetails.name}'),
                      SizedBox(height: 20),
                      buildInfoRow(context, Icons.mail_outline_rounded, '${userDetails.id}'),
                      SizedBox(height: 20),
                      buildInfoRow(context, Icons.book_outlined, '${userDetails.course}'),
                      SizedBox(height: 20),
                      buildInfoRow(context, Icons.school, '${userDetails.college}'),
                      // SizedBox(height: 20),
                      // buildInfoRow(context, Icons.phone, '${userDetails.phone}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(BuildContext context,IconData iconData, String text) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(15),
      width: Get.width * 0.99,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
          width: 1.5, // Set border width
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent, // Set container background color to transparent
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: Color(0xFF955AF2),
                size: screenHeight < 600 ? 22 : 32,
              ),
              SizedBox(width: 10),
            ],
          ),
          Expanded(
            child: Text(
              text,
              style: mPlusRoundedText.copyWith(fontSize: screenHeight < 600 ? 9 : 12),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

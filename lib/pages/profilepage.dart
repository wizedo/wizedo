import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Profile',style: mPlusRoundedText.copyWith(fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                DottedBorder(
                  borderType: BorderType.Circle,
                  dashPattern: [5, 5],
                  strokeWidth: 3,
                  radius: Radius.circular(50),
                  color: Color(0xFF955AF2),
                  child: Container(
                    width: 135,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF955AF2),
                    ),
                    child: Center(
                      child: Text(
                        userDetails.name.isNotEmpty
                            ? userDetails.name[0].toUpperCase()
                            : '-',
                        style: GoogleFonts.rubikMicrobe(
                          fontSize: 100,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildInfoRow(Icons.person, '${userDetails.name.toUpperCase()}'),
                SizedBox(height: 20),
                buildInfoRow(Icons.perm_identity, '${userDetails.id}'),
                SizedBox(height: 20),
                buildInfoRow(Icons.book_outlined, '${userDetails.course}'),
                SizedBox(height: 20),
                buildInfoRow(Icons.school, '${userDetails.college}'),
                SizedBox(height: 20),
                buildInfoRow(Icons.phone, '${userDetails.phone}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData iconData, String text) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF955AF2), // Set border color to white
          width: 2.0, // Set border width
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors
            .transparent, // Set container background color to transparent
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: Color(0xFF955AF2),
              ),
              SizedBox(width: 10),
            ],
          ),
          Expanded(
            child: Text(
              text,
              style: mPlusRoundedText.copyWith(fontSize: 15,fontWeight: FontWeight.normal,),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

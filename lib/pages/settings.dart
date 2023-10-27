import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wizedo/components/boxDecoration.dart';
import 'package:wizedo/components/cardContainerSettings.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';

import '../Widgets/colors.dart';
import '../components/gradientBoxDecoration.dart';

class settingScreen extends StatelessWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Settings',
          style: mPlusRoundedText.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: gradientBoxDecoration,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF955AF2),
                            ),
                            child: Center(
                              child: Text(
                                'N',
                                style: GoogleFonts.rubikMicrobe(
                                  fontSize: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Naresh',
                                style: mPlusRoundedText,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                width: 220, // Set a maximum width for the text
                                child: Text(
                                  'Computer Science and Engineering',
                                  style: mPlusRoundedText.copyWith(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 220,
                                child: Text(
                                  'Presidency University, Bangalore',
                                  style: mPlusRoundedText.copyWith(fontSize: 9),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Earner',
                                style: mPlusRoundedText.copyWith(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Row(
                  children: [
                    cardSettingContainer(text: 'Earnings',iconData: Icons.currency_rupee_rounded,),
                    cardSettingContainer(text: 'Payment',iconData: Icons.payment,),
                    cardSettingContainer(text: 'Help',iconData: Icons.help,),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(1),
                margin: EdgeInsets.all(12),
                width: double.infinity,
                decoration: cardContainerdecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.account_circle,color: Colors.white,),
                        label: Text('Profile',style: TextStyle(color: Colors.white),),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft, // Align the button's contents to the left
                        ),
                      ),
                    ),
                    Divider(height: 0.2, color: Colors.grey), // Add a horizontal line
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.notification_important,color: Colors.white,),
                        label: Text('Notification',style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft, // Align the button's contents to the left
                        ),
                      ),
                    ),
                    Divider(height: 0.2, color: Colors.grey), // Add a horizontal line
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.privacy_tip_sharp,color: Colors.white,),
                        label: Text('Privacy Policy',style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft, // Align the button's contents to the left
                        ),
                      ),
                    ),
                    Divider(height: 0.2, color: Colors.grey), // Add a horizontal line
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.label_important,color: Colors.white,),
                        label: Text('Terms and Conditions',style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft, // Align the button's contents to the left
                        ),
                      ),
                    ),
                  ],
                ),
              )



            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wizedo/components/boxDecoration.dart';
import 'package:wizedo/components/cardContainerSettings.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import 'package:wizedo/pages/privacyPolicy.dart';
import 'package:wizedo/pages/profilepage.dart';
import 'package:wizedo/pages/terms&cond.dart';

import '../Widgets/colors.dart';
import '../components/gradientBoxDecoration.dart';

class settingScreen extends StatelessWidget {
  final CollectionReference fireStore;

  settingScreen({Key? key})
      : fireStore = FirebaseFirestore.instance.collection('usersDetails'),
        super(key: key);
  User? user = FirebaseAuth.instance.currentUser;
  call(){
    print(fireStore.id);
    print(user?.email);
  }

  Future<void> getData(BuildContext context) async {


    // Assuming you want to fetch data for a specific user, replace 'wizedoit@gmail.com' with the desired user's email.
    QuerySnapshot querySnapshot = await fireStore.where('id', isEqualTo:user?.email).get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

      // Access the specific fields you need
      final String id = userData['id'];
      final String college = userData['college'];
      final String name = userData['name'];
      final String course = userData['course'];
      final int phoneNumber=userData['phoneNumber'];

      print('ID: $id, College: $college, Name: $name, Course: $course, Phone: $phoneNumber');
      print(userData);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            userDetails: UserDetails(
              id: id,
              name: name,
              course: course,
              college: college,
              phone:phoneNumber,
            ),
          ),
        ),
      );
      
    } else {
      print('User not found');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
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
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF955AF2),
                            ),
                            child: Center(
                              child: Text(
                                'N',
                                style: TextStyle(
                                  fontSize: 50,
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
                                width: 220,
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
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    cardSettingContainer(text: 'Earnings', iconData: Icons.currency_rupee_rounded),
                    cardSettingContainer(text: 'Payment', iconData: Icons.payment),
                    cardSettingContainer(text: 'Help', iconData: Icons.help),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(1),
                margin: EdgeInsets.all(12),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                          onPressed: (){
                            getData(context);
                          },
                        icon: Icon(Icons.account_circle, color: Colors.white),
                        label: Text('Profile', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    Divider(height: 0.2, color: Colors.grey),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.notification_important, color: Colors.white),
                        label: Text('Notification', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    Divider(height: 0.2, color: Colors.grey),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () {
                          // Navigate to the Terms and Conditions page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PrivacyPolicyPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.privacy_tip_sharp, color: Colors.white),
                        label: Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    Divider(height: 0.2, color: Colors.grey),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () {
                          // Navigate to the Terms and Conditions page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TermsConditionsPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.label_important, color: Colors.white),
                        label: Text('Terms and Conditions', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    Divider(height: 0.2, color: Colors.grey),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: Icon(Icons.logout, color: Colors.white),
                        label: Text('Log-Out', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

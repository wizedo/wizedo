import 'package:flutter/material.dart';
import 'package:wizedo/Widgets/colors.dart';

import '../components/mPlusRoundedText.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Terms of Service',
          style: mPlusRoundedText.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'Terms and Conditions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.red),
              ),
              Text(
                'Please read these terms carefully before using the app.',
                style: TextStyle(fontSize: 10,color: Colors.white)),
              SizedBox(height: 10),
              Text(
                '1.User Registration:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'Users must provide accurate and complete information during the registration process. Users are responsible for maintaining the confidentiality of their account credentials.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '2.Content Sharing:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'Users can share knowledge, collaborate, and assign tasks within the app. Users are solely responsible for the content they post. Inappropriate, offensive, or illegal content is strictly prohibited.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '3.Payments:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'Users can make and receive payments within the app for completed tasks. Payments are processed securely, and the app is not responsible for any payment disputes between users.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '4.Safety and Security:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'Users are responsible for their own safety when meeting others in person. The app does not conduct background checks on users. Users are advised to meet in public places and exercise caution.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '5.Prohibited Activities:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'Users are prohibited from engaging in fraudulent activities, spamming, hacking, or any other illegal or unauthorized use of the app.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '6.Termination:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'The app reserves the right to suspend or terminate user accounts that violate these terms and conditions.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '7.Changes to Terms:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'The app reserves the right to modify these terms and conditions at any time. Users will be notified of any changes.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'By using our app, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions. If you do not agree with these terms, please do not use the app.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10,color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

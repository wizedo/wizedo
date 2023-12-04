import 'package:flutter/material.dart';
import 'package:wizedo/Widgets/colors.dart';

import '../components/mPlusRoundedText.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Privacy Policy',
          style: mPlusRoundedText.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                'Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.red),
              ),
              SizedBox(height: 10),
              Text(
                'This Privacy Policy describes how we collect, use, and disclose personal information when you use our peer-to-peer learning app.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                '1.Information We Collect:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'We collect personal information such as name, email address, phone number, and payment details when you register an account, post content, or make payments within the app.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '2.How We Use Your Information:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'We use your personal information to provide and improve our services, process payments, communicate with you, and ensure the security of our app. By using our app, you consent to the collection and use of your information as described in this Privacy Policy.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '3.Sharing Your Information:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'We may share your information with other users within the app as necessary for the peer-to-peer learning process. Your payment information will be securely processed through a third-party payment gateway.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '4.Data Security:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'We take appropriate measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no data transmission over the internet or stored on a server can be guaranteed to be 100% secure. Therefore, while we strive to protect your privacy, we cannot guarantee its absolute security.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '5.Your Choices:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'You can review, update, or delete your account and personal information at any time. Please contact us if you need assistance with these options.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '6.Changes to Privacy Policy:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.red),
              ),
              Text(
                'We reserve the right to modify this Privacy Policy at any time. You will be notified of any changes, and your continued use of the app after such modifications will constitute your acknowledgment and acceptance of the updated Privacy Policy.',
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'By using our app, you acknowledge that you have read, understood, and agreed to the terms of this Privacy Policy. If you do not agree with this Privacy Policy, please do not use the app.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

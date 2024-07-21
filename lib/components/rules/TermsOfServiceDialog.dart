import 'package:flutter/material.dart';

class TermsOfServiceDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Terms of Service"),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Terms and Conditions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'Please read these terms carefully before using the app.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 10),
            Text(
              '1. User Registration:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'Users must provide accurate and complete information during the registration process. Users are responsible for maintaining the confidentiality of their account credentials.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '2. Content Sharing:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'Users can share knowledge, collaborate, and assign tasks within the app. Users are solely responsible for the content they post. Inappropriate, offensive, or illegal content is strictly prohibited.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '3. Payments:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'Users can make and receive payments within the app for completed tasks. Payments are processed securely, and the app is not responsible for any payment disputes between users.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '4. Safety and Security:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'Users are responsible for their own safety when meeting others in person. The app does not conduct background checks on users. Users are advised to meet in public places and exercise caution.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '5. Prohibited Activities:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'Users are prohibited from engaging in fraudulent activities, spamming, hacking, or any other illegal or unauthorized use of the app.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '6. Termination:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'The app reserves the right to suspend or terminate user accounts that violate these terms and conditions.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '7. Changes to Terms:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'The app reserves the right to modify these terms and conditions at any time. Users will be notified of any changes.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 20),
            Text(
              'By using our app, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions. If you do not agree with these terms, please do not use the app.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}

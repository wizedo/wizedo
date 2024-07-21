import 'package:flutter/material.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Privacy Policy"),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 10),
            Text(
              'This Privacy Policy describes how we collect, use, and disclose personal information when you use our peer-to-peer learning app.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 10),
            Text(
              '1. Information We Collect:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'We collect personal information such as name, email address, phone number, and payment details when you register an account, post content, or make payments within the app.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '2. How We Use Your Information:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'We use your personal information to provide and improve our services, process payments, communicate with you, and ensure the security of our app. By using our app, you consent to the collection and use of your information as described in this Privacy Policy.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '3. Sharing Your Information:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'We may share your information with other users within the app as necessary for the peer-to-peer learning process. Your payment information will be securely processed through a third-party payment gateway.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '4. Data Security:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'We take appropriate measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no data transmission over the internet or stored on a server can be guaranteed to be 100% secure. Therefore, while we strive to protect your privacy, we cannot guarantee its absolute security.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '5. Your Choices:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'You can review, update, or delete your account and personal information at any time. Please contact us if you need assistance with these options.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 5),
            Text(
              '6. Changes to Privacy Policy:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              'We reserve the right to modify this Privacy Policy at any time. You will be notified of any changes, and your continued use of the app after such modifications will constitute your acknowledgment and acceptance of the updated Privacy Policy.',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 20),
            Text(
              'By using our app, you acknowledge that you have read, understood, and agreed to the terms of this Privacy Policy. If you do not agree with this Privacy Policy, please do not use the app.',
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

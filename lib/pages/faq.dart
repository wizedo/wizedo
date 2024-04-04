import 'package:flutter/material.dart';

import '../components/BlackText.dart';


class FAQPage extends StatelessWidget {
  // Define a list of questions, answers, and corresponding icons
  final List<Map<String, dynamic>> faqData = [
    {
      'question': 'What is the purpose of this app?',
      'answer': 'The purpose of this app is to facilitate peer-to-peer learning '
          'among college students. It allows students to post what they want to learn '
          'or collaborate with others on specific topics in exchange for money.',
    },
    {
      'question': 'Who can use this app?',
      'answer': 'This app is designed for college students who are seeking '
          'opportunities to learn from their peers or collaborate on projects '
          'in exchange for compensation. Users must have a college email address '
          'to register and access the platform.',
    },
    {
      'question': 'How does the app work?',
      'answer': 'The app allows users to create posts detailing what they want '
          'to learn or collaborate on. Other users can browse these posts and '
          'offer their expertise or assistance in exchange for money. Once a '
          'collaboration is agreed upon, users can communicate and work together '
          'through the app to achieve their learning or project goals.',
    },
    {
      'question': 'Is it safe to use this app?',
      'answer': 'Yes, the app implements various safety measures to ensure '
          'a secure and trustworthy environment for users. All users must '
          'verify their college email addresses during registration, and '
          'communications between users are monitored to prevent misuse '
          'or inappropriate behavior. Additionally, users have the option '
          'to report any suspicious or abusive activity.',
    },
    {
      'question': 'How can I get started?',
      'answer': 'To get started, simply download the app from the app store '
          'and register with your college email address. Once registered, '
          'you can create posts or browse existing posts to find opportunities '
          'for learning or collaboration. Make sure to read the app guidelines '
          'and community rules to ensure a positive experience for yourself '
          'and others.',
    },
    // Add more questions, answers, and icons as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlackText('FAQ'), // Use BlackText for the app title
        backgroundColor: Color(0xFF955AF2),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        itemCount: faqData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Remove divider lines
                child: ExpansionTile(
                  // tilePadding: EdgeInsets.zero, // Remove padding around expansion tile content
                  // Remove leading icon
                  title: Padding(
                    padding: EdgeInsets.all(8),
                    child: BlackText(
                      faqData[index]['question']!,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 30, right: 20),
                      child: BlackText(
                        faqData[index]['answer']!,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
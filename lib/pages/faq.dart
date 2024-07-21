import 'package:flutter/material.dart';
import '../components/BlackText.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, dynamic>> faqData = [
    {
      'question': 'What is the purpose of this app?',
      'answer': 'This app fosters peer-to-peer learning among college students. It enables users to share knowledge and collaborate on various topics.'
    },
    {
      'question': 'Who can use this app?',
      'answer': 'This app is exclusively for college students looking to learn from peers or collaborate on projects from their specific college.'
    },
    {
      'question': 'How does the app work?',
      'answer': 'Users can create posts in specific categories about what they want to learn or collaborate on, specifying the amount they are willing to pay. When another user applies to collaborate, the user who posted the learning request needs to pay the specified amount upfront. This payment is held by the app until the collaboration is successfully concluded and verified by the user who posted the request. Once verified, the payment is released to the user offering the service.'
    },
    {
      'question': 'How can I earn through this app?',
      'answer': 'You can earn by offering your expertise to help others learn or collaborate on projects. Simply browse the posts and apply for opportunities that match your skills.'
    },
    {
      'question': 'How can I learn through this app?',
      'answer': 'You can learn by posting requests for assistance or collaboration in areas where you need help. Specify the topic and the amount you\'re willing to pay, and peers with expertise in that area can apply to assist you.'
    },
    {
    'question':'What actions can lead to an account suspension?',
    'answer':"Actions that can lead to an account suspension include but are not limited to:\n\n1. Violating the app's community guidelines or terms of service.\n2. Engaging in abusive or inappropriate behavior towards other users.\n3. Posting misleading or fraudulent content.\n4. Attempting to manipulate or exploit the app's features for personal gain.\n\nAccount suspensions are implemented to maintain a safe and respectful environment for all users."
    }

];

  FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BlackText('FAQ'), // Use BlackText for the app title
        backgroundColor: const Color(0xFF955AF2),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        itemCount: faqData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    padding: const EdgeInsets.all(8),
                    child: BlackText(
                      faqData[index]['question']!,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25, bottom: 30, right: 20),
                      child: BlackText(
                        faqData[index]['answer']!,
                        fontSize: 12,
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

import 'package:flutter/material.dart';
import 'package:wizedo/Widgets/colors.dart';

import '../components/mPlusRoundedText.dart';

class RefundAndCancellation extends StatelessWidget {
  const RefundAndCancellation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Refund And Cancellation',
          style: mPlusRoundedText.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Refund And Cancellation Policy',style: TextStyle(fontSize: screenHeight > 600 ? 15 : 14,color: Colors.red),),
              const SizedBox(height: 10,),
              Text('Last updated on ${getCurrentDate()}',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              const SizedBox(height: 10,),
              Text('Scanpick Private Limited provides a platform for peer-to-peer learning and knowledge exchange. As such, please note the following guidelines regarding cancellations and refunds:',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              const SizedBox(height: 10,),
              Text('• Once a learning session has been initiated between two users, cancellations or refunds will not be facilitated by Scanpick Private Limited. Users are encouraged to resolve any issues or concerns regarding the learning process directly with each other.',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              const SizedBox(height: 10,),
              Text('• It is the responsibility of both the learner and the instructor to ensure mutual agreement and satisfaction regarding the content and delivery of the learning session. Scanpick Private Limited does not assume liability for any disputes or disagreements arising between users.',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  String getCurrentDate() {
    // Replace this function with your method to get the current date in the desired format
    return '10-05-2024 21:45:10';
  }
}

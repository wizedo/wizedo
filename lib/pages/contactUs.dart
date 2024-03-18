import 'package:flutter/material.dart';
import 'package:wizedo/Widgets/colors.dart';

import '../components/mPlusRoundedText.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Contact Us',
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
        padding: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Contact Us',style: TextStyle(fontSize: screenHeight > 600 ? 15 : 14,color: Colors.red),),
              SizedBox(height: 10,),
              Text('Last updated on 18-03-2024 14:00:09',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('You may contact us using the information below:',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              Text('Merchant Legal entity name: SCANPICK PRIVATE LIMITED',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              Text('Registered Address: 310, VALSALA NIVAS, VALSALA NIVAS, 6T, CROSS, PEENYA',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              Text('DASARAHALLI, BENGALURU, BENGALURU URBAN, KARNATAKA, 560057, BANGALORE',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              Text('NORTH, Karnataka, PIN: 560057',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('Operational Address: 310, VALSALA NIVAS, VALSALA NIVAS, 6T, CROSS, PEENYA',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              Text('DASARAHALLI, BENGALURU, BENGALURU URBAN, KARNATAKA, 560057, BANGALORE',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              Text('NORTH, Karnataka, PIN: 560057',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('Telephone No(Naresh): 8123341257',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              Text('Telephone No(Vishnu): 9535089114',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),),
              SizedBox(height: 10,),
              Text('E-Mail ID: wizedoit@gmail.com',style: TextStyle(fontSize: screenHeight > 600 ? 10 : 9,color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}

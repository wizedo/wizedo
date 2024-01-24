

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wizedo/components/my_timeline_tile.dart';
import 'package:wizedo/components/white_text.dart';
import '../components/mPlusRoundedText.dart';
import '../components/my_elevatedbutton.dart';

class statusPage extends StatefulWidget {
  const statusPage({super.key});

  @override
  State<statusPage> createState() => _statusPageState();
}

class _statusPageState extends State<statusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Post',
          style: mPlusRoundedText.copyWith(fontSize: 24,color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            //start timeline
            MyTimeLineTile(
              isFirst: true,
              isLast: false,
              isPast: true,
              eventCard: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                  children: [
                    WhiteText('Task Created', fontWeight: FontWeight.bold, fontSize: 16,),
                    WhiteText('Task has been posted waiting for someone to accept your task',fontSize: 12)
                  ],
                ),
              ),
            ),
            // middle timeline
            MyTimeLineTile(
              isFirst: false,
              isLast: false,
              isPast: false,
              eventCard: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                  children: [
                    WhiteText('Task Accepted', fontWeight: FontWeight.bold, fontSize: 16,),
                    WhiteText('Task has been accepted waiting for the payment',fontSize: 12)
                  ],
                ),
              ),
            ),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement action when the user wants to communicate with the assigned peermate
                    // You can add your logic here
                    print('Communicate with Peermate Button Pressed');
                  },
                  child: Text('Cancel',),
                ),
                SizedBox(width: 40,),
                MyElevatedButton(
                    onPressed: (){
                      print('pay button tapped');
                    },
                    width: 180,
                    height: 40,
                    borderRadius: 20,
                    buttonText: 'Pay')
              ],
            ),
            //last timeline
            MyTimeLineTile(
              isFirst: false,
              isLast: false,
              isPast: false,
              eventCard: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                  children: [
                    WhiteText('In Progress', fontWeight: FontWeight.bold, fontSize: 16,),
                    WhiteText('waiting......',fontSize: 12)
                  ],
                ),
              ),
            ),
            MyTimeLineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              eventCard: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                  children: [
                    WhiteText('Task Completed', fontWeight: FontWeight.bold, fontSize: 16,),
                    // WhiteText('waiting......',fontSize: 12)
                  ],
                ),
              ),
            ),

            // task posted
            //
            // task assigned
            // task has been accepted waiting for the payment
            // In progress
            //
            // task completed
          ],
        ),
      ),
    );
  }
}

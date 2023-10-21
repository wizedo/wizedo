import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wizedo/Widgets/colors.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import '../components/boxDecoration.dart';
import '../components/colors/sixty.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    String hexColor = '#211b2e';
    Color backgroundColor = ColorUtil.hexToColor(hexColor);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Details',
          style: mPlusRoundedText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Description Tile
            Container(
              decoration: boxDecoration,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                children: [
                  // Text 1 - Graphic Designing
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Graphic Designing',
                          style: mPlusRoundedText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Text 2 - Due Date
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Due Date : Jun 20 2023',
                          style: mPlusRoundedText.copyWith(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Presidency University, Bangalore',
                          style: mPlusRoundedText.copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            // payment details
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Expected Pay : ',
                    style: mPlusRoundedText.copyWith(fontSize: 18),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      color: Colors.yellow,
                      size: 35,
                    ),
                    Text(
                      '400',
                      style: mPlusRoundedText.copyWith(fontSize: 25),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // description
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Description : ',
                style: mPlusRoundedText.copyWith(fontSize: 20),
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. por commodo. Massa vitae tortor condimentum lacinia quis. Diam phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet. Elementum facilisis leo vel fringilla. Neque volutpat ac tincidunt vitae semper quis lectus nulla. Tincidunt praesent semper feugiat nibh sed pulvinar. Proin sed libero enim sed faucibus turpis in. Convallis posuere morbi leo urna molestie at elementum eu facilisis.',
                style: mPlusRoundedText.copyWith(fontSize: 13),
                textAlign: TextAlign.justify,
              ),
            ),
            // attachments
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: boxDecoration,
                    child: Column(
                      children: [
                        Image.asset('lib/images/pdf.png', height: 55),
                        SizedBox(height: 5), // Adjust the spacing as needed
                        Text(
                          'assignment.pdf',
                          style: TextStyle(
                            color: Colors.white, // Set the text color
                            fontSize: 12, // Set the text font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // ad
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: boxDecorationColor,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.done, size: 20, color: Colors.white),
          label: Text(
            'Apply',
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 15), // Add the desired padding
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wizedo/pages/BottomNavigation.dart';
import '../components/CustomRichText.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();// init means initlization
    //here v need to make the splash screen come for 2-4 seconds and then to dashboard.
    Timer(const Duration(milliseconds: 1150),(){
      //here v r using push replacment so if user does back press it won't show splash screen
      //basically splash screen will be replacement with dashboard screen
      //u can also make it route on successful query completion like fetching route on fetchingdata
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavigation()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold background transparent
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(1), // Very light white
                const Color(0xFF955AF2), // Your purplish color
              ],
              stops: const [0.5, 1], // Adjust the stops as needed
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 310,
                    height: MediaQuery.of(context).size.height,
                    child: const Column(
                      children: [
                        Flexible(
                          flex: 1, // Adjust flex as needed
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: CustomRichText(
                                firstText: 'Peer',
                                secondText: 'mate',
                                firstColor: Colors.black,
                                secondColor: Color(0xFF955AF2),
                                firstFontSize: 35,
                                secondFontSize: 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}

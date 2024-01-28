import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/BottomNavigation.dart';

class splashscreen extends StatefulWidget {
  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {// init means initlization
    //here v need to make the splash screen come for 2-4 seconds and then to dashboard.
    Timer(Duration(seconds: 2),(){
      //here v r using push replacment so if user does back press it won't show splash screen
      //basically splash screen will be replacement with dashboard screen
      //u can also make it route on successful query completion like fetching route on fetchingdata
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'lib/images/peermatelogo.png',
            width: Get.width*0.8,
            height: 300,
          ),
        ),
      ),
    );
  }
}

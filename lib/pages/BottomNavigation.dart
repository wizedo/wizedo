import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wizedo/components/mPlusRoundedText.dart';
import '../controller/BottomNavigationController.dart'; // Import your BottomNavigationController file here


class BottomNavigation extends StatelessWidget {
  final BottomNavigationController controller = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color(0xFF14141E),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1),
          child: GNav(
            backgroundColor: Color(0xFF14141E),
            color: Colors.white,
            activeColor: Colors.white,
            curve: Curves.easeInToLinear,
            gap: 10,
            padding: EdgeInsets.all(16),
            onTabChange: (value) {
              controller.index.value=value;
            },
            tabs: [
              GButton(icon: Icons.home, text: 'Home',textStyle: TextStyle(fontSize: 12,color: Colors.white,)),
              GButton(icon: Icons.favorite, text: 'Favorites',textStyle: TextStyle(fontSize: 12,color: Colors.white),),
              GButton(icon: Icons.message, text: 'Chat',textStyle: TextStyle(fontSize: 12,color: Colors.white),),
              GButton(icon: Icons.settings, text: 'Settings',textStyle: TextStyle(fontSize: 12,color: Colors.white),),
            ],
          ),
        ),
      ),
      body: Obx(()=>controller.pages[controller.index.value]),
    );
  }
}

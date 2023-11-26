import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../controller/BottomNavigationController.dart';
import 'detailsPage.dart'; // Import your BottomNavigationController file here

class BottomNavigation extends StatelessWidget {
  final BottomNavigationController controller = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Container(
          width: 52.0,
          height: 52.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // color: Color(0xFF955AF2).withOpacity(0.2)
          ),

          child: Center(
            child: Container(
              width: 45.0,
              height: 45.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF955AF2).withOpacity(0.2),
                // boxShadow: [
                //   BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 5, blurRadius: 1),
                // ],
              ),
              child: Center(
                child: Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF955AF2).withOpacity(0.4),
                  ),
                  child: Center(
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFF955AF2),
                      ),
                      child: FloatingActionButton(
                        heroTag: 'bottom_navigation_fab_hero_tag',
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          // Add your onPressed logic here
                          print('Redirected to Post Page');
                          Get.to(DetailsScreen());
                        },
                        tooltip: 'Apply',
                        child: Icon(Icons.add_rounded, color: Colors.white, size: 20.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF14141E),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: GNav(
            backgroundColor: Color(0xFF14141E),
            color: Colors.white,
            activeColor: Colors.white,
            curve: Curves.easeInToLinear,
            gap: 10,
            padding: EdgeInsets.all(16),
            onTabChange: (value) {
              controller.index.value = value;
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                iconSize: 24, // Adjust the icon size if necessary
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding if necessary
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Favorites',
                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                iconSize: 24, // Adjust the icon size if necessary
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding if necessary
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
              GButton(
                icon: Icons.chat_bubble,
                text: 'Chat',
                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                iconSize: 24, // Adjust the icon size if necessary
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding if necessary
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                iconSize: 24, // Adjust the icon size if necessary
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding if necessary
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
            ],
            tabBackgroundColor: Color(0xFF211B30), // Background color of the active tab
            tabMargin: EdgeInsets.all(8), // Adjust margin if necessary
            tabBorderRadius: 12, // Adjust border radius if necessary
          ),
        ),
      ),

      body: Obx(()=>controller.pages[controller.index.value]),
    );
  }
}

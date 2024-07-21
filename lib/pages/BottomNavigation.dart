import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wizedo/pages/PostPage.dart';
import '../components/debugcusprint.dart';
import '../controller/BottomNavigationController.dart';
// Import your BottomNavigationController file here

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {



  final BottomNavigationController controller = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable back navigation
        return false;
      },
      child: Scaffold(
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
                  color: const Color(0xFF955AF2).withOpacity(0.2),
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
                      color: const Color(0xFF955AF2).withOpacity(0.4),
                    ),
                    child: Center(
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFF955AF2),
                        ),
                        child: FloatingActionButton(
                          heroTag: 'bottom_navigation_fab_hero_tag',
                          backgroundColor: Colors.transparent,
                          onPressed: () async {
                            // SharedPreferences prefs = await SharedPreferences.getInstance();
                            // debugLog('setting postpage values');
                            // await prefs.setString('lastOpenedPage', '');
                            // await prefs.setString('projectName', '');
                            // await prefs.setString('numberOfPages', '');
                            // await prefs.setString('descriptionText', '');
                            // await prefs.setString('datePicker', '');
                            // await prefs.setString('paymentDetails', '');
                            // await prefs.setString('googledrivefilelink', '');
                            // await prefs.setString('selectedCategory', 'College Project');
                            // debugLog('postpage value setting done');
                            // // Add your onPressed logic here
                            debugLog('Redirected to Post Page');
                            Get.to(const RegisterScreen());
                          },
                          tooltip: 'Apply',
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20.0),
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
          color: const Color(0xFF14141E),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: GNav(
              backgroundColor: const Color(0xFF14141E),
              color: Colors.white,
              activeColor: Colors.white,
              curve: Curves.easeInToLinear,
              gap: 8,
              padding: const EdgeInsets.all(16),
              onTabChange: (value) {
                controller.index.value = value;
              },
              tabs: [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                  textStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  iconSize: 24, // Adjust the icon size if necessary
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding if necessary
                  onPressed: () {
                    controller.changePage(0);
                    // Add your onPressed logic here
                  },
                ),
                GButton(
                  icon: Icons.sticky_note_2_rounded,
                  text: 'Proposals',
                  textStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  iconSize: 24, // Adjust the icon size if necessary
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding if necessary
                  onPressed: () {
                    controller.changePage(1);
                  },
                ),
                GButton(
                  icon: Icons.chat_bubble_rounded,
                  text: 'Chat',
                  textStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  iconSize: 23, // Adjust the icon size if necessary
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding if necessary
                  onPressed: () {
                    controller.changePage(2);
                  },
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  textStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  iconSize: 24, // Adjust the icon size if necessary
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding if necessary
                  onPressed: () {
                    controller.changePage(3);
                  },
                ),
              ],
              tabBackgroundColor: const Color(0xFF211B30), // Background color of the active tab
              tabMargin: const EdgeInsets.all(8), // Adjust margin if necessary
              tabBorderRadius: 12, // Adjust border radius if necessary
            ),
          ),
        ),

        body: Obx(() => IndexedStack(
          index: controller.index.value,
          children: controller.pages, // Use the pages from the controller
        )),
      ),
    );
  }
}
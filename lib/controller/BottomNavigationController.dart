import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import '../pages/HomePage.dart';
import '../pages/acceptedJobs.dart';
import '../pages/settings.dart';
import '../pages/ChatHomePage.dart';

class BottomNavigationController extends GetxController {
  RxInt index = 0.obs;

  late final List<Widget> pages;

  @override
  void onInit() {
    super.onInit();
    // Initialize the pages array only once
    pages = [
      HomePage(),
      acceptedPage(),
      ChatHomePage(),
      settingScreen(),
    ];
  }

  // Method to change the selected index
  void changePage(int pageIndex) {
    index.value = pageIndex;
  }
}

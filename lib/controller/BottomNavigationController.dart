import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/HomePage.dart';

import 'package:wizedo/pages/acceptedJobs.dart';
import 'package:wizedo/pages/settings.dart';

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
}


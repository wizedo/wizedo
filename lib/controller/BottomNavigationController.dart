import 'package:get/get.dart';
import 'package:wizedo/pages/HomePage.dart';

import 'package:wizedo/pages/acceptedJobs.dart';
import 'package:wizedo/pages/settings.dart';

import '../pages/ChatHomePage.dart';

class BottomNavigationController extends GetxController {
  RxInt index=0.obs;

  var pages=[
    HomePage(),
    acceptedPage(),
    ChatHomePage(),
    settingScreen(),
  ];
}

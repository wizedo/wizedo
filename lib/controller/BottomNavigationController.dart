import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/LoginPage.dart';
import 'package:wizedo/pages/RegisterPage.dart';
import 'package:wizedo/pages/UserDetailsPage.dart';

class BottomNavigationController extends GetxController {
  RxInt index=0.obs;

  var pages=[
    UserDetails(),
    LoginPage(),
    UserDetails(),
    RegisterPage()
  ];
}

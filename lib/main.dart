// main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/pages/BottomNavigation.dart';
import 'package:wizedo/pages/LoginPage.dart';
import 'package:wizedo/pages/UserDetailsPage.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window).copyWith(textScaleFactor: 1.2),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = snapshot.data as User?;
              if (user == null) {
                // If the user is not authenticated, redirect to LoginPage
                return LoginPage();
              } else {
                // If the user is authenticated, check userDetailsFilled locally
                return checkUserDetailsFilledLocally(context, user.email);
              }
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }

  Widget checkUserDetailsFilledLocally(BuildContext context, String? userEmail) {
    try {
      getUserDetailsFilledLocally(userEmail ?? '').then((userDetailsFilledLocally) async {
        print(userDetailsFilledLocally);
        if (userDetailsFilledLocally == true) {
          print('User details for $userEmail is true');
          // If userDetailsFilled locally is true, redirect to BottomNavigation
          Get.offAll(() => BottomNavigation());
        } else {
            Get.to(() => LoginPage());
        }
      });
      return Container(); // You may need to return a placeholder widget here.
    } catch (error) {
      print('Error checking user details locally: $error');
      // Handle error if needed
      return Scaffold(body: Center(child: Text('Error')));
    }
  }
}

  Future<bool> getUserDetailsFilledLocally(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool userDetailsFilledLocally = prefs.getBool('userDetailsFilled_$email') ?? false;
      return userDetailsFilledLocally;
    } catch (error) {
      print('Error getting user details locally: $error');
      return false;
    }
  }



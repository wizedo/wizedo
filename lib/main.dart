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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      // Fetch userDetailsFilled locally
      getUserDetailsFilledLocally().then((userDetailsFilledLocally) async {
        print(userDetailsFilledLocally);
        if (userDetailsFilledLocally == true) {
          // If userDetailsFilled locally is true, redirect to BottomNavigation
          Get.offAll(() => BottomNavigation());
        } else {
          // If userDetailsFilled locally is false, check email verification
          User? user = FirebaseAuth.instance.currentUser;
          await user?.reload();
          if (user?.emailVerified == true) {
            // If email is verified, redirect to UserDetails
            Get.to(() => UserDetails(userEmail: userEmail ?? ''));
          } else {
            // If email is not verified, stay on the login page or show a message
            // You may want to show a message or handle this case differently
            print('Email is not verified yet.');
          }
        }
      });
      return Container(); // You may need to return a placeholder widget here.
    } catch (error) {
      print('Error checking user details locally: $error');
      // Handle error if needed
      return Scaffold(body: Center(child: Text('Error')));
    }
  }

  Future<bool> getUserDetailsFilledLocally() async {
    try {
      // Use shared preferences to get userDetailsFilled locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('userDetailsFilled') ?? false;
    } catch (error) {
      print('Error getting user details locally: $error');
      return false;
    }
  }
}


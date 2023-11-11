import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/BottomNavigation.dart';
import 'package:wizedo/pages/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window).copyWith(textScaleFactor: 1.2),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This a wizedo project
          // Naresh is gay
          // Naresh is gay 2
          // Vishnu is gay
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Check if the connection to the stream is active.
            if (snapshot.connectionState == ConnectionState.active) {
              // Get the user object from the stream data. It could be null if the user is not authenticated.
              User? user = snapshot.data as User?;
              // If the user is null, redirect to the LoginPage. Otherwise, redirect to the HomePage.
              return user == null ? LoginPage() : BottomNavigation(); // Redirect based on authentication state
            } else {
              // If the connection to the stream is not yet active, show a loading indicator.
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}

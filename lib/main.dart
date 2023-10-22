import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/LoginPage.dart';
import 'package:wizedo/pages/detailsPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //this a wizedo project

//naresh is gay
      //naresh is gay 2
//vishnu is gay
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

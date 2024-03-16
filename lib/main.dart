import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wizedo/pages/LoginPage.dart';
import 'package:wizedo/pages/PostPage.dart';
import 'package:wizedo/pages/SplashScreen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lastOpenedPage = prefs.getString('lastOpenedPage') ?? 'HomePage';
  print('below is lastopenpage');
  print(lastOpenedPage);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: TextScaler.linear(1.2)),
          child: child!,
        );
      },
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
    );
  }

  Widget checkUserDetailsFilledLocally(BuildContext context, String? userEmail) {
    try {
      getUserDetailsFilledLocally(userEmail ?? '').then((userDetailsFilledLocally) async {
        print(userDetailsFilledLocally);
        if (userDetailsFilledLocally == true) {
          print('User details for $userEmail is true');
          // If userDetailsFilled locally is true, navigate to the last opened page
          navigateToLastOpenedPage();
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

  void navigateToLastOpenedPage() async {
    String lastOpenedPage = await getLastOpenedPage();
    switch (lastOpenedPage) {
      case 'RegisterScreen':
        Get.offAll(() => RegisterScreen());
        break;
    // Add cases for other pages if needed
      default:
        Get.offAll(() => splashscreen());
    }
  }

  Future<String> getLastOpenedPage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String lastOpenedPage = prefs.getString('lastOpenedPage') ?? 'splashscreen';
      return lastOpenedPage;
    } catch (error) {
      print('Error getting last opened page: $error');
      return 'splashscreen'; // Default to splashscreen in case of an error
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

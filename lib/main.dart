import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wizedo/controller/dependecy_injection.dart';
import 'package:wizedo/pages/LoginPage.dart';
import 'package:wizedo/pages/SplashScreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'components/debugcusprint.dart';
import 'controller/UserController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDdm7lmUOPjC7CJEtaE3TXJw8e_GXikNiM",
            authDomain: "peermatee.firebaseapp.com",
            projectId: "peermatee",
            storageBucket: "peermatee.appspot.com",
            messagingSenderId: "529074365849",
            appId: "1:529074365849:web:037aebcd135ee063f81f08",
            measurementId: "G-3N3X43LNFT"
        )
    );
  }else{
    await Firebase.initializeApp();
  }



  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.appAttest,//for ios
  );



  if (!kIsWeb) {
    bool jailBroken = await _checkJailBreak();
    if (jailBroken) {
      runApp(const RestrictedApp());
      return;
    }
  }

  await GetStorage.init();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Initialize UserController after Hive and GetStorage
  Get.put(UserController());
  DependecyInjection.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}



Future<bool> _checkJailBreak() async {
  print('in jailbreak');
  try {
    bool isJailBroken = await FlutterJailbreakDetection.jailbroken;// here instead of jailbroken i can use developermmode too
    // print('isjailbroken or not: $isJailBroken');
    return isJailBroken; // Return false if the device is rooted, true otherwise
  } on PlatformException {
    // print('platform exception');
    return false;
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // I like transparent :-)
        systemNavigationBarColor: Color(0xFF14141E), // Navigation bar color
        statusBarIconBrightness: Brightness.light, // Status bar icons' color
        systemNavigationBarIconBrightness: Brightness.light, // Navigation bar icons' color
      ),
      child: GetMaterialApp(
        builder: (BuildContext context, Widget? child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaler: const TextScaler.linear(1.2)),
            child: child!,
          );
        },
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = snapshot.data;
              if (user == null) {
                // If the user is not authenticated, redirect to LoginPage
                return const LoginPage();
              } else {
                // If the user is authenticated, check userDetailsFilled locally
                return FutureBuilder(
                  future: getUserDetailsFilledLocally(),
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      debugLog('Error checking user details locally: ${snapshot.error}');
                      return const Scaffold(body: Center(child: Text('Error')));
                    } else if (snapshot.hasData && snapshot.data == true) {
                      return const splashscreen();
                    } else {
                      return const LoginPage();
                    }
                  },
                );
              }
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<bool> getUserDetailsFilledLocally() async {
  print('in userdetails');
  try {
    var box = await Hive.openBox('userdetails');
    bool userDetailsFilled = box.get('userDetails', defaultValue: {})['userDetailsfilled'] ?? false;
    print('userdetailsfilled is : $userDetailsFilled');
    return userDetailsFilled;
  } catch (error) {
    debugLog('Error getting user details locally: $error');
    return false;
  }
}

class RestrictedApp extends StatelessWidget {
  const RestrictedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Color(0xFF955AF2),
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'Restricted Access',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'This app cannot be used on rooted devices. Please use a non-rooted device.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF955AF2),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Exit App', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
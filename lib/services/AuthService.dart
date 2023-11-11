import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wizedo/pages/BottomNavigation.dart';

class AuthService{
  //Google Sign in
  signInWithGoogle() async{
    //begin interactive sign in process
    final GoogleSignInAccount? gUser=await GoogleSignIn().signIn();
    if(gUser==null){
      return ;
    }
    //obtain the details of the request
    final GoogleSignInAuthentication gAuth= await gUser!.authentication;
    //create a new credential for user
    final credential=GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken

    );
    // finally, let sign in
    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.offAll(() => BottomNavigation());
    //should solve the issue
  }
}


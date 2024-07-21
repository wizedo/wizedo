import 'package:get/get.dart';
import 'network_controller.dart';

class DependecyInjection{
  static void init(){
    // The Get.put() method with the permanent: true argument ensures that the instance of NetworkController will persist for the entire lifecycle of the app.
    Get.put<NetworkController>(NetworkController(),permanent: true);
  }
}
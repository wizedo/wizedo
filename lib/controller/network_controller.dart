import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/white_text.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 3000), _checkInitialConnectivity);
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      isConnected.value = false;
      Get.showSnackbar(
        GetSnackBar(
          borderRadius: 10,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          animationDuration: const Duration(milliseconds: 800),
          duration: const Duration(days: 1),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          snackPosition: SnackPosition.BOTTOM,
          isDismissible: false,
          icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
          backgroundColor: Colors.red.shade400,
          messageText: const WhiteText(
            'Please connect to the internet',
            fontSize: 12,
          ),
        ),
      );
    } else {
      if (Get.isSnackbarOpen) {
        isConnected.value = true;
        Get.closeCurrentSnackbar();
      }
    }
  }
}

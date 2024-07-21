import 'package:flutter/material.dart';

class ColorUtil {
  static Color hexToColor(String hexColor) {
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

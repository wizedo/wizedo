import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../Widgets/colors.dart';

Decoration gradientBoxDecoration = BoxDecoration(
  color: boxDecorationColor,
  borderRadius: BorderRadius.circular(20),
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0x3D515778), Color(0xFF14141E)],
    stops: [0.1,1],
  ),
);
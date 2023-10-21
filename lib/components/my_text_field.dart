import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final bool obsecureText;
  final Icon? prefixIcon; // Optional prefix icon parameter
  final double? fontSize; // Optional font size parameter

  const MyTextField({
    Key? key,
    required this.controller,
    this.label,
    required this.obsecureText,
    this.prefixIcon,
    this.fontSize, // Optional font size parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFF39304D); // Custom color from hex code

    return Container(
      width: 308,
      height: 51,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor,
      ),
      child: TextField(
        controller: controller,
        obscureText: obsecureText,
        style: GoogleFonts.mPlusRounded1c(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 12, // Use provided font size or default to 16
          ),
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: backgroundColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: backgroundColor),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xFFEEEEEE),
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}

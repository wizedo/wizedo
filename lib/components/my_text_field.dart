import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final bool obsecureText;
  final Icon? prefixIcon; // Optional prefix icon parameter

  const MyTextField({
    Key? key,
    required this.controller,
    this.label,
    required this.obsecureText,
    this.prefixIcon, // Optional prefix icon parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFF39304D); // Custom color from hex code

    return Container(
      width: 308, // Set the desired width
      height: 51, // Set the desired height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Add border radius here
        color: backgroundColor, // Set the custom background color
      ),
      child: TextField(
        controller: controller,
        obscureText: obsecureText,
        style: TextStyle(color: Colors.white), // Set text color to white
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ), // Remove the default border
          labelText: label, // Use label text instead of hint text
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

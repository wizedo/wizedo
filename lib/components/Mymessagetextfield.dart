import 'package:flutter/material.dart';

class Mymessagetextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;

  const Mymessagetextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18), // Add border radius here
        color: Colors.grey[200],
      ),
      child: TextField(
        controller: controller,
        obscureText: obsecureText,
        decoration: InputDecoration(
          border: InputBorder.none, // Remove the default border
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

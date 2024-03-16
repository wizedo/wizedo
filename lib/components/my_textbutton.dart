import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the Google Fonts package

class MyTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double? fontSize; // Optional custom font size parameter

  const MyTextButton({
    required this.onPressed,
    required this.buttonText,
    this.fontSize, // Optional custom font size parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF955AF2), textStyle: GoogleFonts.mPlusRounded1c( // Apply the custom font here
          textStyle: TextStyle(
            fontSize: fontSize ?? 16, // Use provided font size or default value (16)
          ),
        ),
      ),
      child: Text(buttonText),
    );
  }
}

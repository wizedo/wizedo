import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final FontWeight? fontWeight; // Optional font weight parameter

  const MyElevatedButton({
    required this.onPressed,
    required this.buttonText,
    this.fontWeight, // Optional font weight parameter
  });

  @override
  Widget build(BuildContext context) {
    Color customPrimaryColor = Color(0xFF955AF2); // Custom color from hex code

    return SizedBox(
      width: 308, // Set the desired width
      height: 51, // Set the desired height
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              customPrimaryColor.withOpacity(0.8), // Start color with opacity
              customPrimaryColor.withOpacity(1.0), // End color with full opacity
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent, // Make the button background transparent
            onPrimary: Colors.white, // Customize the text color
            elevation: 20, // No shadow for the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: GoogleFonts.mPlusRounded1c( // Use the correct font family name
                textStyle: TextStyle(
                  fontSize: 16, // Set your desired font size
                  fontWeight: fontWeight ?? FontWeight.normal, // Use provided font weight or default to normal
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

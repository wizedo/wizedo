import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final FontWeight? fontWeight; // Optional font weight parameter
  final double width;
  final double height;
  final double borderRadius; // Optional border radius parameter
  final Color customPrimaryColor; // Optional custom color parameter
  final double mfontsize;
  final double melevation;

  const MyElevatedButton({
    required this.onPressed,
    required this.buttonText,
    this.fontWeight, // Optional font weight parameter
    this.width = 308, // Default width
    this.height = 51, // Default height
    this.borderRadius = 15, // Default border radius
    this.customPrimaryColor = const Color(0xFF955AF2), // Default custom color
    this.mfontsize=16,
    this.melevation=70
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              customPrimaryColor.withOpacity(0.8),
              customPrimaryColor.withOpacity(1.0),
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: Colors.white,
            elevation: melevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          //task accepted
          //in progress
          //task completed
          child: Center(
            child: Text(
              buttonText,
              style: GoogleFonts.mPlusRounded1c(
                textStyle: TextStyle(
                  fontSize: mfontsize,
                  fontWeight: fontWeight ?? FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

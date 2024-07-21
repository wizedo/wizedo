import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class reddeletebtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final FontWeight? fontWeight; // Optional font weight parameter
  final double width;
  final double height;
  final double borderRadius; // Optional border radius parameter
  final Color customPrimaryColor; // Optional custom color parameter
  final double mfontsize;
  final double melevation;

  reddeletebtn({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.fontWeight, // Optional font weight parameter
    this.width = 308, // Default width
    this.height = 51, // Default height
    this.borderRadius = 15, // Default border radius
    Color? customPrimaryColor, // Optional custom color parameter
    this.mfontsize = 16,
    this.melevation = 0, // No elevation for transparent background
  })  : customPrimaryColor = customPrimaryColor ?? Color(0xFFFF5252).withOpacity(0.4), // Reddish transparent color
        super(key: key);

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
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            foregroundColor: Colors.red, // Red text color
            elevation: melevation,
            side: BorderSide.none,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: GoogleFonts.mPlusRounded1c(
                textStyle: TextStyle(
                  fontSize: mfontsize,
                  fontWeight: fontWeight ?? FontWeight.normal,
                  color: Colors.red, // Red text color
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyUploadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final FontWeight? fontWeight;
  final Widget? suffixIcon; // Optional suffix icon parameter

  const MyUploadButton({super.key, 
    required this.onPressed,
    required this.buttonText,
    this.fontWeight,
    this.suffixIcon, // Optional suffix icon parameter
  });

  @override
  Widget build(BuildContext context) {
    Color customPrimaryColor = const Color(0xFF39304D);

    return SizedBox(
      height: 51,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
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
            foregroundColor: Colors.white, backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    buttonText,
                    style: GoogleFonts.mPlusRounded1c(
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: fontWeight ?? FontWeight.normal,
                      ),
                    ),
                  ),

                ],
              ),
              if (suffixIcon != null) // Display suffix icon if provided
                suffixIcon!,
            ],
          ),

        ),
      ),
    );
  }
}

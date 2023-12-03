import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyUploadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final FontWeight? fontWeight;
  final Widget? suffixIcon; // Optional suffix icon parameter
  final String? fileName; // Optional file name parameter

  const MyUploadButton({
    required this.onPressed,
    required this.buttonText,
    this.fontWeight,
    this.suffixIcon,
    this.fileName, // Optional file name parameter
  });

  @override
  Widget build(BuildContext context) {
    Color customPrimaryColor = Color(0xFF39304D);

    return SizedBox(
      width: 308,
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
            primary: Colors.transparent,
            onPrimary: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  fileName != null ? fileName! : buttonText,
                  style: GoogleFonts.mPlusRounded1c(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: fontWeight ?? FontWeight.normal,
                    ),
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon!,
            ],
          ),
        ),
      ),
    );
  }
}

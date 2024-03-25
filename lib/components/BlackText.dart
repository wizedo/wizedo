import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlackText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlignment;
  final Color? textColor;
  final TextOverflow? overflow; // Add overflow parameter
  final int? maxLines; // Add maxLines parameter


  const BlackText(
      this.text, {
        this.fontSize,
        this.fontWeight,
        this.textAlignment,
        this.textColor,
        this.overflow, // Include overflow parameter
        this.maxLines, // Include maxLines parameter
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.mPlusRounded1c(
        textStyle: TextStyle(
          color: textColor ?? Color(0xFF000000),
          fontSize: 14,
          fontWeight: fontWeight ?? FontWeight.bold,
        ),
      ),
      textAlign: textAlignment,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

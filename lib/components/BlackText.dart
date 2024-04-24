import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlackText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlignment;
  final Color? textColor;
  final TextOverflow? overflow;
  final int? maxLines;

  const BlackText(
      this.text, {
        this.fontSize,
        this.fontWeight,
        this.textAlignment,
        this.textColor,
        this.overflow,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.mPlusRounded1c(
        textStyle: TextStyle(
          color: textColor ?? Color(0xFF000000),
          fontSize: fontSize ?? 14, // Default font size is 14
          fontWeight: fontWeight ?? FontWeight.bold,
        ),
      ),
      textAlign: textAlignment,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}


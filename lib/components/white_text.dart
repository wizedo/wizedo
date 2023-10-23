import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhiteText extends StatelessWidget {
  final String text;
  final double? fontSize; // Make the font size optional
  final FontWeight? fontWeight;
  final TextAlign? textAlignment;

  const WhiteText(this.text, {this.fontSize, this.fontWeight,this.textAlignment}); // Make the font size and weight optional

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.mPlusRounded1c( // Note the correct font family name here
        textStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: fontSize, // Set the font size if provided, otherwise use the default size
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      ),
      textAlign: textAlignment,
    );
  }
}

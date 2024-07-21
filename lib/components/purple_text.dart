import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurpleText extends StatelessWidget {
  final String text;
  final double? fontSize; // Make the font size optional
  final TextAlign? textAlign; // Make the text alignment optional

  const PurpleText(this.text, {super.key, this.fontSize, this.textAlign}); // Make the font size and text alignment optional

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.mPlusRounded1c( // Use the correct font family name
        textStyle: TextStyle(
          color: const Color(0xFF955AF2),
          fontSize: fontSize ?? 15, // Set the font size if provided, otherwise use the default size (15)
        ),
      ),
    );
  }
}

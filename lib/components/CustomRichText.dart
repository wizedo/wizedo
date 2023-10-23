import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRichText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final TextStyle? firstTextStyle;
  final TextStyle? secondTextStyle;
  final Color? firstColor;
  final Color? secondColor;
  final double? firstFontSize;
  final double? secondFontSize;

  CustomRichText({
    required this.firstText,
    required this.secondText,
    this.firstTextStyle,
    this.secondTextStyle,
    this.firstColor,
    this.secondColor,
    this.firstFontSize,
    this.secondFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: (firstTextStyle ?? TextStyle())
                .merge(TextStyle(color: firstColor, fontSize: firstFontSize,fontWeight: FontWeight.bold))
                .merge(GoogleFonts.mPlusRounded1c()), // Apply the desired font family to the first text
          ),
          TextSpan(
            text: secondText,
            style: (secondTextStyle ?? TextStyle())
                .merge(TextStyle(color: secondColor, fontSize: secondFontSize,fontWeight: FontWeight.bold))
                .merge(GoogleFonts.mPlusRounded1c()), // Apply the desired font family to the second text
          ),
        ],
      ),
    );
  }
}

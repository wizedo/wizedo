import 'package:flutter/material.dart';

class WhiteText extends StatelessWidget {
  final String text;
  final double? fontSize; // Make the font size optional

  const WhiteText(this.text, {this.fontSize}); // Make the font size optional

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: fontSize, // Set the font size if provided, otherwise use the default size
      ),
    );
  }
}

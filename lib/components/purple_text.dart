import 'package:flutter/material.dart';

class PurpleText extends StatelessWidget {
  final String text;
  final double? fontSize; // Make the font size optional

  const PurpleText(this.text, {this.fontSize}); // Make the font size optional

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFF955AF2),
        fontSize: fontSize, // Set the font size if provided, otherwise use the default size
      ),
    );
  }
}

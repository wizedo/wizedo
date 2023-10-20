import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final double? fontSize; // Optional font size parameter, default is 12

  const MyButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.fontSize, // Optional font size parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.mPlusRounded1c(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? 12, // Use provided font size or default to 12
              ),
            ),
          ),
        ),
      ),
    );
  }
}

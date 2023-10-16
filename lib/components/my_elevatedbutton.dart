import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double? width;
  final double? height;

  const MyElevatedButton({
    required this.onPressed,
    required this.buttonText,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Color customPrimaryColor = Color(0xFF9959EE); // Create Color object from hex code

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: customPrimaryColor, // Set the custom primary color
        onPrimary: Colors.white, // Customize the text color
        padding: EdgeInsets.symmetric(
          horizontal: width ?? 150, // Use provided width or default value
          vertical: height ?? 14, // Use provided height or default value
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(buttonText),
    );
  }
}

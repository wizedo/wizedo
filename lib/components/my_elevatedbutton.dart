import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const MyElevatedButton({
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    Color customPrimaryColor = Color(0xFF955AF2); // Custom color from hex code

    return SizedBox(
      width: 308, // Set the desired width
      height: 51, // Set the desired height
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: customPrimaryColor, // Set the custom primary color
          onPrimary: Colors.white, // Customize the text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }
}

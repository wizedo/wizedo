import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const MyTextButton({
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: Colors.black, // Customize the text color
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      child: Text(buttonText),
    );
  }
}

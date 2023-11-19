import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? iconWidth;
  final double? iconHeight;
  final double? fontSize;
  final String? hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const MyTextField({
    Key? key,
    required this.controller,
    this.label,
    this.hint,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.iconWidth,
    this.iconHeight,
    this.fontSize,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFF39304D);

    return SizedBox(
      height: widget.validator != null && widget.controller.text.isNotEmpty ? 73 : 51,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 308,
            height: 51,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: backgroundColor,
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              style: GoogleFonts.mPlusRounded1c(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize ?? 16,
                ),
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: Colors.white, fontSize: 13),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: backgroundColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: backgroundColor),
                ),
                labelText: widget.label,
                labelStyle: TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: widget.iconWidth ?? 23,
                    height: widget.iconHeight ?? 23,
                    child: widget.prefixIcon,
                  ),
                )
                    : null,
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
          // Display error message outside the text field
          // if (widget.validator != null && widget.controller.text.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.only(left: 16, top: 4),
          //     child: Text(
          //       widget.validator!(widget.controller.text) ?? '',
          //       style: TextStyle(color: Colors.purple, fontSize: 10),
          //     ),
          //   ),
        ],
      ),
    );
  }
}





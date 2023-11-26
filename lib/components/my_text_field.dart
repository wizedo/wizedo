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
  final Color? textColor; // Added parameter for text color

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
    this.textColor,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validate);
  }

  void _validate() {
    setState(() {
      errorMessage = widget.validator?.call(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFF39304D);
    Color vTextColor = Color(0xFF955AF2);

    return Column(
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
            style: GoogleFonts.mPlusRounded1c(
              textStyle: TextStyle(
                color: widget.textColor ?? Colors.white, // Use optional text color
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
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        if (errorMessage != null && widget.controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              errorMessage!,
              style: TextStyle(color: vTextColor, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validate);
    super.dispose();
  }
}

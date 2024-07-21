import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextMulitilineField extends StatefulWidget {
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
  final double? height; // Added parameter for height
  final double? width; // Added parameter for width
  final Color? backgroundColor; // Added parameter for background color
  final Color? hintTextColor; // Added parameter for hint text color

  const MyTextMulitilineField({
    super.key,
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
    this.height,
    this.width,
    this.backgroundColor, // Initialize the parameter
    this.hintTextColor, // Initialize the parameter
  });

  @override
  _MyTextMulitilineFieldState createState() => _MyTextMulitilineFieldState();
}

class _MyTextMulitilineFieldState extends State<MyTextMulitilineField> {
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
    Color backgroundColor = widget.backgroundColor ?? const Color(0xFF39304D); // Use provided background color or default
    Color vTextColor = const Color(0xFF955AF2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.width ?? 308,
          height: widget.height ?? 51,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backgroundColor, // Use provided background color
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: null, // Set maxLines to null for multiline input
            style: GoogleFonts.mPlusRounded1c(
              textStyle: TextStyle(
                color: widget.textColor ?? Colors.white, // Use optional text color
                fontSize: widget.fontSize ?? 16,
              ),
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: widget.hintTextColor ?? Colors.white, fontSize: 13), // Optional hint text color
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: backgroundColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: backgroundColor),
              ),
              labelText: widget.label,
              labelStyle: const TextStyle(
                color: Color(0xFFEEEEEE),
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Adjust padding for multiline
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
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

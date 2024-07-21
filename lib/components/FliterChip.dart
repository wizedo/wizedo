import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final String selectedCategory;
  final Function onTap;
  final double width;
  final double height;
  final double? fontSize;

  const FilterChipWidget({super.key, 
    required this.label,
    required this.selectedCategory,
    required this.onTap,
    this.width = 100,
    this.height = 30,
    this.fontSize =8,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF39304D);

    return SizedBox(
      width: width,
      height: height,
      child: FilterChip(
        label: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            label,
            style: GoogleFonts.mPlusRounded1c(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: fontSize ?? 11,
              ),
            ),
          ),
        ),
        selected: selectedCategory == label,
        onSelected: (isSelected) {
          if (isSelected) {
            onTap();
          }
        },
        selectedColor: const Color(0xFF955AF2),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide.none,
        ),
      ),
    );
  }
}

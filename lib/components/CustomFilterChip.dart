import 'package:flutter/material.dart';
import 'package:wizedo/components/white_text.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final double chipWidth; // Optional parameter for chip width
  final double chipHeight; // Optional parameter for chip height

  const CustomFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.chipWidth = 120.0, // Default width
    this.chipHeight = 36.0, // Default height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(!isSelected); // Toggle the selected state
      },
      child: Container(
        height: isSelected ? chipHeight : chipHeight - 4.0, // Adjust height as desired
        width: isSelected ? chipWidth : chipWidth - 20.0, // Adjust width as desired
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF955AF2) : const Color(0xFF39304D),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              onSelected(!isSelected); // Toggle the selected state
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Optional padding for text
                child: WhiteText(
                  label,
                  fontSize: 10.4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

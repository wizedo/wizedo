import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Widget? suffixIcon; // New parameter for suffix icon
  final Function(String?)? validator; // New parameter for validator
  final double? width; // New parameter for width

  const DateSelector({
    Key? key,
    required this.controller,
    this.label,
    this.hint,
    this.suffixIcon,
    this.validator, // Include validator parameter
    this.width, // Include width parameter
  }) : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  Future<void> _selectYear(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime next2Months = currentDate.add(Duration(days: 60)); // Add 60 days for the next 2 months

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: null,
      firstDate: currentDate,
      lastDate: next2Months,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      if (widget.validator != null) {
        widget.validator!(widget.controller.text);
      }
    } else {
      print('date is not selected');
      widget.controller.text = 'null'; // Set it to an empty string or null based on your preference
    }

  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFF39304D);

    return GestureDetector(
      onTap: () {
        _selectYear(context);
      },
      child: AbsorbPointer(
        child: Container(
          width: Get.width * 0.85,
          height: 51,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 13),
                      hintText: widget.hint,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: backgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: backgroundColor),
                      ),
                      labelText: widget.label,
                      labelStyle: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                if (widget.suffixIcon != null) // Display suffix icon if provided
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      width: 40, // Adjust the size of the white circle
                      height: 40, // Adjust the size of the white circle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: widget.suffixIcon,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
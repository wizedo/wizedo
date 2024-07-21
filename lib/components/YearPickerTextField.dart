import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YearSelector extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final Widget? suffixIcon;
  final Widget? prefixIcon; // New parameter for prefix icon
  final String? Function(String?)? validator; // New parameter for validator

  const YearSelector({
    super.key,
    required this.controller,
    this.label,
    this.suffixIcon,
    this.prefixIcon, // Include prefixIcon parameter
    this.validator, // Include validator parameter
  });

  @override
  _YearSelectorState createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  Future<void> _selectYear(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 50),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.controller.text) {
      widget.controller.text = DateFormat('yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF39304D);

    return GestureDetector(
      onTap: () {
        _selectYear(context);
      },
      child: AbsorbPointer(
        child: Container(
          width: 308,
          height: 51,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (widget.prefixIcon != null) // Display prefix icon if provided
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: widget.prefixIcon,
                  ),
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    validator: widget.validator, // Set the validator
                  ),
                ),
                if (widget.suffixIcon != null) // Display suffix icon if provided
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: widget.suffixIcon,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

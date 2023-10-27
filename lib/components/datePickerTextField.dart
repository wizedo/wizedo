import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Widget? suffixIcon; // New parameter for suffix icon

  const DateSelector({
    Key? key,
    required this.controller,
    this.label,
    this.hint,
    this.suffixIcon, // Include suffixIcon parameter
  }) : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
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

    if (picked != null) {
      widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
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
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 13,),
                      hintText: widget.hint,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomSuggestionWidget extends StatelessWidget {
  final String suggestion;
  final Color backgroundColor;

  CustomSuggestionWidget({
    required this.suggestion,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: backgroundColor,
      ),
      child: Text(
        suggestion,
        style: TextStyle(color: Colors.white), // Suggestion text color
      ),
    );
  }
}

class SearchableDropdownTextField extends StatefulWidget {
  final List<String> items;
  final String labelText;
  final Function(String)? onSelected;
  final Widget? suffix;

  SearchableDropdownTextField({
    required this.items,
    required this.labelText,
    required this.onSelected,
    this.suffix,
  });

  @override
  _SearchableDropdownTextFieldState createState() => _SearchableDropdownTextFieldState();
}

class _SearchableDropdownTextFieldState extends State<SearchableDropdownTextField> {
  late TextEditingController _textEditingController;
  bool _showNotFoundMessage = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFF39304D);

    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _textEditingController,
        style: TextStyle(color: Colors.white, fontSize: 11.5),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.white, fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: backgroundColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: backgroundColor),
          ),
          filled: true,
          fillColor: backgroundColor,
          suffixIcon: widget.suffix,
        ),
      ),
      suggestionsCallback: (pattern) {
        // Return all options when the input is empty
        return pattern.isEmpty ? widget.items : widget.items.where((item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
      },
      itemBuilder: (BuildContext context, String suggestion) {
        return CustomSuggestionWidget(
          suggestion: suggestion,
          backgroundColor: backgroundColor,
        );
      },
      onSuggestionSelected: (String suggestion) {
        _textEditingController.text = suggestion;
        widget.onSelected?.call(suggestion);
      },
      noItemsFoundBuilder: (BuildContext context) {
        if (_showNotFoundMessage) {
          return ListTile(
            title: Text(
              'Not found',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

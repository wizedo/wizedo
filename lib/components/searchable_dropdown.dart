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
  late FocusNode _focusNode;
  bool _isKeyboardVisible = false;
  bool _showNotFoundMessage = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() => _toggleKeyboardVisibility(_focusNode.hasFocus));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleKeyboardVisibility(bool isVisible) {
    setState(() {
      _isKeyboardVisible = isVisible;
      if (!_isKeyboardVisible) SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color(0xFF39304D);

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        children: [
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              focusNode: _focusNode,
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
              return pattern.isEmpty
                  ? []
                  : widget.items.where((item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
            },
            itemBuilder: (BuildContext context, dynamic suggestion) {
              String suggestionString = suggestion as String;
              return CustomSuggestionWidget(
                suggestion: suggestionString,
                backgroundColor: backgroundColor,
              );
            },
            onSuggestionSelected: (dynamic suggestion) {
              String suggestionString = suggestion as String;
              _textEditingController.text = suggestionString;
              widget.onSelected?.call(suggestionString);
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
                return SizedBox.shrink(); // Hide the message initially
              }
            },
          ),
          if (_isKeyboardVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showNotFoundMessage = false; // Hide the "Not found" message when tapped outside
                  });
                  _toggleKeyboardVisibility(false);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

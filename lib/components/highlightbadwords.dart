import 'package:flutter/material.dart';

TextSpan highlightBadWords(String text, List<String> badWords) {
  List<TextSpan> spans = [];
  int start = 0;

  for (var word in badWords) {
    int index = text.indexOf(word, start);
    if (index >= 0) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index))); // Regular text
      }
      spans.add(TextSpan(text: word, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))); // Highlighted bad word
      start = index + word.length;
    }
  }

  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start))); // Remaining regular text
  }

  return TextSpan(children: spans);
}

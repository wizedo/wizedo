import 'package:flutter/material.dart';

Widget buildLabel(String text) {
  return Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
  );
}

Widget buildTextBox(String text) {
  return TextField(
    enabled: false,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      hintText: text,
    ),
  );
}